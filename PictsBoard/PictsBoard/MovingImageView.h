//
//  MovingImageView.h
//  PictsBoard
//
//  Created by Michail Kropivka on 27.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovingImageView : UIImageView


@property (nonatomic, assign) CGFloat distance;

@property (nonatomic, assign) CGFloat angle;
@property (nonatomic, assign) CGPoint position;

@property (nonatomic, retain) UIRotationGestureRecognizer* rotation;
@property (nonatomic, retain) UIPinchGestureRecognizer* pinch;


- (IBAction)handleGesture:(UIGestureRecognizer *)recognizer;
- (CGAffineTransform)applyRecognizer:(UIGestureRecognizer *)recognizer toTransform:(CGAffineTransform)transform;

@end
