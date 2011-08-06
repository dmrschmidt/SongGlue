//
//  GlueViewController.m
//  Icons
//
//  Created by Dennis Schmidt on 06.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GlueViewController.h"

@implementation GlueViewController

@synthesize itemsFromGenericQuery = _itemsFromGenericQuery;
@synthesize audioSamples = _audioSamples;
@synthesize accelerometer = _accelerometer;
@synthesize history_x = _history_x;
@synthesize history_y = _history_y;
@synthesize history_z = _history_z;
@synthesize scrollView = _scrollView;
@synthesize visiblePages = _visiblePages;
@synthesize recycledPages = _recycledPages;

#pragma mark -
#pragma mark - Hardware (Audio, Accelerometer) stuff

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

#pragma mark -
#pragma mark - Glue methods

- (IBAction)updateTitle:(id)sender {
    CGRect visibleBounds = self.scrollView.bounds;
    int neededPageIndex = floorf(CGRectGetMinX(visibleBounds) / CGRectGetWidth(visibleBounds));
    for(GlueView *pageGlueView in self.visiblePages) {
        if(pageGlueView.index == neededPageIndex) {
            [pageGlueView configureAtIndex:neededPageIndex withTitle:[self randomTitle]];
            [pageGlueView shake];
        }
    }
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

#pragma mark -
#pragma mark - InfiniteScrollView methods

- (void)tilePages {
    CGRect visibleBounds = self.scrollView.bounds;
    int firstNeededPageIndex = floorf(CGRectGetMinX(visibleBounds) / CGRectGetWidth(visibleBounds));
    int lastNeededPageIndex = floorf((CGRectGetMaxX(visibleBounds)-1) / CGRectGetWidth(visibleBounds));
    firstNeededPageIndex = MAX(firstNeededPageIndex, 0);
    lastNeededPageIndex = MIN(lastNeededPageIndex, [self glueCount] - 1);
    
    // Recycle no longer-needed pages
    for(GlueView *page in self.visiblePages) {
        if(page.index < firstNeededPageIndex || page.index > lastNeededPageIndex) {
            [self.recycledPages addObject:page];
            [page removeFromSuperview];
        }
    }
    [self.visiblePages minusSet:self.recycledPages];
    
    // add missing pages
    for(int index = firstNeededPageIndex; index <= lastNeededPageIndex; index++) {
        if(![self isDisplayingPageForIndex:index]) {
            GlueView *glueView = [self dequeRecycledPage];
            if(glueView == nil) {
                glueView = [[[GlueView alloc] init] autorelease];
            }
            [glueView configureAtIndex:index withTitle:[self randomTitle]];
            [self.scrollView addSubview:glueView];
            [self.visiblePages addObject:glueView];
        }
    }
}

- (GlueView *)dequeRecycledPage {
    GlueView *glueView = [self.recycledPages anyObject];
    if(glueView) {
        [[glueView retain] autorelease];
        [self.recycledPages removeObject:glueView];
    }
    return glueView;
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

#pragma mark -
#pragma mark - UIScrollViewDelegate delegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self tilePages];
}

#pragma mark -
#pragma mark - Initialization

- (void)initScrollView {
    CGRect frame = self.view.bounds;
    self.scrollView = [[InfiniteScrollView alloc] initWithFrame:frame];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(frame.size.width * [self glueCount], frame.size.height);
    [self.view addSubview:self.scrollView];
    
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
}

- (void)initAudioSamples {
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

#pragma mark -
#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _visiblePages = [[NSMutableSet alloc] init];
    _recycledPages = [[NSMutableSet alloc] init];
    
    // initially cache the data
    [self setItemsFromGenericQuery:[[MPMediaQuery songsQuery] items]];
    
    [self initScrollView];
    [self initAccelerometer];
    [self initAudioSamples];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // for the shake movement detection
    [self.view becomeFirstResponder];
}

- (void) viewWillDisappear:(BOOL)animated {
    // for the shake movement detection
    [self.view resignFirstResponder];
    
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

@end