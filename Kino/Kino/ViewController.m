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
#import "SettingsViewController.h"

@implementation ViewController

@synthesize button;
@synthesize buttonJump;
@synthesize tap;
@synthesize fetchedResultsController;


- (NSManagedObjectContext *)context
{
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    return appDelegate.managedObjectContext;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    
    self.buttonJump = [UIButton buttonWithType:UIButtonTypeInfoDark];
    //[self.buttonJump  setTitle:@"2342" forState:UIControlStateNormal];
    [self.buttonJump addTarget:self action:@selector(showSettings:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)showSettings:(id)sender 
{
    SettingsViewController* view = [[SettingsViewController alloc] init];
    [self.navigationController pushViewController:view animated:YES];
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return self.buttonJump;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.button;
}

- (NSNumber *)randFromSite
{
    NSNumber* num = [NSNumber numberWithInt:0];
    
    // request
    NSString* urlStr = @"http://www.random.org/integers/?num=1&min=1&max=100&col=1&base=10&format=plain&rnd=new";
    NSURL* url = [NSURL URLWithString:urlStr];
    NSURLRequest* req = [[NSURLRequest alloc] initWithURL:url];
    
    NSData* data = [NSURLConnection sendSynchronousRequest:req  returningResponse:nil error:nil];
    if (data) 
    {
        NSString* st = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        st = [st substringToIndex:[st length]-1]; // remove \n in the end
        
        // NSString -> NSNumber
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        num = [f numberFromString:st];
    }
    return num;
}

- (void)addLine:(id)sender 
{
    MyEntity* entity = [NSEntityDescription insertNewObjectForEntityForName:@"MyEntity" inManagedObjectContext:self.context];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if( [defaults boolForKey:kUseCustomRandom] )
    {
        entity.number = [self randFromSite];
    }
    else
    {
        entity.number = [NSNumber numberWithInt:rand()];

    }
    
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









