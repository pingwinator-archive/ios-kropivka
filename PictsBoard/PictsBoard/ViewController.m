//
//  ViewController.m
//  PictsBoard
//
//  Created by Michail Kropivka on 23.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

@synthesize images;
@synthesize pinch;
@synthesize rotation;
@synthesize currentScale;
@synthesize rotationAngleInRadians;
@synthesize img;

#pragma mark - View lifecycle

- (void) viewDidUnload {
    
    [pinch release];
    [rotation release];
    [super viewDidUnload];
}

- (void) viewDidLoad
{
        [super viewDidLoad];
    
    UIImage* img1 = [UIImage imageNamed:@"pict1.jpeg"];
    
    UIImageView* imgView = [[[UIImageView alloc] initWithImage:img1] autorelease];
    
    [self.view addSubview:imgView];
    
    self.img = imgView;
    
    self.pinch = [[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)] autorelease];
    [self.view addGestureRecognizer:self.pinch];
    
    self.rotation = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotations:)]; 
    [self.view addGestureRecognizer:self.rotation];
}

- (void) handlePinch:(UIPinchGestureRecognizer*)paramSender {
    
    NSLog(@"Pinch");
    if (paramSender.state == UIGestureRecognizerStateEnded) 
    { 
        self.currentScale = paramSender.scale;
    } 
    else if (paramSender.state == UIGestureRecognizerStateBegan && self.currentScale != 0.0f)
    {
        paramSender.scale = self.currentScale;
    }
    
    if (paramSender.scale != NAN && paramSender.scale != 0.0)
    { 
        self.img.transform =
        CGAffineTransformMakeScale(paramSender.scale, paramSender.scale);
    }
}

- (void) handleRotations:(UIRotationGestureRecognizer *)paramSender {
    NSLog(@"Roration");
    /* Take the previous rotation and add the current rotation to it */ 
    self.img.transform = CGAffineTransformMakeRotation(self.rotationAngleInRadians + paramSender.rotation);
    
    /* At the end of the rotation, keep the angle for later use */ 
    if (paramSender.state == UIGestureRecognizerStateEnded) 
    {
        self.rotationAngleInRadians += paramSender.rotation;
    }
}

@end
