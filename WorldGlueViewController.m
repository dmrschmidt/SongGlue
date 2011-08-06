//
//  WorldGlueViewController.m
//  Icons
//
//  Created by Dennis Schmidt on 06.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WorldGlueViewController.h"

@implementation WorldGlueViewController

- (GlueView *)buildGlueView {
    GlueView *glueView = [super buildGlueView]; 
    glueView.labelView.frame = CGRectMake(glueView.labelView.frame.origin.x,
                                          glueView.labelView.frame.origin.y + 180,
                                          glueView.labelView.frame.size.width,
                                          glueView.labelView.frame.size.width);
    glueView.scrollView.scrollEnabled = NO;
    return glueView;
}

@end
