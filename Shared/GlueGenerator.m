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

- (id)init {
    self = [super init];
    if (self) {
        // initially cache the data
        [self setItemsFromGenericQuery:[[MPMediaQuery songsQuery] items]];
    }
    
    return self;
}

- (NSString *)randomTitle {
    NSMutableString *shuffledText = [[NSMutableString alloc] init];
    
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\([^)]*\\)"
                                                                           options:0
                                                                             error:&error];
    
    for(NSUInteger i = 0; i < 3; i++) {
        NSUInteger songItemIndex = arc4random() % [[self itemsFromGenericQuery] count];
        MPMediaItem *song = [[self itemsFromGenericQuery] objectAtIndex:songItemIndex];
        NSString *songTitle = [NSString stringWithString:[song valueForProperty: MPMediaItemPropertyTitle]];
        
        // remove brackets
        NSString *modifiedString = [regex stringByReplacingMatchesInString:songTitle
                                                                   options:0
                                                                     range:NSMakeRange(0, [songTitle length])
                                                              withTemplate:@""];
        
        [shuffledText appendString:modifiedString];
        if(i < 2) [shuffledText appendString:@"\n"];
    }
    
    return [shuffledText autorelease];
}

@end
