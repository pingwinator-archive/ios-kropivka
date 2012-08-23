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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
    NSLog(@"touchesBegan");
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchesMoved");
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchesEnded");
    for (UITouch *touch in touches) {
        if (touch.tapCount >= 2) {
            //[self.superview bringSubviewToFront:self];
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchesCancelled");

}
@end
