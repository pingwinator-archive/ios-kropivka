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
@property (nonatomic, assign) UIImageView* img;

@property (nonatomic, retain) UIPinchGestureRecognizer* pinch;
@property (nonatomic, retain) UIRotationGestureRecognizer* rotation;
@property (nonatomic, assign) CGFloat currentScale;
@property (nonatomic, assign) CGFloat rotationAngleInRadians;

- (void) handleGesture:(UIGestureRecognizer*)recognizer;
- (CGAffineTransform)applyRecognizer:(UIGestureRecognizer *)recognizer toTransform:(CGAffineTransform)transform;

@end
