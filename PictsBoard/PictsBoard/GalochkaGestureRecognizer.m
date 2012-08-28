//
//  GalochkaGestureRecognizer.m
//  PictsBoard
//
//  Created by Michail Kropivka on 27.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GalochkaGestureRecognizer.h"

@implementation GalochkaGestureRecognizer

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint nowPoint = [[touches anyObject] locationInView:self.view]; 
    CGPoint prevPoint = [[touches anyObject] previousLocationInView:self.view];
    
    if (strokeMovingUp == YES) { 
        if (nowPoint.y < prevPoint.y ) 
        {
            strokeMovingUp = NO; touchChangedDirection++;
        } 
    } else if (nowPoint.y > prevPoint.y ) 
    {
            strokeMovingUp = YES; touchChangedDirection++;
        }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
}
     
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)reset
{
    
}
@end
