//
//  InfiniteScrollView.m
//  Icons
//
//  Created by Dennis Schmidt on 06.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "InfiniteScrollView.h"

@implementation InfiniteScrollView

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark -
#pragma mark Layout

- (void)recenterIfNecessary {
    CGPoint currentOffset = [self contentOffset];
    CGFloat contentWidth = [self contentSize].width;
    CGFloat centerOffsetX = (contentWidth - [self bounds].size.width) / 2.0;
    CGFloat distanceFromCenter = fabs(currentOffset.x - centerOffsetX);
    
    if(distanceFromCenter > (contentWidth / 4.0)) {
        self.contentOffset = CGPointMake(centerOffsetX, currentOffset.y);
        
        // move the old stuff back over
//        for(UIView *subView in ((GlueViewController *)self.delegate).visiblePages) {
//            CGPoint center = subView.center;
//            center.x = (centerOffsetX - currentOffset.x);
//            subView.center = center;
//        }
    }
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
//    [self recenterIfNecessary];
}

@end
