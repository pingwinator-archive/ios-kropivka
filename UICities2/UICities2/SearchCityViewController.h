//
//  SearchCityViewController.h
//  UICities2
//
//  Created by Michail Kropivka on 03.09.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchCityViewController : UIViewController
 <UIPickerViewDataSource,UIPickerViewDelegate>
@property (strong, nonatomic) IBOutlet UIPickerView *firstPicker;
@property (strong, nonatomic) IBOutlet UIPickerView *secondPicker;
@property (strong, nonatomic) NSArray *statesList;
 

- (IBAction)showCities:(id)sender;


@end
