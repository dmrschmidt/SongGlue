//
//  GlueView.h
//  Icons
//
//  Created by Dennis Schmidt on 06.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GlueView : UIView {
    UILabel *_label;
    NSUInteger _index;
}

- (void)configureAtIndex:(NSUInteger)index withTitle:(NSString *)title;
- (void)setTitle:(NSString *)newTitle;

@property(nonatomic, retain) UILabel *label;
@property(assign) NSUInteger index;

@end
