//
//  ImageGrabber.m
//  Icons
//
//  Created by Dennis Schmidt on 07.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ImageGrabber.h"

@implementation ImageGrabber

@synthesize delegate = _delegate;
@synthesize activeRequest = _activeRequest;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)requestImage {
    
}

- (void)cancelImageRequest {
    
}

- (void)dealloc {
    [_activeRequest release];
    
    [super dealloc];
}

@end
