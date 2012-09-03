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

@implementation SearchCityViewController
@synthesize firstPicker;
@synthesize secondPicker;
@synthesize statesList;
@synthesize countriesList;
@synthesize requestSender;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    self.statesList = [[NSArray alloc] initWithObjects:
    @"AL",
    @"AK",
    @"AZ",
    @"AR",
    @"CA",
    @"CO",
    @"CT",
    @"DE",
    @"FL",
    @"GA",
    @"HI",
    @"ID",
    @"IL",
    @"IN",
    @"IA",
    @"KS",
    @"KY",
    @"LA",
    @"ME",
    @"MD",
    @"MA",
    @"MI",
    @"MN",
    @"MS",
    @"MO",
    @"MT",
    @"NE",
    @"NV",
    @"NH",
    @"NJ",
    @"NM",
    @"NY",
    @"NC",
    @"ND",
    @"OH",
    @"OK",
    @"OR",
    @"PA",
    @"RI",
    @"SC",
    @"SD",
    @"TN",
    @"TX",
    @"UT",
    @"VT",
    @"VA",
    @"WA",
    @"WV",
    @"WI",
    @"WY", nil];

    self.countriesList = [[NSArray alloc] initWithObjects: nil];
}

- (void)viewDidUnload
{
    [self setFirstPicker:nil];
    [self setSecondPicker:nil];
    self.statesList = nil;
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
    if(pickerView == self.firstPicker)
    {
        return [self.statesList count];
    }
    else if (pickerView == self.secondPicker)
    {
        return [self.countriesList count];
    }
    
    return 0;
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
    if(pickerView == self.firstPicker)
    {
        return [self.statesList objectAtIndex:row];

    }
    else if (pickerView == self.secondPicker)
    {
        return [self.countriesList objectAtIndex:row];
    }
    
    return @"none";
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
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
            
            // Create new SBJSON parser object
            SBJsonParser *parser = [[SBJsonParser alloc] init];
            
            NSString *json_string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            //NSLog(@"%@",json_string);
            
            // parse the JSON response into an object      
            NSArray *answer = [parser objectWithString:json_string error:nil];
            
            NSMutableArray *tmp = [[NSMutableArray alloc] init];
            for (NSDictionary *obj in answer)
            {
                NSDictionary* dict = (NSDictionary*)obj;
                [tmp addObject:[dict objectForKey:@"county_name"] ];
            }
            
            safeSelf.countriesList = tmp;
            [safeSelf.secondPicker reloadAllComponents];
        };
        
        self.requestSender = [[RequestSender alloc] initWithURL:url andWithBlock:block];
    }
    else if (pickerView == self.secondPicker)
    {
        
    }
}

- (IBAction)showCities:(id)sender {
    
    NSInteger num = [self.firstPicker selectedRowInComponent:                     0];
    NSString* state = [self.statesList objectAtIndex:num];
    
     num = [self.secondPicker selectedRowInComponent:0];
    NSString* countrie = [self.countriesList objectAtIndex:num];
    
    NSString* url = [NSString stringWithFormat:
            @"http://api.sba.gov/geodata/all_links_for_county_of/%@/%@.json", countrie, state];
    NSLog(@"%@",url);
    __block SearchCityViewController* safeSelf = self;

    OnFinishLoading block = ^(NSData* data, NSError* error)
    {
        if (error) 
            return;
        
        // Create new SBJSON parser object
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        
        NSString *json_string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //NSLog(@"%@",json_string);
        
        // parse the JSON response into an object      
        NSArray *answer = [parser objectWithString:json_string error:nil];
        
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
        
        [safeSelf.navigationController pushViewController:cities animated:YES];
    };
    
    self.requestSender = [[RequestSender alloc] initWithURL:url andWithBlock:block];
}

@end
