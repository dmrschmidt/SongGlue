//
//  RootViewController.m
//  TabBarControllerTutorial
//
//  Created by Dennis Schmidt on 05.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"

@implementation RootViewController

@synthesize labelView = _labelView;
@synthesize buttonView = _buttonView;
@synthesize itemsFromGenericQuery = _itemsFromGenericQuery;
@synthesize audioSamples = _audioSamples;
@synthesize accelerometer = _accelerometer;
@synthesize history_x = _history_x;
@synthesize history_y = _history_y;
@synthesize history_z = _history_z;
@synthesize scrollView = _scrollView;
@synthesize visiblePages = _visiblePages;

#pragma mark -
#pragma mark - Shuffle methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _visiblePages = [[NSMutableSet alloc] init];
    
    // initially cache the data
    [self setItemsFromGenericQuery:[[MPMediaQuery songsQuery] items]];
    [self.labelView removeFromSuperview];
    
    [self initScrollView];
    [self initAccelerometer];
}

- (void)initScrollView {
    CGRect frame = CGRectMake(0, 150, 320, 200);
    self.scrollView = [[UIScrollView alloc] initWithFrame:frame];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(frame.size.width * [self glueCount], frame.size.height);
    [self.view addSubview:self.scrollView];
    
    [self tilePages];
}

- (void)tilePages {
    CGRect visibleBounds = self.scrollView.bounds;
    int firstNeededPageIndex = floorf(CGRectGetMinX(visibleBounds) / CGRectGetWidth(visibleBounds));
    int lastNeededPageIndex = floorf((CGRectGetMaxX(visibleBounds)-1) / CGRectGetWidth(visibleBounds));
    firstNeededPageIndex = MAX(firstNeededPageIndex, 0);
    lastNeededPageIndex = MIN(lastNeededPageIndex, [self glueCount] - 1);
    
    // Recycle no longer-needed pages
    
    // add missing pages
    for(int index = firstNeededPageIndex; index <= lastNeededPageIndex; index++) {
        NSLog(@"at index: %@", [NSNumber numberWithInt:index]);
        if(![self isDisplayingPageForIndex:index]) {
            NSString *title = [self randomTitle];
            GlueView *glueView = [[GlueView alloc] initWithIndex:index andTitle:title];
            [self.scrollView addSubview:glueView];
            [self.visiblePages addObject:glueView];
        }
    }
}

- (BOOL)isDisplayingPageForIndex:(NSUInteger)index {
    for(GlueView *glueView in self.visiblePages) {
        if(glueView.index == index) {
            return YES;
        }
    }
    return NO;
}

- (NSUInteger)glueCount {
    // for now just static
    return 5;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self tilePages];
}

- (void)initAccelerometer {
    // initialize the UIAccelerometer
    self.accelerometer = [UIAccelerometer sharedAccelerometer];
    self.accelerometer.updateInterval = .1;
    self.accelerometer.delegate = self;
    
    self.history_x = [[NSMutableArray alloc] initWithCapacity:5];
    self.history_y = [[NSMutableArray alloc] initWithCapacity:5];
    self.history_z = [[NSMutableArray alloc] initWithCapacity:5];

    // initialize the audio samples
    NSMutableArray *samples = [[NSMutableArray alloc] initWithCapacity:6];

    for(int i = 0; i < 6; i++) {
        NSString *name = [NSString stringWithFormat:@"bobby_%@", [NSNumber numberWithInt:i]];
        NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"mp3"];
        NSError *error = nil;
        AVAudioPlayer *theAudio = [[AVAudioPlayer alloc] initWithContentsOfURL:
                                   [NSURL fileURLWithPath:path] error:&error];
        if (error) NSLog(@"%@",[error localizedDescription]);
        [samples addObject:theAudio];
        [theAudio release];
    }
    self.audioSamples = [NSArray arrayWithArray:samples];
}

- (void)shakeIntro {
    CGPoint center = self.labelView.center;
    [UIView animateWithDuration:0.1
                     animations:^{self.labelView.center = CGPointMake(center.x - 20, center.y);}
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.1
                                          animations:^{self.labelView.center =
                                              CGPointMake(center.x + 20, center.y);}
                                          completion:^(BOOL finished){
                                              [UIView animateWithDuration:0.1
                                                               animations:^{self.labelView.center = CGPointMake(center.x - 20, center.y);}
                                                               completion:^(BOOL finished){
                                                                   [UIView animateWithDuration:0.1
                                                                                    animations:^{self.labelView.center = CGPointMake(160.f, center.y);}
                                                                                    completion:^(BOOL finished){}];
                                                               }];
                                          }];
                     }];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.view becomeFirstResponder];
}


