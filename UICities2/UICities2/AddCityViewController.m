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
#import <QuartzCore/QuartzCore.h>

@implementation AddCityViewController

@synthesize text;
@synthesize name;
@synthesize addButton;
@synthesize description;

#pragma mark - View lifecycle

- (void)viewDidUnload
{
    self.text = nil;
    self.name = nil;
    self.description = nil;
    
    [self setAddButton:nil];
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = self.name;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] 
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
                                              target:self 
                                              action:@selector(cancelAction)];
    self.text.text = self.description;
    [self.addButton.layer setCornerRadius:8.0f];

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // nil
    }
    return self;
}

#pragma mark - actions

- (IBAction)addAction:(id)sender {
    
    
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Cities" inManagedObjectContext:self.context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    // Set example predicate and sort orderings...
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"json == %@", self.description];
    
    [request setPredicate:predicate];

    
    NSError *error = nil;
    NSArray *array = [self.context executeFetchRequest:request error:&error];
    if ([array count]) 
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Sorry" 
                                                        message:@"This City alredy added" 
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        Cities* entity = [Cities entityWithContext:self.context];
        
        entity.city = self.name;
        entity.json = self.description;
        
        [self.context save:nil];
        [self cancelAction];
    }
    

}

- (void)cancelAction {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (NSManagedObjectContext *)context
{
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    return appDelegate.managedObjectContext;
}

@end
