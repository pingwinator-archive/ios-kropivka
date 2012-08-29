//
//  SettingsViewController.h
//  Kino
//
//  Created by Michail Kropivka on 29.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController
@property (strong, nonatomic) IBOutlet UISwitch *customRand;
- (IBAction)switchChanged:(id)sender;
- (IBAction)goBack:(id)sender;

@end
