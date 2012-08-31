//
//  View2Controller.m
//  Storyboard
//
//  Created by Michail Kropivka on 31.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "View2Controller.h"
#import "QuartzCore/QuartzCore.h"

@implementation View2Controller
@synthesize redView;
@synthesize greenView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidUnload
{
    [self setRedView:nil];
    [self setGreenView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)valuChanged:(id)sender {
    
    UISwitch* sw = (UISwitch*)sender;
    if ( sw.on )
        [self.view bringSubviewToFront:self.redView];
    else
        [self.view bringSubviewToFront:self.greenView];

}
- (IBAction)back:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}


@end
