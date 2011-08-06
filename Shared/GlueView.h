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
    UILabel *_label;
    UIScrollView *_scrollView;
    NSUInteger _index;
}

- (void)configureAtIndex:(NSUInteger)index withGlue:(Glue *)glue;
- (void)configureAtIndex:(NSUInteger)index withTitle:(NSString *)title;
- (void)setTitle:(NSString *)newTitle;
- (void)shake;

@property(nonatomic, retain) UIView *labelView;
@property(nonatomic, retain) NSArray *labels;
@property(nonatomic, retain) UILabel *label;
@property(nonatomic, retain) UIScrollView *scrollView;
@property(assign) NSUInteger index;

@end
