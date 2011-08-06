//
//  GlueView.h
//  Icons
//
//  Created by Dennis Schmidt on 06.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Glue.h"

@interface GlueView : UIView <UIScrollViewDelegate> {
    UIView *_labelView;
    NSArray *_labels;
    UIScrollView *_scrollView;
    NSUInteger _index;
    
    Glue *_glue;
}

- (void)configureAtIndex:(NSUInteger)index withGlue:(Glue *)glue;
- (IBAction)toggleDisplayMode:(id)sender;
- (void)shake;

@property(nonatomic, retain) UIView *labelView;
@property(nonatomic, retain) NSArray *labels;
@property(nonatomic, retain) UIScrollView *scrollView;
@property(assign) NSUInteger index;

@property(nonatomic, retain) Glue *glue;

@end
