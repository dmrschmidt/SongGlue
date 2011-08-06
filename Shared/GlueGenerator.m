//
//  GlueGenerator.m
//  Icons
//
//  Created by Dennis Schmidt on 06.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GlueGenerator.h"

@implementation GlueGenerator

static GlueGenerator* sharedInstance = nil;

@synthesize itemsFromGenericQuery = _itemsFromGenericQuery;


+ (GlueGenerator *)sharedInstance {
    if(!sharedInstance) {
        sharedInstance = [[GlueGenerator alloc] init];
    }
    return sharedInstance;
}

+ (Glue *)randomGlue {
    return [[GlueGenerator sharedInstance] randomGlue];
}

- (id)init {
    self = [super init];
    if (self) {
        // initially cache the data
        [self setItemsFromGenericQuery:[[MPMediaQuery songsQuery] items]];
    }
    
    return self;
}

- (Glue *)randomGlue {
    NSMutableArray *mediaItems = [[NSMutableArray alloc] initWithCapacity:3];
    for(NSUInteger i = 0; i < 3; i++) {
        NSUInteger songItemIndex = arc4random() % [[self itemsFromGenericQuery] count];
        MPMediaItem *mediaItem = [[self itemsFromGenericQuery] objectAtIndex:songItemIndex];
        [mediaItems addObject:mediaItem];
    }
    Glue *newGlue = [[Glue alloc] initWithMediaItems:mediaItems];
    
    return [newGlue autorelease];
}

@end
