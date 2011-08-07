//
//  Glue.h
//  Icons
//
//  Created by Dennis Schmidt on 06.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSMutableArray+Shuffling.h"

enum {
    GGGenerationModeDefault   = 0,
    GGGenerationModeSongNames = 0,
    GGGenerationModeMixed     = 1 << 0
};
typedef NSUInteger GGGenerationMode;

@interface Glue : NSObject {
    NSArray *_mediaItems;
    GGGenerationMode _generationMode;
}

/*
 *
 */
- (id)initWithMediaItems:(NSArray *)mediaItems;

/*
 * Toggles between the generation modes.
 */
- (void)toggleGenerationMode;

/*
 * 
 */
- (NSString *)gluePartForIndex:(NSUInteger)index;

/*
 *
 */
- (NSString *)gluedString;

/*
 *
 */
- (void)shuffle;

@property(nonatomic, retain) NSArray *mediaItems;
@property(nonatomic, assign) GGGenerationMode generationMode;

@end
