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
        // set up the label
        self.label = [[UILabel alloc] init];
        self.label.backgroundColor = [UIColor clearColor];
        self.label.font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:23.0];
        self.label.textAlignment = UITextAlignmentCenter;
        self.label.textColor = [UIColor lightTextColor];
        self.label.numberOfLines = 10;
        self.label.shadowColor = [UIColor darkTextColor];
        self.label.shadowOffset = CGSizeMake(0, 1);
        self.label.frame = CGRectMake(10, 300, 300, 200);
        
        // set up the scrollView
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(
                                                0,
                                                0,
                                                [[UIScreen mainScreen] bounds].size.width,
                                                // TODO: get rid of the hardcoded 70 here
                                                [[UIScreen mainScreen] bounds].size.height - 70)];
        self.scrollView.contentSize = CGSizeMake(
                                                 [[UIScreen mainScreen] bounds].size.width,
                                                 [[UIScreen mainScreen] bounds].size.height * 2);
        self.scrollView.contentOffset = CGPointMake(0, 200);
        
        // set up the hierarchy
        [self addSubview:self.scrollView];
        [self.scrollView addSubview:self.label];
    }
    return self;
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
