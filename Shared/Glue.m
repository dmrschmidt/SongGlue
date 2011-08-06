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
@synthesize generationMode = _generationMode;

- (id)initWithMediaItems:(NSArray *)mediaItems {
    self = [super init];
    if (self) {
        self.mediaItems = mediaItems;
        // set default generation mode
        _generationMode = GGGenerationModeDefault;
    }
    return self;
}

/*
 * Returns the MPMediaItemProperty for the corresponding index, depending
 * on the currently set GGGenerationMode.
 */
- (NSString *const) mediaItemPropertyForIndex:(NSUInteger)index {
    switch (self.generationMode) {
        case GGGenerationModeMixed:
            switch(index) {
                case 0:  return MPMediaItemPropertyArtist;
                case 1:  return MPMediaItemPropertyAlbumTitle;
                case 2:  return MPMediaItemPropertyTitle;
                default: break;
            }
        case GGGenerationModeSongNames:
        default:
            return MPMediaItemPropertyTitle;
    }
}

- (NSString *)gluePartForIndex:(NSUInteger)index {
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\([^)]*\\)"
                                                                           options:0
                                                                             error:&error];
    MPMediaItem *mediaItem = [self.mediaItems objectAtIndex:index];
    NSString *property = [NSString stringWithString:[mediaItem valueForProperty:
                                                      [self mediaItemPropertyForIndex:index]]];
    
    // remove brackets
    NSString *modifiedString = [regex stringByReplacingMatchesInString:property
                                                               options:0
                                                                 range:NSMakeRange(0, [property length])
                                                          withTemplate:@""];
    return modifiedString;
}

- (void)toggleGenerationMode {
    self.generationMode = (self.generationMode + 1) % 2;
}

- (NSString *)gluedString {
    NSMutableString *shuffledText = [[NSMutableString alloc] init];
    
    for(int index = 0; index < [self.mediaItems count]; index++) {
        [shuffledText appendString:[self gluePartForIndex:index]];
        [shuffledText appendString:@"\n"];
    }
    return [shuffledText autorelease];
}

@end
