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
@synthesize index = _index;

- (id)init {
    NSLog(@"creating a new GlueView");
    if(self = [super init]) {
        self.label = [[UILabel alloc] init];
        self.label.backgroundColor = [UIColor clearColor];
        self.label.font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:23.0];
        self.label.textAlignment = UITextAlignmentCenter;
        self.label.textColor = [UIColor lightTextColor];
        self.label.numberOfLines = 10;
        self.label.frame = CGRectMake(0, 0, 320, 200);
        
        [self addSubview:self.label];
    }
    return self;
}

- (void)configureAtIndex:(NSUInteger)index withTitle:(NSString *)title {
    self.frame = CGRectMake(320 * index, 0, 320, 200);
    self.index = index;
    
    self.label.text = title;
}

- (void)setTitle:(NSString *)newTitle {
    self.label.text = newTitle;
}


@end
