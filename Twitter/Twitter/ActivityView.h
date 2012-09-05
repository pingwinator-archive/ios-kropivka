//
//  ActivityView.h
//  Twitter
//
//  Created by Michail Kropivka on 05.09.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityView : UIView

@property (strong, nonatomic) UIActivityIndicatorView* activityIndicator;
@property (strong, nonatomic) UILabel* message;

- (void) startActivityWithMessage:(NSString*)text;
- (void) stopActivity;

@end
