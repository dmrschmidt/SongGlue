//
//  GoogleImageGrabber.m
//  Icons
//
//  Created by Dennis Schmidt on 07.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GoogleImageGrabber.h"

@implementation GoogleImageGrabber

@synthesize imageConnection = _imageConnection;
@synthesize imageURLString = _imageURLString;
@synthesize activeDownload = _activeDownload;

#pragma mark -

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc {
    [_imageConnection cancel];
    [_imageConnection release];
    
    [super dealloc];
}

#pragma mark -

- (void)startDownload {
    self.activeDownload = [NSMutableData data];
    // alloc+init and start an NSURLConnection; release on completion/failure
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:
                             [NSURLRequest requestWithURL:
                              [NSURL URLWithString:self.imageURLString]] delegate:self];
    self.imageConnection = conn;
    [conn release];
}

- (void)cancelDownload {
    [self.imageConnection cancel];
    self.imageConnection = nil;
    self.activeDownload = nil;
}

#pragma mark -
#pragma mark NSURLConnectionDelegate methods (Download support)

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.activeDownload appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	// Clear the activeDownload property to allow later attempts
    self.activeDownload = nil;
    
    // Release the connection now that it's finished
    self.imageConnection = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // Set appIcon and clear temporary data/image
    UIImage *image = [[UIImage alloc] initWithData:self.activeDownload];
    
    self.activeDownload = nil;
    
    // Release the connection now that it's finished
    self.imageConnection = nil;
    
    // call our delegate and tell it that our icon is ready for display
    [self.delegate imageDidLoad:[image autorelease]];
}

@end
