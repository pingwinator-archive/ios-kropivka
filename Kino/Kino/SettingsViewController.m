//
//  SettingsViewController.m
//  Kino
//
//  Created by Michail Kropivka on 29.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"
#import "AppDelegate.h"


@implementation SettingsViewController

@synthesize customRand;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) refreshFields 
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    self.customRand.on = [defaults boolForKey:kUseCustomRandom];
}

- (void)applicationWillEnterForeground:(NSNotification *)notification 
{ 
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
    [defaults synchronize]; 
    [self refreshFields];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.topViewController.title = @"Settings";
    
    UIApplication *app = [UIApplication sharedApplication]; 
    [[NSNotificationCenter defaultCenter] 
     addObserver:self                                                                                                    
     selector:@selector(applicationWillEnterForeground:) 
     name:UIApplicationWillEnterForegroundNotification 
     object:app];
    
    [self refreshFields];
}


- (void)viewDidUnload
{
    [self setCustomRand:nil];
    [super viewDidUnload];
}

- (IBAction)switchChanged:(id)sender 
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
    [defaults setBool:self.customRand.on forKey:kUseCustomRandom];
    [defaults synchronize];
}

- (IBAction)goBack:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}


@end
