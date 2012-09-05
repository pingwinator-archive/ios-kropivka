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


#define kConsumerKey	@"xY36sQ4G9a7EIMaIg8yEhA"
#define kConsumerSecret	@"zztfHyLCcfQo4tP7bElIJNEVWVAfAKp4723iAT1Q"


@interface TweetViewController ()

@property (strong, nonatomic) RequestSender* requestSender;
@property (strong, nonatomic) NSMutableArray* tweets;
@property (strong, nonatomic) NSMutableArray* avatars;
@property (strong, nonatomic) Loginer* log;

@end


@implementation TweetViewController

@synthesize requestSender;
@synthesize tweets;
@synthesize avatars;
@synthesize log;

- (void) viewDidUnload {
    self.tweets = nil;
    self.avatars = nil;
    [super viewDidUnload];

}

- (void)viewDidAppear:(BOOL)animated{
    
    self.log = [[Loginer alloc] init];
    
    self.log.delegate = self;
    
    self.log.consumerKey = kConsumerKey;
    self.log.consumerSecret = kConsumerSecret;
    
    [self.log getRequestToken];
}

- (void) viewDidLoad {
    [super viewDidLoad];
        
    /*
    NSString* url = @"https://api.twitter.com/1/statuses/user_timeline.json";
    
    OnFinishLoading block = ^(NSData* data, NSError* error)
    {
        if (!error)
        {
            SBJsonParser *parser = [[SBJsonParser alloc] init];
            NSString *json_string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            

            NSArray *answer = [parser objectWithString:json_string error:nil];       
            
            answer = nil;
        }
    };
    
    self.requestSender = [[RequestSender alloc] initWithURL:url andWithBlock:block];
     */
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
    [log getAccessToken];
    [log getHomeTimeline];
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
