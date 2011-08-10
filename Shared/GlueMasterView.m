//
//  GlueView.m
//  Icons
//
//  Created by Dennis Schmidt on 06.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GlueMasterView.h"

@implementation GlueMasterView

static NSUInteger kLabelCount           =   3;
static CGFloat    kBorderViewBorderTop  =  40.f;
static CGFloat    kBorderViewWidth      = 290.f;
static CGFloat    kBorderViewHeight     = 313.f;
static CGFloat    kImageViewHeight      = 232.f;
static CGFloat    kImageViewBorderTop   =  32.f;
static CGFloat    kLabelBorderTop       =  0.f;
static CGFloat    kLabelBorderSides     =  -5.f;
static CGFloat    kLabelContainerWidth  = 280.f;
// the 400 is quite random!
static CGFloat    kLabelContainerHeight = 400.f;
static CGFloat    kAnimationThreshold   = 350.f;
static CGFloat    kAlphaZeroThreshold   = 560.f;
static CGFloat    kContentOffsetY       =  -1.f;

@synthesize borderImageView = _borderImageView;
@synthesize imageView = _imageView;
@synthesize labelView = _labelView;
@synthesize labels = _labels;
@synthesize scrollView = _scrollView;
@synthesize index = _index;
@synthesize glue = _glue;
@synthesize detailView = _detailView;

ALAssetsLibrary *_library = nil;
BOOL _isGettingImage = NO;


- (ALAssetsLibrary *)library {
    if(!_library) {
        _library = [[ALAssetsLibrary alloc] init];
    }
    return _library;
}

- (CGSize)getMinimalSizeForSize:(CGSize)size {
    // TODO: make this maxWidth generic
    //       also, (maybe) don't assume that width is always bigger than height
    //       note: the *2 is for the Retina support
    CGFloat maxWidth = (kLabelContainerWidth - 20) * 2;
    CGFloat scale = maxWidth / size.width;
    CGSize newSize = CGSizeMake(maxWidth,
                                scale * size.height);
    return newSize;
}

- (void)getImage {
    // set up the thread's own NSAutoreleasePool here
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    @synchronized(self) {
        _isGettingImage = YES;
    }
    
    // Enumerate just the photos and videos group by using ALAssetsGroupSavedPhotos.
    [[self library] enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        // Within the group enumeration block, filter to enumerate just videos.
        [group setAssetsFilter:[ALAssetsFilter allPhotos]];
        
        // For this example, we're only interested in the first item.
        NSUInteger count = [group numberOfAssets];
        if(count > 0) {
            NSUInteger randomIndex = arc4random() % count;
            [group enumerateAssetsAtIndexes:[NSIndexSet indexSetWithIndex:randomIndex]
                                    options:0
                                 usingBlock:^(ALAsset *alAsset, NSUInteger index, BOOL *innerStop) {
                                     
                                     // The end of the enumeration is signaled by asset == nil.
                                     if (alAsset) {
                                         ALAssetRepresentation *representation = [alAsset defaultRepresentation];
                                         // Do something interesting with the AV asset.
                                         UIImage *rawImage = [UIImage imageWithCGImage:[representation fullResolutionImage]
                                                                                 scale:1.0
                                                                           orientation:(UIImageOrientation)[representation orientation]];
                                         CGSize newSize = [self getMinimalSizeForSize:rawImage.size];
                                         UIGraphicsBeginImageContext(newSize);
                                         [rawImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
                                         UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
                                         UIGraphicsEndImageContext();
                                         self.imageView.image = newImage;
                                         [_imageSpinner stopAnimating];
                                     }
                                 }];
        }
    }
                                failureBlock: ^(NSError *error) {
                                    // TODO: some clever error handling here
                                    NSLog(@"No groups");
                                }];
    @synchronized(self) {
        _isGettingImage = NO;
    }
    [pool release];
}

// TODO: refactor (move) this method to the GlueGenerator
- (void)updateImage {
    @synchronized(self) {
        if(!_isGettingImage) {
            [NSThread detachNewThreadSelector:@selector(getImage) toTarget:self withObject:nil];
        }
    }
}

- (void)resetImage {
    self.imageView.image = nil;
    [_imageSpinner startAnimating];
}

