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

- (BOOL)array:(NSArray *)array1 equalsArray:(NSArray *)array2 {
    BOOL areEqual = [array1 count] == [array2 count];
    NSUInteger arrayIndex = -1;
    while(areEqual && ++arrayIndex < [array1 count]) {
        areEqual &= ([array1 objectAtIndex:arrayIndex] == [array2 objectAtIndex:arrayIndex]);
    }
    return areEqual;
}

- (void)shuffle {
    NSMutableArray *originalArray = [NSMutableArray arrayWithArray:self.mediaItems];
    NSMutableArray *shuffleArray = [NSMutableArray arrayWithArray:self.mediaItems];
    // Here we want the list to ALWAYS be (randomly) different from the state before.
    // NSMutableArray#shuffle is OK as is, but it doesn't meet this requirement due
    // to it's "real" randomness (shuffle called twice could result in same order).
    while([self array:shuffleArray equalsArray:originalArray]) {
        [shuffleArray shuffle];
    }
    self.mediaItems = shuffleArray;
}

- (NSString *)gluePartForIndex:(NSUInteger)index {
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\([^)]*\\)"
                                                                           options:0
                                                                             error:&error];
//    self.mediaItems so
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
