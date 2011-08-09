//
//  GlueView.h
//  Icons
//
//  Created by Dennis Schmidt on 06.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "Glue.h"

@interface GlueView : UIView <UIScrollViewDelegate> {
    UIImageView *_borderImageView;
    UIImageView *_imageView;
    UIView *_labelView;
    NSArray *_labels;
    UIScrollView *_scrollView;
    NSUInteger _index;
    Glue *_glue;
    
@private
    UIActivityIndicatorView *_imageSpinner;
}

- (void)configureAtIndex:(NSUInteger)index withGlue:(Glue *)glue;
- (IBAction)toggleDisplayMode:(id)sender;
- (void)resetImage;
- (void)shake __attribute__ ((deprecated));
- (void)shakeHorizontally;
- (void)shakeVertical;
- (void)shuffle;

@property(nonatomic, retain) UIImageView *borderImageView;
@property(nonatomic, retain) UIImageView *imageView;
@property(nonatomic, retain) UIView *labelView;
@property(nonatomic, retain) NSArray *labels;
@property(nonatomic, retain) UIScrollView *scrollView;
@property(assign) NSUInteger index;

@property(nonatomic, retain) Glue *glue;

@end
