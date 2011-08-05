//
//  RootViewController.h
//  TabBarControllerTutorial
//
//  Created by Dennis Schmidt on 05.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "ShakingView.h"

@interface RootViewController : UIViewController <UIAccelerometerDelegate> {
    UILabel *_labelView;
    UIButton *_buttonView;
    NSArray *_itemsFromGenericQuery;
    NSArray *_audioSamples;
    
    // accelerometer stuff
    UIAccelerometer *_accelerometer;
    NSMutableArray *_history_x;
    NSMutableArray *_history_y;
    NSMutableArray *_history_z;
}

- (void)shakeIntro;
- (void)initAccelerometer;
- (IBAction)updateTitle:(id)sender;
- (void)playAudio;

@property(nonatomic, retain) IBOutlet UILabel *labelView;
@property(nonatomic, retain) IBOutlet UIButton *buttonView;
@property(nonatomic, retain) NSArray *itemsFromGenericQuery;
@property(nonatomic, retain) NSArray *audioSamples;

@property(nonatomic, retain) UIAccelerometer *accelerometer;
@property(nonatomic, retain) NSMutableArray *history_x;
@property(nonatomic, retain) NSMutableArray *history_y;
@property(nonatomic, retain) NSMutableArray *history_z;

@end
