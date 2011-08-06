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

- (id)init {
    if(self = [super init]) {
        CGFloat contentOffsetY = [[UIScreen mainScreen] bounds].size.height * 3 / 4;
        
        // set up the labels
        [self initLabelsWithContentOffsetY:contentOffsetY];
        
        // set up the scrollView
        CGRect frame = CGRectMake(0, 0, // TODO: get rid of the hardcoded 70 here
                                  [[UIScreen mainScreen] bounds].size.width,
                                  [[UIScreen mainScreen] bounds].size.height - 70);
        self.scrollView = [[UIScrollView alloc] initWithFrame:frame];
        self.scrollView.contentSize = CGSizeMake(frame.size.width, frame.size.height * 3);
        self.scrollView.contentOffset = CGPointMake(0, contentOffsetY);
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.delegate = self;
        
        // set up the hierarchy
        [self addSubview:self.scrollView];
        [self.scrollView addSubview:self.labelView];
    }
    return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
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

- (void)configureAtIndex:(NSUInteger)index withGlue:(Glue *)glue {
    self.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width * index,
                            0,
                            [[UIScreen mainScreen] bounds].size.width,
                            // TODO: get rid of the hardcoded 70 here
                            [[UIScreen mainScreen] bounds].size.height - 70);
    self.index = index;
    
    for(int labelIndex = 0; labelIndex < kLabelCount; labelIndex++) {
        ((UILabel *)[self.labels objectAtIndex:labelIndex]).text = [glue gluePartForIndex:labelIndex];
    }
}

- (void)shake {
    CGPoint center = self.labelView.center;
    [UIView animateWithDuration:0.1
                     animations:^{self.labelView.center = CGPointMake(center.x - 20, center.y);}
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.1
                                          animations:^{self.labelView.center =
                                              CGPointMake(center.x + 20, center.y);}
                                          completion:^(BOOL finished){
                                              [UIView animateWithDuration:0.1
                                                               animations:^{self.labelView.center = CGPointMake(center.x - 20, center.y);}
                                                               completion:^(BOOL finished){
                                                                   [UIView animateWithDuration:0.1
                                                                                    animations:^{self.labelView.center = CGPointMake(160.f, center.y);}
                                                                                    completion:^(BOOL finished){}];
                                                               }];
                                          }];
                     }];
    
}


@end
