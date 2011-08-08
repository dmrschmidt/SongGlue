//
//  GlueView.m
//  Icons
//
//  Created by Dennis Schmidt on 06.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GlueView.h"

@implementation GlueView

static NSUInteger kLabelCount           =   3;
static CGFloat    kLabelBorderTop       = 120.f;
static CGFloat    kLabelBorderSides     =  10.f;
static CGFloat    kLabelContainerWidth  = 300.f;
static CGFloat    kLabelContainerHeight =  81.f;
static CGFloat    kAnimationThreshold   = 350.f;
static CGFloat    kAlphaZeroThreshold   = 560.f;
static CGFloat    kContentOffsetY       =  -1.f;

@synthesize imageView = _imageView;
@synthesize labelView = _labelView;
@synthesize labels = _labels;
@synthesize scrollView = _scrollView;
@synthesize index = _index;
@synthesize glue = _glue;




// TODO: refactor (move) this method to the GlueGenerator
- (void)updateImage {
    // TODO: don't alloc this each call!
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    // Enumerate just the photos and videos group by using ALAssetsGroupSavedPhotos.
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        // Within the group enumeration block, filter to enumerate just videos.
        [group setAssetsFilter:[ALAssetsFilter allPhotos]];
        
        // For this example, we're only interested in the first item.
        NSUInteger count = [group numberOfAssets];
        if(count > 0) {
            NSUInteger index = arc4random() % count;
            NSLog(@"count: %@, index: %@", [NSNumber numberWithInt:count], [NSNumber numberWithInt:index]);
            [group enumerateAssetsAtIndexes:[NSIndexSet indexSetWithIndex:index]
                                    options:0
                                 usingBlock:^(ALAsset *alAsset, NSUInteger index, BOOL *innerStop) {
                                     
                // The end of the enumeration is signaled by asset == nil.
                if (alAsset) {
                    ALAssetRepresentation *representation = [alAsset defaultRepresentation];
                    // Do something interesting with the AV asset.
                    self.imageView.image = [UIImage imageWithCGImage:[representation fullResolutionImage]];
                }
            }];
        }
    }
        failureBlock: ^(NSError *error) {
            // Typically you should handle an error more gracefully than this.
            NSLog(@"No groups");
    }];
    [library release];
}

// TODO: can I actually get rid of kContentOffsetY now, since the vertical scrollbar
// will never differ in contentOffset anymore?
- (void)initLabelsWithContentOffsetY:(CGFloat)contentOffsetY {
    // first, init the label's parent container view
    self.labelView = [[UIView alloc] initWithFrame:CGRectMake(kLabelBorderSides,
                                                              kLabelBorderTop + contentOffsetY,
                                                              kLabelContainerWidth,
                                                              kLabelContainerHeight)];
    self.labelView.autoresizesSubviews = YES;
    // TODO: make the image view a property, of course
    // TODO: also, make the imageView a sperate view
    CGRect frame = CGRectMake(0, 0, 200, 200);
    self.imageView = [[UIImageView alloc] initWithFrame:frame];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    NSMutableArray *labels = [[NSMutableArray alloc] initWithCapacity:kLabelCount];
    
    for(int labelIndex = 0; labelIndex < kLabelCount; labelIndex++) {
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:23.0];
        label.textAlignment = UITextAlignmentCenter;
        label.textColor = [UIColor lightTextColor];
        label.numberOfLines = 1;
        label.shadowColor = [UIColor darkTextColor];
        label.shadowOffset = CGSizeMake(0, 1);
        label.adjustsFontSizeToFitWidth = YES;
        label.minimumFontSize = 3;
        label.lineBreakMode = UILineBreakModeTailTruncation;
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        label.frame = CGRectMake(5,
                                 (kLabelContainerHeight / kLabelCount) * labelIndex,
                                 kLabelContainerWidth - 10,
                                 (kLabelContainerHeight / kLabelCount));
        
        
        [self.labelView addSubview:self.imageView];
        [self.imageView addSubview:label];
//        [self.labelView addSubview:label];
        [labels addObject:label];
        [label release];
    }
    self.labels = [NSArray arrayWithArray:labels];
    [labels release];
}

- (void)repositionScrollView {
    CGRect frame = CGRectMake(0, 0,
                              [[UIScreen mainScreen] bounds].size.width,
                              [[UIScreen mainScreen] bounds].size.height);
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
        [self initLabelsWithContentOffsetY:kContentOffsetY];
        
        // set up the scrollView
        self.scrollView = [[UIScrollView alloc] init];
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.delegate = self;
        [self repositionScrollView];
        
        // set up the hierarchy
        [self addSubview:self.scrollView];
        [self.scrollView addSubview:self.labelView];
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
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight
                           forView:self
                             cache:YES];
    [self updateText];
    [UIView commitAnimations];
}

- (void)shuffle {
    [self.glue shuffle];
    [self updateText];
}

#pragma mark -
#pragma mark Configuring

- (void)configureAtIndex:(NSUInteger)index withGlue:(Glue *)glue {
    self.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width * index,
                            0,
                            [[UIScreen mainScreen] bounds].size.width,
                            [[UIScreen mainScreen] bounds].size.height);
    self.index = index;
    self.glue = glue;
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
                     animations:^{self.labelView.center = CGPointMake(newCenterX, center.y);}
                     completion:^(BOOL finished){ [self shakeRecursiveStartingAt:(loopCount+1)]; }];
}

- (void)shakeHorizontally {
    center = self.labelView.center;
    [self shakeRecursiveStartingAt:0];
}

- (void)shakeVerticalRecursiveStartingAt:(NSUInteger)loopCount {
    if(loopCount > 4) {
        isShaking = NO;
        return;
    }
    isShaking = YES;
    CGFloat newCenterY = center.y + (10 * pow(-1, loopCount));
    if(loopCount == 4) newCenterY = center.y;
    [UIView animateWithDuration:0.05
                     animations:^{self.labelView.center = CGPointMake(center.x, newCenterY);}
                     completion:^(BOOL finished){
                         [self shakeVerticalRecursiveStartingAt:(loopCount+1)];
                     }
     ];
}

- (void)shakeVertical {
    center = self.labelView.center;
    [self shakeVerticalRecursiveStartingAt:0];
}

- (void)shake {
    [self shakeHorizontally];
}

@end
