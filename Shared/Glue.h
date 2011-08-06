//
//  Glue.h
//  Icons
//
//  Created by Dennis Schmidt on 06.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Glue : NSObject {
    NSArray *_mediaItems;
}

/*
 *
 */
- (id)initWithMediaItems:(NSArray *)mediaItems;

/*
 *
 */
- (NSString *)gluedString;

@property(nonatomic, retain) NSArray *mediaItems;

@end