- (void)initLabels {
    // first, init the label's parent container view
    self.labelView = [[UIView alloc] initWithFrame:CGRectMake(kLabelBorderSides,
                                                              kLabelBorderTop,
                                                              kLabelContainerWidth,
                                                              kLabelContainerHeight)];
    self.labelView.autoresizesSubviews = YES;
    
    NSMutableArray *labels = [[NSMutableArray alloc] initWithCapacity:kLabelCount];
    for(int labelIndex = 0; labelIndex < kLabelCount; labelIndex++) {
        // TODO: make these calculations a bit more relative
        CGFloat fontSize = (labelIndex == 0) ? 23.0 : 17.0;
        CGFloat height = (labelIndex == 0) ? 28.0 : 25.f;
        CGFloat offsetY = (labelIndex == 0) ? 0 : ((labelIndex == 1) ? 267 : 288);
        
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:fontSize];
        label.textAlignment = UITextAlignmentCenter;
        label.textColor = [UIColor lightTextColor];
        label.numberOfLines = 1;
//        label.backgroundColor = [UIColor grayColor]; // positioning test
        label.shadowColor = [UIColor darkTextColor];
        label.shadowOffset = CGSizeMake(0, 1);
        label.adjustsFontSizeToFitWidth = YES;
        label.minimumFontSize = 3;
        label.lineBreakMode = UILineBreakModeTailTruncation;
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        label.frame = CGRectMake(15, offsetY, kLabelContainerWidth - 10, height);
        
        [self.labelView addSubview:label];
        [labels addObject:label];
        [label release];
    }
    
    self.labels = [NSArray arrayWithArray:labels];
    [labels release];
}

- (void)repositionScrollView {
    CGRect frame = CGRectMake(15, kBorderViewBorderTop, kBorderViewWidth, kBorderViewHeight);
    self.scrollView.frame = frame;
    // This one pixel being added to height is to make the (vertival) scrollbar have
    // this "bounce back" effect. If contentSize equaled the actual (frame) size, it
    // would simply disable scrolling automatically.
    // Just adding +1 to it keeps the effect, but we still don't need to care about
    // re-positioning. Only one pixel difference in position will not be percepted
    // by users in the context of the labels.
    self.scrollView.contentSize = CGSizeMake(frame.size.width, frame.size.height + 1);
    self.scrollView.contentOffset = CGPointMake(0, kContentOffsetY);
}

- (id)init {
    if(self = [super init]) {
        // set up the labels
        [self initLabels];
        
        // set up the scrollView
        self.scrollView = [[UIScrollView alloc] init];
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.delegate = self;
        self.scrollView.clipsToBounds = NO;
        [self repositionScrollView];
        
        // TODO: Make the imageView a sperate view, which will hold the black border.
        // TODO: Make the frame setting better. (not hardcoded)              // 313 = current size of black background image
        // TODO: Refactor, such as that borderImageView becomes extracted to a new class.
        //       This should clean up the process of master-detail swapping.
        CGRect frame = CGRectMake(0, 0,
                                  self.scrollView.bounds.size.width,
                                  self.scrollView.bounds.size.height);
        self.borderImageView = [[UIImageView alloc] initWithFrame:frame];
        self.borderImageView.image = [UIImage imageNamed:@"black_border"];
        self.borderImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.borderImageView.clipsToBounds = YES;
        
        frame = CGRectMake(12, kImageViewBorderTop, kBorderViewWidth - 25, kImageViewHeight);
        self.imageView = [[UIImageView alloc] initWithFrame:frame];
        self.imageView.clipsToBounds = YES;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        // set up the hierarchy
        [self addSubview:self.scrollView];
        [self.scrollView addSubview:self.borderImageView];
        [self.borderImageView addSubview:self.imageView];
        [self.borderImageView addSubview:self.labelView];
        
        // add a spinner view
        _imageSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self.borderImageView addSubview:_imageSpinner];
        _imageSpinner.center = CGPointMake(round(CGRectGetWidth(self.borderImageView.bounds) / 2),
                                           round(CGRectGetHeight(self.borderImageView.bounds) / 2));
        [self resetImage];
    }
    return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    /* 
     * TODO:
     * IF POSSIBLE, USE ZOOMING TO "FAKE" SHRINKING OF THE TEXT!
     * IT SHOULD ACTUALLY BE POSSIBLE TO ZOOM IN AND OUT OF A SCROLLVIEW
     * SUCH AS IT IS ALSO POSSIBLE TO REPOSITION IT'S CONTENT OFFSET.
     * THE ANIMATION WOULD THAN BE REALLY SMOOTH (OR SO I GUESS) AND
     * THERE SHOULD BE NO "GLITCHES" WITH THE LABELS EITHER.
     */
    // store the old center and frame
