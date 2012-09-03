//
//  CityDetailViewController.h
//  UICities2
//
//  Created by Michail Kropivka on 03.09.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CityDetailViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextView *text;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSString *name;

@end
