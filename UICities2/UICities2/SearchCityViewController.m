//
//  SearchCityViewController.m
//  UICities2
//
//  Created by Michail Kropivka on 03.09.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SearchCityViewController.h"
#import "SBJson.h"
#import "RequestSender.h"
#import "CitiesViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface SearchCityViewController () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) UIPickerView *firstPicker;
@property (strong, nonatomic) UIPickerView *secondPicker;
@property (strong, nonatomic) NSArray *statesList;
@property (strong, nonatomic) NSArray *countriesList;

@property (strong, nonatomic) RequestSender *requestSender;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UIButton *showButton;

- (IBAction) showCities:(id)sender;
- (NSArray*) parseData:(NSData *)data;

@end

@implementation SearchCityViewController

@synthesize firstPicker;
@synthesize secondPicker;
@synthesize statesList;
@synthesize countriesList;
@synthesize requestSender;
@synthesize activityIndicator;
@synthesize showButton;

- (void) viewDidUnload {
    
    self.firstPicker = nil;
    self.secondPicker = nil;
    self.statesList = nil;
    self.countriesList = nil;
    self.requestSender = nil;
    self.activityIndicator = nil;
    self.showButton = nil;
    
    [super viewDidUnload];
}

#pragma mark - View lifecycle

- (void) viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.title = @"City Search";
    
    // init Pickers
    
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
    
    NSString * path = [[NSBundle mainBundle] pathForResource:@"States" ofType:@"plist"];
    self.statesList = [[NSArray alloc] initWithContentsOfFile:path];
    self.countriesList = [[NSArray alloc] initWithObjects: nil];
    
    // select default row
    NSInteger defRow = 0;
    [self.firstPicker selectRow:defRow inComponent:0 animated:YES];
    [self pickerView:self.firstPicker didSelectRow:defRow inComponent:0];
    
    [self.showButton.layer setCornerRadius:8.0f];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    NSInteger res = 0;
    
    if(pickerView == self.firstPicker)
    {
        res = [self.statesList count];
    }
    else if(pickerView == self.secondPicker)
    {
        res = [self.countriesList count];
    }
    
    return res;
}

#pragma mark - UIPickerViewDelegate<NSObject>

- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    NSString* res = nil;
    
    if(pickerView == self.firstPicker)
    {
        res = [self.statesList objectAtIndex:row];
    }
    else if (pickerView == self.secondPicker)
    {
        res = [self.countriesList objectAtIndex:row];
    }
    
    return res;
}


- (NSArray *) parseData:(NSData *)data {
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSString *json_string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return [parser objectWithString:json_string error:nil];
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(pickerView == self.firstPicker)
    {
        NSString* url = [NSString stringWithFormat:
                         @"http://api.sba.gov/geodata/city_links_for_state_of/%@.json", [self.statesList objectAtIndex:row]];
        
        __block SearchCityViewController* safeSelf = self;
        OnFinishLoading block = ^(NSData* data, NSError* error)
        {
            if (error) 
                return;
            
            NSArray *answer = [self parseData:data];
            
            NSMutableSet *tmp = [[NSMutableSet alloc] init];
            for (NSDictionary *obj in answer)
            {
                NSDictionary* dict = (NSDictionary*)obj;
                [tmp addObject:[dict objectForKey:@"county_name"] ];
            }
            safeSelf.countriesList = [[NSArray alloc] initWithArray:[tmp allObjects]];
            [safeSelf.secondPicker reloadAllComponents];
            [safeSelf.activityIndicator stopAnimating];
        };
        
        [self.activityIndicator startAnimating];
        
        self.requestSender = [[RequestSender alloc] initWithURL:url andWithBlock:block];
    }
    else if (pickerView == self.secondPicker)
    {
        // do nothing
    }
}

- (IBAction) showCities:(id)sender {
    
    NSInteger num = [self.firstPicker selectedRowInComponent:0];
    NSString* state = [self.statesList objectAtIndex:num];
    
    num = [self.secondPicker selectedRowInComponent:0];
    NSString* countrie = [self.countriesList objectAtIndex:num];
    
    NSString* url = [NSString stringWithFormat:
            @"http://api.sba.gov/geodata/all_links_for_county_of/%@/%@.json", countrie, state];

    __block SearchCityViewController* safeSelf = self;
    OnFinishLoading block = ^(NSData* data, NSError* error)
    {
        if (error)
            return;
        
        NSArray *answer = [self parseData:data];
        
        NSMutableArray *tmpCities = [[NSMutableArray alloc] init];
        NSMutableArray *tmpDesc = [[NSMutableArray alloc] init];

        for (NSDictionary *obj in answer)
        {
            NSDictionary* dict = (NSDictionary*)obj;
            [tmpCities addObject:[dict objectForKey:@"name"] ];
            [tmpDesc addObject:dict];
        }
        
        CitiesViewController* cities = [[CitiesViewController alloc] init];

        cities.citiesList = tmpCities;
        cities.descList = tmpDesc;
        
        [safeSelf.activityIndicator stopAnimating];
        [safeSelf.navigationController pushViewController:cities animated:YES];
    };
    [self.activityIndicator startAnimating];
    self.requestSender = [[RequestSender alloc] initWithURL:url andWithBlock:block];
}

@end
