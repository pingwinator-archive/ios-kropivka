//
//  ViewController.m
//  PictsBoard
//
//  Created by Michail Kropivka on 23.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

#define degreesToRadians(x) (M_PI * x / 180.0)


@interface ViewController ()

@property (retain, nonatomic) NSArray* activeTouches;

@end


@implementation ViewController

@synthesize img;
@synthesize startPoint;
@synthesize distance;

@synthesize activeTouches;

#pragma mark - View lifecycle

- (void) viewDidUnload {

    [super viewDidUnload];
    
    [activeTouches release];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    self.view.multipleTouchEnabled = YES;
    
    UIImage* img1 = [UIImage imageNamed:@"pict1.jpeg"];
    UIImageView* imgView = [[[UIImageView alloc] initWithImage:img1] autorelease];
    [self.view addSubview:imgView];
    
    self.img = imgView; // TODO -> array
    activeTouches = [NSArray array];
    self.distance = 0;
}

#pragma mark - Touches

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
    UITouch* touch = [touches anyObject];
    
    self.startPoint = [touch locationInView:self.view];
    self.distance = 0;

    NSLog(@"touchesBegan");
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchesMoved");
    
    if ([touches count] == 2)
    {
        NSArray* objects = [touches allObjects];
        
        UITouch* touch1 = [objects objectAtIndex:0];
        CGPoint point1 = [touch1 locationInView:self.view];

        UITouch* touch2 = [objects objectAtIndex:1];
        CGPoint point2 = [touch2 locationInView:self.view];

        // ZOOMING
        
        CGFloat oldDistance = self.distance;
        self.distance = sqrt( pow((point1.x - point2.x),2) + pow((point1.y - point2.y),2) );
        if( oldDistance != 0 )
        {
            CGRect myFrame = self.img.frame;
            CGFloat zoom = self.distance/oldDistance;
            
            myFrame.size.width *= zoom;
            myFrame.size.height *= zoom;
            
            myFrame.origin.x += (1.0/zoom - 1)*myFrame.size.width/2;
            myFrame.origin.y += (1.0/zoom - 1)*myFrame.size.height/2;

            [UIView beginAnimations:nil context:NULL];
            [self.img setFrame:myFrame];
            [UIView commitAnimations];
        }
      
    }
    else if([touches count] == 1)
    {
        UITouch* touch = [touches anyObject];

        CGFloat xmove = [touch previousLocationInView:self.view].x - [touch locationInView:self.view].x;
        CGFloat ymove = [touch previousLocationInView:self.view].y - [touch locationInView:self.view].y;

        CGRect myFrame = self.img.frame;

        myFrame.origin.x -= xmove;
        myFrame.origin.y -= ymove;
        
        [UIView beginAnimations:nil context:NULL];
        [self.img setFrame:myFrame];
        [UIView commitAnimations];
    }
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchesEnded");
    self.distance = 0;
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchesCancelled");
}


@end
