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

- (id)initWithIndex:(NSUInteger)index andTitle:(NSString *)title {
    NSLog(@"creating new at index %@", [NSNumber numberWithInt:index]);
    self = [super init];
    if (self) {
        UIFont *font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:23.0];
        
        CGRect frame = CGRectMake(320 * index, 0, 320, 200);
        self.frame = frame;
        self.index = index;
        
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
        self.label.backgroundColor = [UIColor clearColor];
        self.label.font = font;
        self.label.textAlignment = UITextAlignmentCenter;
        self.label.textColor = [UIColor lightTextColor];
        self.label.numberOfLines = 10;
        
        [self setTitle:title];
        [self addSubview:self.label];
    }
    return self;
}

- (void)setTitle:(NSString *)newTitle {
    self.label.text = newTitle;
}


@end
