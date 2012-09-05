//
//  TweetViewController.m
//  Twitter
//
//  Created by Michail Kropivka on 04.09.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TweetViewController.h"
#import "RequestSender.h"
#import "SBJson.h"
#import "Loginer.h"
#import "WebViewController.h"
#import "TweetsLoader.h"


@interface TweetViewController ()

@property (strong, nonatomic) RequestSender* requestSender;
@property (strong, nonatomic) TweetsLoader* tweetsLoader;
@property (strong, nonatomic) Loginer* log;

@end


@implementation TweetViewController

@synthesize requestSender;
@synthesize tweetsLoader;
@synthesize log;

- (void) viewDidUnload {
    self.requestSender = nil;
    self.tweetsLoader = nil;
    self.log = nil;
    
    [super viewDidUnload];
}

- (id) init {
    self = [super init];
    if(self)
    {
        self.log = [[Loginer alloc] init];
        self.log.delegate = self;
        self.tweetsLoader = [[TweetsLoader alloc] initWithLoginer:self.log];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated 
{
    
}

- (void) viewDidLoad {
    [super viewDidLoad];
        
    /*
        {
            SBJsonParser *parser = [[SBJsonParser alloc] init];
            NSString *json_string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            

            NSArray *answer = [parser objectWithString:json_string error:nil];       
            
            answer = nil;
        }
     */
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] 
                                              initWithTitle:@"Login" 
                                              style:UIBarButtonItemStylePlain
                                              target:self 
                                              action:@selector(loginAction)];
    
}

- (void) loginAction
{
    [self.log startLogin];   
}

#pragma mark - Table view data source

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle 
                                      reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.text = @"text";
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark - TweetViewControllerDelegate

- (void) showLoginWindow:(NSString*)address {
    if( [address length])
    {
        WebViewController *web = [[WebViewController alloc] initWithUrl:address];
        web.delegate = self.log;
        [self presentViewController:web animated:YES completion:^{        
        } ];
    }
}

- (void) userLoggedIn
{
    [self.tweetsLoader loadTweets];
}

@end