- (IBAction)updateTitle:(id)sender {
    [self shakeIntro];
    NSMutableString *shuffledText = [[NSMutableString alloc] init];
    
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\([^)]*\\)"
                                                                           options:0
                                                                             error:&error];
    
    for(NSUInteger i = 0; i < 3; i++) {
        NSUInteger songItemIndex = arc4random() % [[self itemsFromGenericQuery] count];
        MPMediaItem *song = [[self itemsFromGenericQuery] objectAtIndex:songItemIndex];
        NSString *songTitle = [NSString stringWithString:[song valueForProperty: MPMediaItemPropertyTitle]];
        
        // remove brackets
        NSString *modifiedString = [regex stringByReplacingMatchesInString:songTitle
                                                                   options:0
                                                                     range:NSMakeRange(0, [songTitle length])
                                                              withTemplate:@""];
        
        [shuffledText appendString:modifiedString];
        if(i < 2) [shuffledText appendString:@"\n"];
    }
    
    self.labelView.text = shuffledText;
    [shuffledText release];
}

- (NSString *)randomTitle {
    NSMutableString *shuffledText = [[NSMutableString alloc] init];
    
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\([^)]*\\)"
                                                                           options:0
                                                                             error:&error];
    
    for(NSUInteger i = 0; i < 3; i++) {
        NSUInteger songItemIndex = arc4random() % [[self itemsFromGenericQuery] count];
        MPMediaItem *song = [[self itemsFromGenericQuery] objectAtIndex:songItemIndex];
        NSString *songTitle = [NSString stringWithString:[song valueForProperty: MPMediaItemPropertyTitle]];
        
        // remove brackets
        NSString *modifiedString = [regex stringByReplacingMatchesInString:songTitle
                                                                   options:0
                                                                     range:NSMakeRange(0, [songTitle length])
                                                              withTemplate:@""];
        
        [shuffledText appendString:modifiedString];
        if(i < 2) [shuffledText appendString:@"\n"];
    }
    
    return [shuffledText autorelease];
}

- (void)playAudio {
    NSUInteger songIndex = arc4random() % [self.audioSamples count];
    [(AVAudioPlayer*)[self.audioSamples objectAtIndex:songIndex] play];
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration  {
    // add the current measures to the history
    [self.history_x addObject:[NSNumber numberWithFloat:acceleration.x]];
    [self.history_y addObject:[NSNumber numberWithFloat:acceleration.y]];
    [self.history_z addObject:[NSNumber numberWithFloat:acceleration.z]];
    
    // Every 5/10s, check if there was a move we can interpret as a shake, by comparing
    // the values from the last 5 invocations against each other.
    if([self.history_x count] > 5 && [self.history_x count] % 5 == 0) {
        float min_x = [[self.history_x objectAtIndex:[self.history_x count] -1] floatValue];
        float min_y = [[self.history_y objectAtIndex:[self.history_y count] -1] floatValue];
        float min_z = [[self.history_z objectAtIndex:[self.history_z count] -1] floatValue];
        float max_x = [[self.history_x objectAtIndex:[self.history_x count] -1] floatValue];
        float max_y = [[self.history_y objectAtIndex:[self.history_y count] -1] floatValue];
        float max_z = [[self.history_z objectAtIndex:[self.history_z count] -1] floatValue];
        
        // Get each history's min and max value within the last 5 measures.
        for(int i = [self.history_x count] - 1; i > [self.history_x count] - 6; i--) {
            if([[self.history_x objectAtIndex:i] floatValue] < min_x)
                min_x = [[self.history_x objectAtIndex:i] floatValue];
            if([[self.history_x objectAtIndex:i] floatValue] > max_x)
                max_x = [[self.history_x objectAtIndex:i] floatValue];
            
            if([[self.history_y objectAtIndex:i] floatValue] < min_y)
                min_y = [[self.history_y objectAtIndex:i] floatValue];
            if([[self.history_y objectAtIndex:i] floatValue] > max_y)
                max_y = [[self.history_y objectAtIndex:i] floatValue];
            
            if([[self.history_z objectAtIndex:i] floatValue] < min_z)
                min_z = [[self.history_z objectAtIndex:i] floatValue];
            if([[self.history_z objectAtIndex:i] floatValue] > max_z)
                max_z = [[self.history_z objectAtIndex:i] floatValue];
        }
        
        // Get the absolute variation for each dimension.
        float variation_x = abs(min_x - max_x);
        float variation_y = abs(min_y - max_y);
        float variation_z = abs(min_z - max_z);
        
        // When the summed variation (since we want to detect shake in any direction)
        // is bigger than our (experimentally determined) threshold, trigger the update.
        if(variation_x + variation_y + variation_z > .5f) {
            [self updateTitle:self];
            [self playAudio];
        }
    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Following the HIG for supported orientations per device.
	// Do not support UIInterfaceOrientationPortraitUpsideDown if the device is not an iPad.
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
		return NO;
	}
	
    return NO;
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self.view resignFirstResponder];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
