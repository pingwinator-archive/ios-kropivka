//
//  MovingImageView.m
//  PictsBoard
//
//  Created by Michail Kropivka on 27.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MovingImageView.h"

static inline CGFloat angleBetweenLinesInRadians2(CGPoint line1Start, CGPoint line1End) 
{
    CGFloat dx = 0, dy = 0;
    
    dx = line1End.x - line1Start.x;
    dy = line1End.y - line1Start.y;
    
    CGFloat rads = dx < dy ? atan2(dy, dx) : atan2(dx, dy);
    
    /*
    if (rads < 0)
    {
        rads += (2*M_PI);
    }*/
     
    
    return rads;
}


@implementation MovingImageView

@synthesize degrees;
@synthesize distance;

@synthesize angle;
@synthesize position;


- (id)initWithImage:(UIImage *)image
{ 
    self = [super initWithImage:image];
    
    self.degrees = 0;
    self.angle = 0;
    
    self.userInteractionEnabled = YES;
    self.multipleTouchEnabled = YES;

    self.position = CGPointMake( self.frame.origin.x, self.frame.origin.y );
    
    return self;
}

#pragma mark - Touches

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
    self.distance = 0;
    
    NSLog(@"touchesBegan");
}


- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchesMoved");
    
    if ([touches count] == 2)
    {
        NSArray* objects = [touches allObjects];
        
        UITouch* touch1 = [objects objectAtIndex:0];
        CGPoint point1 = [touch1 locationInView:self];
        
        UITouch* touch2 = [objects objectAtIndex:1];
        CGPoint point2 = [touch2 locationInView:self];
        
        // TODO SWAP on
        
        
        // ZOOMING
        
        CGFloat oldDistance = self.distance;
        self.distance = sqrt( pow((point1.x - point2.x),2) + pow((point1.y - point2.y),2) );
        if( oldDistance != 0 )
        {
            CGRect myFrame = self.bounds;
            CGFloat zoom = self.distance/oldDistance;
            
            myFrame.size.width *= zoom;
            myFrame.size.height *= zoom;
            
            myFrame.origin.x += (1.0/zoom - 1)*myFrame.size.width/2;
            myFrame.origin.y += (1.0/zoom - 1)*myFrame.size.height/2;
            
            //self.img 
            [self setBounds:myFrame];
        }
        
        
        // Rotation 
        if(0)
        {
            CGFloat oldDegrees = self.degrees;
            
            self.degrees = angleBetweenLinesInRadians2(point1, point2);
            
            CGFloat rad = self.degrees - oldDegrees;
            self.angle = self.degrees;
            
            NSLog(@"angle = %f, rad = %f", self.angle, rad);
            
            self.transform = CGAffineTransformMakeRotation( rad );

        }
        
    }
    else if([touches count] == 1)
    {
        UITouch* touch = [touches anyObject];
        
        CGFloat xmove = [touch previousLocationInView:self].x - [touch locationInView:self].x;
        CGFloat ymove = [touch previousLocationInView:self].y - [touch locationInView:self].y;
        
        //self.position = CGPointMake(self.position.x + xmove, self.position.y + ymove);
        //self.img.transform = CGAffineTransformMakeTranslation(self.position.x, self.position.y);
        
        
        CGRect myFrame = self.frame;
        
        myFrame.origin.x -= xmove;
        myFrame.origin.y -= ymove;
        
        NSLog(@"%f,%f",xmove,ymove);
        
        [self setFrame:myFrame];
    }
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchesEnded");
    self.distance = 0;
    self.degrees = 0;
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchesCancelled");
}

@end
