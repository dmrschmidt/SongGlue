//
//  ImageGrabber.h
//  Icons
//
//  Created by Dennis Schmidt on 07.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ImageGrabberDelegate
/**
 * Delegate method will be called with the downloaded image once the
 * download is complete.
 */
- (void)imageDidLoad:(UIImage *)image;

@end


@interface ImageGrabber : NSObject {
    id <ImageGrabberDelegate> _delegate;
    
@private
    NSMutableData *_activeRequest;
}

@property (nonatomic, assign) id <ImageGrabberDelegate> delegate;
@property (nonatomic, retain) NSMutableData *activeRequest;

/**
 * Request an image.
 */
- (void)requestImage;

/**
 * Cancel the request for the image.
 */
- (void)cancelImageRequest;

@end
