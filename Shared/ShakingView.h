//
//  ShakingView.h
//  Icons
//
//  Created by Dennis Schmidt on 05.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShakerDelegate <NSObject>

- (IBAction)updateTitle:(id)sender;

@end

@interface ShakingView : UIView {
    id<ShakerDelegate> _delegate;
}

@property(nonatomic, assign) id<ShakerDelegate> delegate;

@end
