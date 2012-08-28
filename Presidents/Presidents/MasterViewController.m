//
//  MasterViewController.m
//  Presidents
//
//  Created by Michail Kropivka on 28.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"
#import "Presidents.h"


@implementation MasterViewController

@synthesize detailViewController = _detailViewController;
@synthesize list;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Master", @"Master");
    }
    return self;
}
							
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad]; 
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Presidents" ofType:@"plist"];
    
    NSData *data;
    NSKeyedUnarchiver *unarchiver;
    
    data = [[NSData alloc] initWithContentsOfFile:path]; 
    unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data]; 
    NSMutableArray *array = [unarchiver decodeObjectForKey:@"Presidents"]; 
    self.list = array;
    [unarchiver finishDecoding];
    
    
    NSLog(@"%@", self.list);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.list count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle 
                                      reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    // Configure the cell.
    
    BIDPresident* president = [self.list objectAtIndex:[indexPath row]];
    
    cell.textLabel.text = president.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@",
                                 president.fromYear, president.toYear];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    BIDPresident *prez = [self.list objectAtIndex:[indexPath row]];
    DetailViewController *childController = [[DetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
    childController.title = prez.name; 
    childController.president = prez;
    childController.myParent = self;
    
    [self.navigationController pushViewController:childController animated:YES];
}
     

@end
