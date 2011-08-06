//
//  GlueViewController.h
//  Icons
//
//  Created by Dennis Schmidt on 06.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "GlueView.h"
#import "InfiniteScrollView.h"

@interface GlueViewController : UIViewController <UIAccelerometerDelegate, UIScrollViewDelegate> {
    // common stuff
    NSArray *_audioSamples;
    
    // scrolling stuff
    UIScrollView *_scrollView;
    NSMutableSet *_visiblePages;
    NSMutableSet *_recycledPages;
    
    // accelerometer stuff
    UIAccelerometer *_accelerometer;
    NSMutableArray *_history_x;
    NSMutableArray *_history_y;
    NSMutableArray *_history_z;
}

/*
 * deprecated
 */
- (NSUInteger)glueCount;

/*
 *
 */
- (GlueView *)dequeRecycledPage;

/*
 *
 */
- (BOOL)isDisplayingPageForIndex:(NSUInteger)index;

/*
 *
 */
- (void)tilePages;

/*
 *
 */
- (IBAction)updateTitle:(id)sender;

/*
 * Plays a random audio sample (Bobby's hit sound).
 */
- (void)playAudio;

@property(nonatomic, retain) NSArray *audioSamples;

@property(nonatomic, retain) UIScrollView *scrollView;
@property(nonatomic, retain) NSMutableSet *visiblePages;
@property(nonatomic, retain) NSMutableSet *recycledPages;

@property(nonatomic, retain) UIAccelerometer *accelerometer;
@property(nonatomic, retain) NSMutableArray *history_x;
@property(nonatomic, retain) NSMutableArray *history_y;
@property(nonatomic, retain) NSMutableArray *history_z;


@end
