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

@synthesize labelView = _labelView;
@synthesize labels = _labels;
@synthesize scrollView = _scrollView;
@synthesize index = _index;
@synthesize glue = _glue;

- (void)initLabelsWithContentOffsetY:(CGFloat)contentOffsetY {
    // first, init the label's parent container view
    self.labelView = [[UIView alloc] initWithFrame:CGRectMake(kLabelBorderSides,
                                                              kLabelBorderTop + contentOffsetY,
                                                              kLabelContainerWidth,
                                                              kLabelContainerHeight)];
    self.labelView.autoresizesSubviews = YES;
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
        
        [self.labelView addSubview:label];
        [labels addObject:label];
        [label release];
    }
    self.labels = [NSArray arrayWithArray:labels];
    [labels release];
}

- (void)repositionScrollView {
    CGFloat contentOffsetY = [[UIScreen mainScreen] bounds].size.height * 3 / 4;
    CGRect frame = CGRectMake(0, 0, // TODO: get rid of the hardcoded 70 here
                              [[UIScreen mainScreen] bounds].size.width,
                              [[UIScreen mainScreen] bounds].size.height - 70);
    self.scrollView.frame = frame;
    self.scrollView.contentSize = CGSizeMake(frame.size.width, frame.size.height * 3);
    self.scrollView.contentOffset = CGPointMake(0, contentOffsetY);
}

- (id)init {
    if(self = [super init]) {
        CGFloat contentOffsetY = [[UIScreen mainScreen] bounds].size.height * 3 / 4;
        
        // set up the labels
        [self initLabelsWithContentOffsetY:contentOffsetY];
        
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
    CGPoint oldCenter = self.labelView.center;
    CGRect  oldFrame  = self.labelView.frame;
    
    /* fade the text out when flicking to top */
    CGFloat alphaSpan = kAlphaZeroThreshold - kAnimationThreshold;
    CGFloat currentAlphaOffset = MIN(alphaSpan,
                                     MAX(0, scrollView.contentOffset.y - kAnimationThreshold));
    self.labelView.alpha = 1 - (currentAlphaOffset / alphaSpan);
    
    /* make the content shrink, so it appears as if it would drop into the
     * "Favorites" tab bar icon */
    CGFloat resizeFactor = MIN(kAnimationThreshold, scrollView.contentOffset.y) / kAnimationThreshold;
    CGRect newFrame = CGRectMake(oldFrame.origin.x,
                                 oldFrame.origin.y,
                                 kLabelContainerWidth * resizeFactor,
                                 kLabelContainerHeight * resizeFactor);
    self.labelView.frame = newFrame;
    self.labelView.center = oldCenter;
}

- (void)updateText {
    for(int labelIndex = 0; labelIndex < kLabelCount; labelIndex++) {
        ((UILabel *)[self.labels objectAtIndex:labelIndex]).text = [self.glue gluePartForIndex:labelIndex];
    }
}

- (void)configureAtIndex:(NSUInteger)index withGlue:(Glue *)glue {
    self.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width * index,
                            0,
                            [[UIScreen mainScreen] bounds].size.width,
                            // TODO: get rid of the hardcoded 70 here
                            [[UIScreen mainScreen] bounds].size.height - 70);
    self.index = index;
    self.glue = glue;
    [self repositionScrollView];
    [self updateText];
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

- (void)shake {
    [self shakeHorizontally];
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



@end
