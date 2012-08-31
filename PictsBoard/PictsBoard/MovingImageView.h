//
//  MovingImageView.h
//  PictsBoard
//
//  Created by Michail Kropivka on 27.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GalochkaGestureRecognizer;

@interface MovingImageView : UIImageView

@property (nonatomic, retain) UIRotationGestureRecognizer* rotation;
@property (nonatomic, retain) UIPinchGestureRecognizer* pinch;
@property (nonatomic, retain) UIPanGestureRecognizer* pan;
@property (nonatomic, retain) UITapGestureRecognizer* tap;
@property (nonatomic, retain) UILongPressGestureRecognizer* longPress;

@property (nonatomic, retain) GalochkaGestureRecognizer* galochka;

- (IBAction)handleGesture:(UIGestureRecognizer *)recognizer;
- (CGAffineTransform)applyRecognizer:(UIGestureRecognizer *)recognizer toTransform:(CGAffineTransform)transform;



@end
