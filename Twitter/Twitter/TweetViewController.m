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
#import "Tweet.h"
#import "TweetViewCell.h"

@interface TweetViewController ()

@property (strong, nonatomic) RequestSender* requestSender;
@property (strong, nonatomic) TweetsLoader* tweetsLoader;
@property (strong, nonatomic) Loginer* log;
@property (strong, nonatomic) NSMutableDictionary* imageCache;

@end


@implementation TweetViewController

@synthesize requestSender;
@synthesize tweetsLoader;
@synthesize log;
@synthesize imageCache;

- (void) viewDidUnload {
    self.requestSender = nil;
    self.tweetsLoader = nil;
    self.log = nil;
    self.imageCache = nil;
    
    [super viewDidUnload];
}

- (id) init {
    self = [super init];
    if(self)
    {
        self.log = [[Loginer alloc] init];
        self.log.delegate = self;
        self.tweetsLoader = [[TweetsLoader alloc] initWithLoginer:self.log];
        self.tweetsLoader.delegate = self;
        
        self.imageCache = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated 
{
    
}

- (void) viewDidLoad {
    [super viewDidLoad];

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
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"tweets count %d",[self.tweetsLoader.tweets count]);
    return [self.tweetsLoader.tweets count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    TweetViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[TweetViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle 
                                      reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    Tweet* tw = [self.tweetsLoader.tweets objectAtIndex:[indexPath row]];
    cell.name.text = tw.user;
    cell.tweet.text = tw.text;
    
    __block UIImage* img = [imageCache objectForKey:tw.imgUrl];
    if( img ) {
        cell.avatar.image = img;
    } else {
        dispatch_queue_t global_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
        
        dispatch_async(global_queue, ^{
            NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:tw.imgUrl]];
            img = [[UIImage alloc] initWithData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.avatar.image = img;
            });
            tw.img = img;
            [imageCache setObject:img forKey:tw.imgUrl];
        });
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
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
    NSLog(@"User logged in");
    [self.tweetsLoader loadTweets];
    [self.tableView  reloadData];
}

- (void) tweetsLoaded
{
    NSLog(@"Tweets Loaded");
    [self.tableView reloadData]; 
}

@end
