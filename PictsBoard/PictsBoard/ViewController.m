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
@synthesize currentScale;
@synthesize img;

#pragma mark - View lifecycle

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [self.pinch release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage* img1 = [UIImage imageNamed:@"pict1.jpeg"];
    UIImageView* imgView = [[UIImageView alloc] initWithImage:img1];
    [self.view addSubview:imgView];
    
    self.img = imgView;
    
    self.pinch = 
    [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchHandler:)];
    
    [self.view addGestureRecognizer: self.pinch];
}

- (void) pinchHandler:(UIPinchGestureRecognizer*)paramSender{
    
    if (paramSender.state == UIGestureRecognizerStateEnded){ 
        self.currentScale = paramSender.scale;
    } else if (paramSender.state == UIGestureRecognizerStateBegan && self.currentScale != 0.0f){
        paramSender.scale = self.currentScale;
    }
    
    if (paramSender.scale != NAN && paramSender.scale != 0.0){ 
        self.img.transform =
        CGAffineTransformMakeScale(paramSender.scale, paramSender.scale);
    }
    
}

@end
