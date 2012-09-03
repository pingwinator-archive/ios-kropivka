//
//  SearchCityViewController.h
//  UICities2
//
//  Created by Michail Kropivka on 03.09.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RequestSender;

@interface SearchCityViewController : UIViewController
 <UIPickerViewDataSource,UIPickerViewDelegate>
@property (strong, nonatomic) UIPickerView *firstPicker;
@property (strong, nonatomic) UIPickerView *secondPicker;
@property (strong, nonatomic) NSArray *statesList;
@property (strong, nonatomic) NSArray *countriesList;

@property (strong, nonatomic) RequestSender *requestSender;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
 

- (IBAction)showCities:(id)sender;


@end
