//
//  ViewController.m
//  PictsBoard
//
//  Created by Michail Kropivka on 23.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
@interface ViewController ()
@property (retain, nonatomic) NSMutableSet* activeRecognizers;

@end

@implementation ViewController

@synthesize images;
@synthesize pinch;
@synthesize rotation;
@synthesize currentScale;
@synthesize rotationAngleInRadians;
@synthesize img;

@synthesize activeRecognizers;

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
    
    self.pinch = [[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)] autorelease];
    [self.view addGestureRecognizer:self.pinch];
    
    self.rotation = [[[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)] autorelease]; 
    [self.view addGestureRecognizer:self.rotation];
    
    self.activeRecognizers = [NSMutableSet set];
}

- (void) handleGesture:(UIGestureRecognizer*)recognizer {
        
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            if (self.activeRecognizers.count == 0)
                
            [self.activeRecognizers addObject:recognizer];
            break;
            
        case UIGestureRecognizerStateEnded:
            self.img.transform = [self applyRecognizer:recognizer toTransform:self.img.transform];
            [self.activeRecognizers removeObject:recognizer];
            break;
            
        case UIGestureRecognizerStateChanged: {
            CGAffineTransform transform = self.img.transform;
            for (UIGestureRecognizer *recognizer in self.activeRecognizers)
                transform = [self applyRecognizer:recognizer toTransform:transform];
            self.img.transform = transform;
            break;
        }
            
        default:
            break;
    }
}

- (CGAffineTransform)applyRecognizer:(UIGestureRecognizer *)recognizer toTransform:(CGAffineTransform)transform
{
    if ([recognizer respondsToSelector:@selector(rotation)])
    {
        return CGAffineTransformRotate(transform, [(UIRotationGestureRecognizer *)recognizer rotation]);
    }
    else if ([recognizer respondsToSelector:@selector(scale)]) 
    {
        CGFloat scale = [(UIPinchGestureRecognizer *)recognizer scale];
        return CGAffineTransformScale(transform, scale, scale);
    }
    else
        return transform;
}


@end
