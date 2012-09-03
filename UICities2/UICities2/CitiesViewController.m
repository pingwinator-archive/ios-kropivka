//
//  CitiesViewController.m
//  UICities2
//
//  Created by Michail Kropivka on 03.09.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CitiesViewController.h"
#import "AddCityViewController.h"

@implementation CitiesViewController

@synthesize citiesList;
@synthesize descList;

#pragma mark - View lifecycle

- (void)viewDidUnload
{
    self.citiesList = nil;
    self.descList = nil;
    
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Cities";
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) 
    {
        self.citiesList = [[NSArray alloc] init];
        self.descList = [[NSArray alloc] init];
    }
    return self;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.citiesList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [self.citiesList objectAtIndex:[indexPath row]];    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddCityViewController *detailViewController = [[AddCityViewController alloc] initWithNibName:@"AddCityViewController" bundle:nil];
    
    NSDictionary * dict = [self.descList objectAtIndex:[indexPath row]];

    detailViewController.description = [dict description];
    detailViewController.name = [self.citiesList objectAtIndex:[indexPath row]];

    [self.navigationController pushViewController:detailViewController animated:YES];
    
}

@end
