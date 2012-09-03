//
//  AddCityViewController.m
//  UICities2
//
//  Created by Michail Kropivka on 03.09.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddCityViewController.h"
#import "Cities+Helper.h"
#import "AppDelegate.h"

@implementation AddCityViewController
@synthesize text;
@synthesize name;
@synthesize description;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (NSManagedObjectContext *)context
{
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    return appDelegate.managedObjectContext;
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = self.name;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] 
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
                                              target:self 
                                              action:@selector(cancel)];
    self.text.text = self.description;
    
}

- (void)viewDidUnload
{
    self.text = nil;
    self.name = nil;
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)addAction:(id)sender {
    
    Cities* entity = [Cities entityWithContext:self.context];

    entity.city = self.name;
    entity.json = self.description;
    
    [self.context save:nil];
}

- (void)cancel {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
