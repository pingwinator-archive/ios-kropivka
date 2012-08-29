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

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.list = [[NSArray alloc] init];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate]; 
    NSManagedObjectContext *context = [appDelegate managedObjectContext]; 
    
    NSEntityDescription *entityDescription = 
    [NSEntityDescription entityForName:NSStringFromClass([MyEntity class]) 
                inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    //NSPredicate *pred = [NSPredicate predicateWithFormat:@"(lineNum = %d)", i];
    
    [request setEntity:entityDescription];
    NSError *error; 
    NSArray *objects = [context executeFetchRequest:request error:&error]; 
    
    if ( objects == nil ) {
        NSLog(@"There was an error!"); // Do whatever error handling is appropriate
    } else {
        
        if ([objects count] > 0) 
            self.list = objects;
        else
        {
            //for (int i = 0; i < 8; ++i) {

            MyEntity* entity = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([MyEntity class]) inManagedObjectContext:context];
            
            entity.number = [[NSNumber alloc] initWithInt:rand()];
            entity.date = [NSDate date];
            
            [context save:&error];
                
            //}
        }
    }
    
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addLine:)];
    self.tap.numberOfTapsRequired = 3;
    [self.view addGestureRecognizer:self.tap];
    
    
//    self.button = [UIButton buttonWithType:UIButtonTypeContactAdd];
//    [self.button addTarget:self action:@selector(addItem:) 
//          forControlEvents:UIControlEventTouchUpInside];
//   
    
}

//-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    return self.button;
//}

- (void)addLine:(id)sender {
    NSLog(@"Tap recognized");
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

#pragma mark - UITableViewDataSource

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
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    // Configure the cell.

    MyEntity * entity = [self.list objectAtIndex:[indexPath row]];
    cell.textLabel.text = [entity.number stringValue];
    cell.detailTextLabel.text = [entity.date description];
    return cell;
}


@end
