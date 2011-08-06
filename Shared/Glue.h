//
//  Glue.h
//  Icons
//
//  Created by Dennis Schmidt on 06.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

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
 * 
 */
- (NSString *)gluePartForIndex:(NSUInteger)index;

/*
 *
 */
- (NSString *)gluedString;

@property(nonatomic, retain) NSArray *mediaItems;
@property(nonatomic, assign) GGGenerationMode generationMode;

@end
