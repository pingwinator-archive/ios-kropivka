//
//  GalochkaGestureRecognizer.h
//  PictsBoard
//
//  Created by Michail Kropivka on 27.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GalochkaGestureRecognizer : UIGestureRecognizer


@property (nonatomic,assign) UIGestureRecognizerState state;

@property (nonatomic,assign) BOOL strokeUp;
@property (nonatomic,assign) CGPoint midPoint;

- (void)reset;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;
@end
