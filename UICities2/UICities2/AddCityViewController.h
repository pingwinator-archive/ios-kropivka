//
//  AddCityViewController.h
//  UICities2
//
//  Created by Michail Kropivka on 03.09.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddCityViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextView *text;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSString *name;

- (IBAction)addAction:(id)sender;
- (void)cancelAction;
- (NSManagedObjectContext *)context;

@end
