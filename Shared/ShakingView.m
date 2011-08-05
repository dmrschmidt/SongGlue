//
//  ShakingView.m
//  Icons
//
//  Created by Dennis Schmidt on 05.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ShakingView.h"

@implementation ShakingView

@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"shaky view loaded");
    }
    return self;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if ( event.subtype == UIEventSubtypeMotionShake ) {
        [self.delegate updateTitle:self];
    }
    
    if ( [super respondsToSelector:@selector(motionEnded:withEvent:)] )
        [super motionEnded:motion withEvent:event];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

@end
