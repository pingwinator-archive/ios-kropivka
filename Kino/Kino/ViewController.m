//
//  ViewController.m
//  Kino
//
//  Created by Michail Kropivka on 28.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "MyEntity.h"
#import "AppDelegate.h"


@implementation ViewController

@synthesize list;
@synthesize button;
@synthesize tap;
@synthesize fetchedResultsController;

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.list = [[NSArray alloc] init];
    
    // INIT
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate]; 
    NSManagedObjectContext *context = [appDelegate managedObjectContext]; 
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:NSStringFromClass([MyEntity class])
                                                         inManagedObjectContext:context];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init]; //initWithEntityName
    fetchRequest.entity = entityDescription;
    fetchRequest.sortDescriptors = [[NSArray alloc] initWithArray:nil];
    // FRC initialize
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
                                                                        managedObjectContext:context 
                                                                          sectionNameKeyPath:nil 
                                                                                   cacheName:@"Root"];
    self.fetchedResultsController.delegate = self; 
    NSError *error;
    BOOL success = [self.fetchedResultsController performFetch:&error];
        
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addLine:)];
    self.tap.numberOfTapsRequired = 3;
    [self.view addGestureRecognizer:self.tap];
    
    self.button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [self.button addTarget:self action:@selector(addLine:) 
          forControlEvents:UIControlEventTouchUpInside];
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return self.button;
}

- (void)addLine:(id)sender {
    NSLog(@"Tap recognized or button pressed");

}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

#pragma mark - UITableViewDataSource

//- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView 
//{
//    return [[self.fetchedResultsController sections] count];
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.fetchedResultsController fetchedObjects] count]; 
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle 
                                      reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    // Configure the cell.

    MyEntity * entity = (MyEntity*)[fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = [entity.number stringValue];
    cell.detailTextLabel.text = [entity.date description];
    
    return cell;
}


@end
