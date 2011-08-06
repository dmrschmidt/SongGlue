//
//  GlueGenerator.h
//  Icons
//
//  Created by Dennis Schmidt on 06.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface GlueGenerator : NSObject {
    NSArray *_itemsFromGenericQuery;
}

@property(nonatomic, retain) NSArray *itemsFromGenericQuery;

/*
 * Returns the Singleton GlueGenerator;
 */
+ (GlueGenerator *)sharedInstance;

/*
 * Returns a random title from the iPod.
 */
- (NSString *)randomTitle;

@end
