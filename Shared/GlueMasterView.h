//
//  GlueView.h
//  Icons
//
//  Created by Dennis Schmidt on 06.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "GlueDetailView.h"
#import "Glue.h"

@interface GlueMasterView : UIView <UIScrollViewDelegate> {
    UIImageView *_borderImageView;
    UIImageView *_imageView;
    UIView *_labelView;
    NSArray *_labels;
    UIScrollView *_scrollView;
    NSUInteger _index;
    Glue *_glue;
    GlueDetailView *_detailView;
    
@private
    UIActivityIndicatorView *_imageSpinner;
}

- (void)configureAtIndex:(NSUInteger)index withGlue:(Glue *)glue;
- (IBAction)toggleDisplayMode:(id)sender;

/*
 * Toggles between the display of the detail view and the "original glue view"
 */
- (IBAction)toggleDetailView:(id)sender;
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
@property(nonatomic, retain) GlueDetailView *detailView;

@end
