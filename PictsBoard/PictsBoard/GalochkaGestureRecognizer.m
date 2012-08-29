//
//  GalochkaGestureRecognizer.m
//  PictsBoard
//
//  Created by Michail Kropivka on 27.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GalochkaGestureRecognizer.h"

#import "CGPointUtils.h"


#define kMinimumCheckMarkAngle	50 
#define kMaximumCheckMarkAngle	135 
#define kMinimumCheckMarkLength	10

@implementation GalochkaGestureRecognizer

@synthesize state;

@synthesize lastPreviousPoint; 
@synthesize lastCurrentPoint; 
@synthesize lineLengthSoFar;

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //[super touchesBegan:touches withEvent:event];
    NSLog(@"touchesBegan");
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view]; 
    lastPreviousPoint = point; 
    lastCurrentPoint = point; 
    lineLengthSoFar = 0.0f;
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //[super touchesMoved:touches withEvent:event];
    NSLog(@"touchesMoved");
    UITouch *touch = [touches anyObject]; 
    CGPoint previousPoint = [touch previousLocationInView:self.view]; 
    CGPoint currentPoint = [touch locationInView:self.view];
    
    
    CGFloat angle = angleBetweenLines(lastPreviousPoint, lastCurrentPoint, previousPoint, currentPoint);
    if (angle >= kMinimumCheckMarkAngle && angle <= kMaximumCheckMarkAngle
        && lineLengthSoFar > kMinimumCheckMarkLength) { 
        self.state = UIGestureRecognizerStateEnded;
    }
    lineLengthSoFar += distanceBetweenPoints(previousPoint, currentPoint); 
    lastPreviousPoint = previousPoint; 
    lastCurrentPoint = currentPoint;
}

@end
