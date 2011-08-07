//
//  GoogleImageGrabber.h
//  Icons
//
//  Created by Dennis Schmidt on 07.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ImageGrabber.h"

@interface GoogleImageGrabber : ImageGrabber {
    
@private
    NSString *_imageURLString;
    NSURLConnection *_imageConnection;
    NSMutableData *_activeDownload;
}

@property (nonatomic, retain) NSString *imageURLString;
@property (nonatomic, retain) NSURLConnection *imageConnection;
@property (nonatomic, retain) NSMutableData *activeDownload;

@end
