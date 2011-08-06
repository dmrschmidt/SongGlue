//
//  GlueGenerator.h
//  Icons
//
//  Created by Dennis Schmidt on 06.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "Glue.h"

@interface GlueGenerator : NSObject {
    NSArray *_itemsFromGenericQuery;
    GGGenerationMode _currentGenerationMode;
}

@property(nonatomic, retain) NSArray *itemsFromGenericQuery;

/*
 * Returns the Singleton GlueGenerator;
 */
+ (GlueGenerator *)sharedInstance;

/*
 * Returns a random Glue instance.
 */
+ (Glue *)randomGlue;

/*
 * Sets the default generation mode for new Glues.
 */
- (void)setGenerationMode:(GGGenerationMode)generationMode;

/*
 * Toggles between the generation modes.
 */
- (void)toggleGenerationMode;

/*
 * Returns a random title from the iPod.
 */
- (Glue *)randomGlue;

@end
