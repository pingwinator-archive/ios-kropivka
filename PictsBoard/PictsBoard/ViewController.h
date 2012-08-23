//
//  ViewController.h
//  PictsBoard
//
//  Created by Michail Kropivka on 23.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (nonatomic, retain) NSArray* images;
@property (nonatomic, retain) UIPinchGestureRecognizer* pinch;
@property (nonatomic, assign) CGFloat currentScale;
@property (nonatomic, assign) UIImageView* img;

- (void) pinchHandler:(UIPinchGestureRecognizer*)paramSender;

@end
