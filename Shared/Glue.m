//
//  Glue.m
//  Icons
//
//  Created by Dennis Schmidt on 06.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>
#import "Glue.h"

@implementation Glue

@synthesize mediaItems = _mediaItems;

- (id)initWithMediaItems:(NSArray *)mediaItems {
    self = [super init];
    if (self) {
        self.mediaItems = mediaItems;
        

        
    }
    
    return self;
}

- (NSString *)gluedString {
    NSMutableString *shuffledText = [[NSMutableString alloc] init];
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\([^)]*\\)"
                                                                           options:0
                                                                             error:&error];
    for(MPMediaItem *mediaItem in self.mediaItems) {
        NSString *songTitle = [NSString stringWithString:[mediaItem valueForProperty: MPMediaItemPropertyTitle]];
        
        // remove brackets
        NSString *modifiedString = [regex stringByReplacingMatchesInString:songTitle
                                                                   options:0
                                                                     range:NSMakeRange(0, [songTitle length])
                                                              withTemplate:@""];
        
        [shuffledText appendString:modifiedString];
        [shuffledText appendString:@"\n"];
    }
    return [shuffledText autorelease];
}

@end
