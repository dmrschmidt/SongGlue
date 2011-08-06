//
//  GlueView.m
//  Icons
//
//  Created by Dennis Schmidt on 06.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GlueView.h"

@implementation GlueView

@synthesize label = _label;
@synthesize scrollView = _scrollView;
@synthesize index = _index;

- (id)init {
    NSLog(@"creating a new GlueView");
    if(self = [super init]) {
        CGFloat contentOffsetY = [[UIScreen mainScreen] bounds].size.height * 3 / 4;
        
        // set up the label
        self.label = [[UILabel alloc] init];
        self.label.backgroundColor = [UIColor clearColor];
        self.label.font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:23.0];
        self.label.textAlignment = UITextAlignmentCenter;
        self.label.textColor = [UIColor lightTextColor];
        self.label.numberOfLines = 10;
        self.label.shadowColor = [UIColor darkTextColor];
        self.label.shadowOffset = CGSizeMake(0, 1);
        self.label.adjustsFontSizeToFitWidth = YES;
        self.label.minimumFontSize = 7;
        self.label.frame = CGRectMake(10, 100 + contentOffsetY, 300, 200);
        
        // set up the scrollView
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(
                                                0,
                                                0,
                                                [[UIScreen mainScreen] bounds].size.width,
                                                // TODO: get rid of the hardcoded 70 here
                                                [[UIScreen mainScreen] bounds].size.height - 70)];
        self.scrollView.contentSize = CGSizeMake(
                                                 [[UIScreen mainScreen] bounds].size.width,
                                                 ([[UIScreen mainScreen] bounds].size.height - 70) * 3);
        self.scrollView.contentOffset = CGPointMake(0, contentOffsetY);
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.delegate = self;
        
        // set up the hierarchy
        [self addSubview:self.scrollView];
        [self.scrollView addSubview:self.label];
    }
    return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // TODO: make all these thresholds relative
    NSLog(@"offset: %@", [NSNumber numberWithFloat:scrollView.contentOffset.y]);
    // make the content shrink, so it appears as if it would drop into the
    // "Favorites" tab bar icon
    if(scrollView.contentOffset.y < 300) {
        CGPoint oldCenter = self.label.center;
        CGRect oldFrame = self.label.frame;
        CGRect newFrame = CGRectMake(
                                     oldFrame.origin.x,
                                     oldFrame.origin.y,
                                     scrollView.contentOffset.y,
                                     200 * scrollView.contentOffset.y / 300);
        self.label.frame = newFrame;
        self.label.center = oldCenter;
    } else if(scrollView.contentOffset.y >= 360) {
        // fade the text out when flicking to top
        CGFloat newAlpha = 1.0;
        newAlpha = 1.f - (scrollView.contentOffset.y - 360) / 360;
        newAlpha = MAX(MIN(1, newAlpha), 0);
        self.label.alpha = newAlpha;
    }
}

- (void)configureAtIndex:(NSUInteger)index withTitle:(NSString *)title {
    self.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width * index,
                            0,
                            [[UIScreen mainScreen] bounds].size.width,
                            // TODO: get rid of the hardcoded 70 here
                            [[UIScreen mainScreen] bounds].size.height - 70);
    self.index = index;
    
    self.label.text = title;
}

- (void)setTitle:(NSString *)newTitle {
    self.label.text = newTitle;
}

- (void)shake {
    CGPoint center = self.label.center;
    [UIView animateWithDuration:0.1
                     animations:^{self.label.center = CGPointMake(center.x - 20, center.y);}
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.1
                                          animations:^{self.label.center =
                                              CGPointMake(center.x + 20, center.y);}
                                          completion:^(BOOL finished){
                                              [UIView animateWithDuration:0.1
                                                               animations:^{self.label.center = CGPointMake(center.x - 20, center.y);}
                                                               completion:^(BOOL finished){
                                                                   [UIView animateWithDuration:0.1
                                                                                    animations:^{self.label.center = CGPointMake(160.f, center.y);}
                                                                                    completion:^(BOOL finished){}];
                                                               }];
                                          }];
                     }];
    
}


@end
