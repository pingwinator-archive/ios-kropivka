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


- (NSManagedObjectContext *)context
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate]; 
    return appDelegate.managedObjectContext;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.list = [[NSArray alloc] init];
    
    NSManagedObjectContext *context = self.context; 
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:NSStringFromClass([MyEntity class])
                                                         inManagedObjectContext:context];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
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
    if (!success) {
        NSLog(@"performFetch faild");
    }
    
    // ADD user interaction
    
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteLine:)];
    self.tap.numberOfTapsRequired = 3;
    [self.view addGestureRecognizer:self.tap];
    
    self.button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [self.button addTarget:self action:@selector(addLine:) forControlEvents:UIControlEventTouchUpInside];
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return self.button;
}

- (void)addLine:(id)sender 
{
    MyEntity* entity = [NSEntityDescription insertNewObjectForEntityForName:@"MyEntity" inManagedObjectContext:self.context];

    entity.number = [NSNumber numberWithInt:rand()];
    entity.date = [NSDate date];
    
    [self.context save:nil];
}

- (void)deleteLine:(id)sender 
{
    id obj = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForSelectedRow]];
    if (obj) {
        [self.context deleteObject:obj];
        [self.context save:nil];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}


#pragma mark - UITableViewDataSource

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.fetchedResultsController fetchedObjects] count]; 
}

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
    MyEntity* entity = (MyEntity*)[fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = [entity.number stringValue];
    cell.detailTextLabel.text = [entity.date description];
    
    return cell;
}

#pragma mark - NSFetchedResultsControllerDelegate

-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller 
{
    [self.tableView beginUpdates];
}

-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath 
{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] 
                                  withRowAnimation:UITableViewRowAnimationTop];
            break;
        case NSFetchedResultsChangeUpdate:
            //TODO
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
                                  withRowAnimation:UITableViewRowAnimationBottom];
            break;
            
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                  withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                                  withRowAnimation:UITableViewRowAnimationNone];
            break;
            
        default:
            break;
    }
}

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller 
{
    [self.tableView endUpdates];
}

@end









