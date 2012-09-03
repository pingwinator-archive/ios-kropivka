//
//  SearchCityViewController.m
//  UICities2
//
//  Created by Michail Kropivka on 03.09.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SearchCityViewController.h"

@implementation SearchCityViewController
@synthesize firstPicker;
@synthesize secondPicker;
@synthesize statesList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"City Search";
    
    // init Pickerd Views
    
    self.firstPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 49-20, 320, 120)];
    self.firstPicker.delegate = self;
	self.firstPicker.dataSource = self;
	self.firstPicker.showsSelectionIndicator = YES;
    self.firstPicker.transform = CGAffineTransformMakeScale(1, 0.8);
    [self.view addSubview:self.firstPicker];

    self.secondPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 209-20, 320, 120)];
    self.secondPicker.delegate = self;
	self.secondPicker.dataSource = self;
	self.secondPicker.showsSelectionIndicator = YES;
    self.secondPicker.transform = CGAffineTransformMakeScale(1, 0.8);
    [self.view addSubview:self.secondPicker];
    
    // init list of states
    

    
}

- (void)viewDidUnload
{
    [self setFirstPicker:nil];
    [self setSecondPicker:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 3;
}

#pragma mark - UIPickerViewDelegate<NSObject>

/*
// returns width of column and height of row for each component. 
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 32;  
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 32;
}
*/

// these methods return either a plain UIString, or a view (e.g UILabel) to display the row for the component.
// for the view versions, we cache any hidden and thus unused views and pass them back for reuse. 
// If you return back a different object, the old one will be released. the view will be centered in the row rect  

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return @"title";
}

/*
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    
}
*/

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(pickerView == self.firstPicker)
    {
        
    }
    else if (pickerView == self.secondPicker)
    {
        
    }
}

- (IBAction)showCities:(id)sender {
}
@end
