//
//  FavTableViewController.m
//  UICities2
//
//  Created by Michail Kropivka on 03.09.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FavTableViewController.h"

#import "AppDelegate.h"
#import "Cities+Helper.h"
#import "SearchCityViewController.h"
#import "CityDetailViewController.h"

@interface FavTableViewController () <UITableViewDataSource, NSFetchedResultsControllerDelegate, UISearchBarDelegate>
@end


@implementation FavTableViewController

@synthesize fetchedResultsController;
@synthesize searchBar;

#pragma mark - View lifecycle

- (void)viewDidUnload
{
    self.fetchedResultsController = nil;
    self.searchBar = nil;
    
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // init CoreData
    
    [NSFetchedResultsController deleteCacheWithName:@"Root"];  

    NSManagedObjectContext *context = self.context; 
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:NSStringFromClass([Cities class])
                                                         inManagedObjectContext:context];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = entityDescription;
    fetchRequest.sortDescriptors = [[NSArray alloc] initWithArray:nil];
    
    // sort
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"city" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    fetchRequest.sortDescriptors = sortDescriptors;
    
    
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
    
    
    self.navigationItem.title = @"Favourites";
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] 
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
                                              target:self 
                                              action:@selector(addCityAction)];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 64, 320, 64)];
    self.searchBar.delegate = self;
    self.tableView.tableHeaderView = self.searchBar;
}


- (NSManagedObjectContext *)context
{
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    return appDelegate.managedObjectContext;
}

- (void)addCityAction
{
    SearchCityViewController* searchCity = [[SearchCityViewController alloc] init];
    [self.navigationController pushViewController:searchCity animated:YES];
}


#pragma mark - Table view data source

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
    
    Cities* entity = (Cities*)[fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = entity.city;
    
    return cell;
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete )
    {
        id obj = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [obj removeWithContext:self.context];
    }
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


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CityDetailViewController *detailViewController = [[CityDetailViewController alloc] initWithNibName:@"CityDetailViewController" bundle:nil];
    
    Cities* entity = (Cities*)[fetchedResultsController objectAtIndexPath:indexPath];
    
    detailViewController.description = entity.json;
    detailViewController.name = entity.city;

    [self.navigationController pushViewController:detailViewController animated:YES];
}

#pragma mark - UISearchBarDelegate delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
// called when text changes (including clear)
    
    // called when text starts editing
    if ([self.searchBar.text length])
    {
        [NSFetchedResultsController deleteCacheWithName:@"Root"];  
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"city BEGINSWITH[cd] %@", self.searchBar.text];
        [self.fetchedResultsController.fetchRequest setPredicate:predicate];
        NSError *error = nil;
        if (![self.fetchedResultsController performFetch:&error]) {   
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        [self.tableView reloadData];
    }
    else
    {
        [NSFetchedResultsController deleteCacheWithName:@"Root"];  
        
        [self.fetchedResultsController.fetchRequest setPredicate:nil];
        NSError *error = nil;
        if (![self.fetchedResultsController performFetch:&error]) {   
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
        [self.tableView reloadData];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [self.searchBar resignFirstResponder];
}


- (void)resignFirsRespounder
{
    [self.searchBar resignFirstResponder];
}

@end
