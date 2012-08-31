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

@synthesize images;

@synthesize topBar;
@synthesize imagesView;
@synthesize addButton;
@synthesize slider;

#pragma mark - View lifecycle

- (void) viewDidUnload {
    self.topBar = nil;
    self.imagesView = nil;
    self.addButton = nil;
    self.slider = nil;
    self.images = nil;
    
    [super viewDidUnload];
}

-(CGFloat)randomFrom:(CGFloat)a to:(CGFloat)b
{
    CGFloat rand = random();
    return a + rand / RAND_MAX * b;
}

- (IBAction)addImage:(id)sender {
    
    UIImage* img = [UIImage imageNamed:@"pict1.jpeg"];
    MovingImageView* imgView = [[[MovingImageView alloc] initWithImage:img] autorelease];
    imgView.frame = CGRectMake([self randomFrom:0 to:400],
                               [self randomFrom:0 to:400],
                               [self randomFrom:200 to:300],
                               [self randomFrom:300 to:700]);
    
    [self.imagesView addSubview:imgView];
    [self.images addObject:imgView];
    
    imgView.layer.masksToBounds = YES;
    imgView.layer.borderColor = [UIColor blackColor].CGColor;
    imgView.layer.borderWidth = 1;
    
    imgView.layer.shadowColor = [UIColor blackColor].CGColor;
    imgView.layer.shadowOffset = CGSizeMake(2, 2);
    imgView.layer.shadowOpacity = 2;
    imgView.layer.shadowRadius = 4.0;
    imgView.clipsToBounds = NO;
}

- (IBAction)cleanBoard:(id)sender {
    
    [[self.imagesView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self.images enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        obj = nil;
    }];
    
    [self.images removeAllObjects];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    self.images = [[[NSMutableArray alloc] init] autorelease];
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
