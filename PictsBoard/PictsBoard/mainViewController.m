//
//  mainViewController.m
//  PictsBoard
//
//  Created by Michail Kropivka on 30.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "mainViewController.h"
#import "MovingImageView.h"
#import "QuartzCore/QuartzCore.h"

@implementation mainViewController



@synthesize img;
@synthesize topBar;
@synthesize imagesView;
@synthesize addButton;
@synthesize slider;

#pragma mark - View lifecycle

- (void) viewDidUnload {
    [self setTopBar:nil];
    [self setImagesView:nil];
    [self setAddButton:nil];
    [self setSlider:nil];
    [super viewDidUnload];
}

- (IBAction)addImage:(id)sender {
    UIImage* img1 = [UIImage imageNamed:@"pict1.jpeg"];
    MovingImageView* imgView = [[[MovingImageView alloc] initWithImage:img1] autorelease];
    [self.imagesView addSubview:imgView];
}

- (void) viewDidLoad
{
    [super viewDidLoad];

    
}

- (void)dealloc {
    [topBar release];
    [imagesView release];
    [addButton release];
    [slider release];
    [super dealloc];
}
- (IBAction)sliderChanged:(id)sender {
}

@end
