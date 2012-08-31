//
//  View2Controller.h
//  Storyboard
//
//  Created by Michail Kropivka on 31.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface View2Controller : UIViewController

@property (strong, nonatomic) IBOutlet UIView *redView;
@property (strong, nonatomic) IBOutlet UIView *greenView;

- (IBAction)valuChanged:(id)sender;
- (IBAction)back:(id)sender;

@end
