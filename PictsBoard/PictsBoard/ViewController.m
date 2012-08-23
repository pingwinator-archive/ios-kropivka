//
//  ViewController.m
//  PictsBoard
//
//  Created by Michail Kropivka on 23.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"


@implementation ViewController

@synthesize img;
@synthesize startPoint;
@synthesize distance;

#pragma mark - View lifecycle

- (void) viewDidUnload {

    [super viewDidUnload];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    UIImage* img1 = [UIImage imageNamed:@"pict1.jpeg"];
    
    UIImageView* imgView = [[[UIImageView alloc] initWithImage:img1] autorelease];
    
    [self.view addSubview:imgView];
    
    self.img = imgView;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
    UITouch* touch = [touches anyObject];
    self.startPoint = [touch locationInView:self.view];
    
    
    NSLog(@"%@",touches);
    NSLog(@"touchesBegan");
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchesMoved");
    
    UITouch* touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    //self.distance = sqrt( pow((self.startPoint.x - point.x),2) + pow((self.startPoint.y - point.y),2) );
    self.distance = (self.startPoint.x - point.x)/400;
    
    // Single-tap: decrease image size by 10%"
    CGRect myFrame = self.img.frame;
    myFrame.size.width -= self.img.frame.size.width * self.distance;
    myFrame.size.height -= self.img.frame.size.height * self.distance;
    myFrame.origin.x += (self.img.frame.origin.x * self.distance) / 2.0;
    myFrame.origin.y += (self.img.frame.origin.y * self.distance) / 2.0;
    [UIView beginAnimations:nil context:NULL];
    [self.img setFrame:myFrame];
    [UIView commitAnimations];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchesEnded");
    for (UITouch *touch in touches) {
        if (touch.tapCount >= 2) {
            //[self.superview bringSubviewToFront:self];
        }
    }
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchesCancelled");
}

- (void)handleSingleTap:(NSDictionary *)touches {
    NSLog(@"handleSingleTap");

}

@end