//    CGPoint oldCenter = self.labelView.center;
//    CGRect  oldFrame  = self.labelView.frame;
    
    /* fade the text out when flicking to top */
    CGFloat alphaSpan = kAlphaZeroThreshold - kAnimationThreshold;
    CGFloat currentAlphaOffset = MIN(alphaSpan,
                                     MAX(0, scrollView.contentOffset.y - kAnimationThreshold));
    self.labelView.alpha = 1 - (currentAlphaOffset / alphaSpan);
    
    /* make the content shrink, so it appears as if it would drop into the
     * "Favorites" tab bar icon */
//    CGFloat resizeFactor = MIN(kAnimationThreshold, scrollView.contentOffset.y) / kAnimationThreshold;
//    CGRect newFrame = CGRectMake(oldFrame.origin.x,
//                                 oldFrame.origin.y,
//                                 kLabelContainerWidth * resizeFactor,
//                                 kLabelContainerHeight * resizeFactor);
//    self.labelView.frame = newFrame;
//    self.labelView.center = oldCenter;
}

#pragma mark -
#pragma mark Text Display Mode changing

- (void)updateText {
    for(int labelIndex = 0; labelIndex < kLabelCount; labelIndex++) {
        ((UILabel *)[self.labels objectAtIndex:labelIndex]).text = [self.glue gluePartForIndex:labelIndex];
    }
}

- (IBAction)toggleDisplayMode:(id)sender {
    [self.glue toggleGenerationMode];
    [self updateText];
}

- (IBAction)toggleDetailView:(id)sender {
    // TODO: Let this actually REALLY swap the content, by really releasing the view
    //       and removing it from it's parent view. Then, initializing the new view
    //       and adding that as the new subview.
    if(!self.detailView) {
        self.detailView = [[[[NSBundle mainBundle] loadNibNamed:@"GlueDetailView" owner:self options:nil] objectAtIndex:0] retain];
//        self.detailView.center = self.borderImageView.center;
        self.detailView.hidden = YES;
        [self.borderImageView addSubview:self.detailView];
    }
    self.detailView.hidden = !self.detailView.hidden;
}

- (void)shuffle {
    [self.glue shuffle];
    [self updateText];
}

#pragma mark -
#pragma mark Configuring

- (void)configureAtIndex:(NSUInteger)index withGlue:(Glue *)glue {
    NSLog(@"putting at index: %@", [NSNumber numberWithInt:index]);
    self.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width * index,
                            0,
                            [[UIScreen mainScreen] bounds].size.width,
                            [[UIScreen mainScreen] bounds].size.height);
    self.index = index;
    self.glue = glue;
    [self.detailView setHidden:YES];
    [self repositionScrollView];
    [self updateImage];
    [self updateText];
}

#pragma mark -
#pragma mark Shaking functionality

CGPoint center;
BOOL isShaking = NO;

- (void)shakeRecursiveStartingAt:(NSUInteger)loopCount {
    if(loopCount > 4) {
        isShaking = NO;
        return;
    }
    isShaking = YES;
    CGFloat newCenterX = center.x + (20 * pow(-1, loopCount));
    if(loopCount == 4) newCenterX = center.x;
    [UIView animateWithDuration:0.1
                     animations:^{self.borderImageView.center = CGPointMake(newCenterX, center.y);}
                     completion:^(BOOL finished){ [self shakeRecursiveStartingAt:(loopCount+1)]; }];
}

- (void)shakeHorizontally {
    center = self.borderImageView.center;
    [self shakeRecursiveStartingAt:0];
}

- (void)shakeVerticalRecursiveStartingAt:(NSUInteger)loopCount {
    if(loopCount > 4) {
        isShaking = NO;
        // TODO: Don't do this while user is "holding onto" the image, i.e. touching
        //       the phone while shaking. (think about it, though, but on first glance
        //       it seems like an intuitive thing to do.
        //       USER TEST!!!
        // TODO: Refactor this into a callback method or something else. The thing is,
        //       we need to call the updateImage AFTER the shake animation, cause
        //       otherwise the same thread will be used and the animation won't show
        //       since image loading takes a bit. Also: do it in horizontal shaking as well!
//        [self updateImage];
        return;
    }
    isShaking = YES;
    CGFloat newCenterY = center.y + (10 * pow(-1, loopCount));
    if(loopCount == 4) newCenterY = center.y;
    [UIView animateWithDuration:0.05
                     animations:^{self.borderImageView.center = CGPointMake(center.x, newCenterY);}
                     completion:^(BOOL finished){
                         [self shakeVerticalRecursiveStartingAt:(loopCount+1)];
                     }
     ];
}

- (void)shakeVertical {
    center = self.borderImageView.center;
    [self shakeVerticalRecursiveStartingAt:0];
}

- (void)shake {
    [self shakeHorizontally];
}

- (void)dealloc {
    [super dealloc];
    [self.detailView release];
}

@end
