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

@property (assign, nonatomic) CGPoint lastPreviousPoint; 
@property (assign, nonatomic) CGPoint lastCurrentPoint; 
@property (assign, nonatomic) CGFloat lineLengthSoFar; 

@end
