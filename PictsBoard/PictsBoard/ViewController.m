//
//  ViewController.m
//  PictsBoard
//
//  Created by Michail Kropivka on 23.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "MovingImageView.h"

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
    MovingImageView* imgView = [[[MovingImageView alloc] initWithImage:img1] autorelease];
    [self.view addSubview:imgView];
    self.img = imgView;
}


@end
