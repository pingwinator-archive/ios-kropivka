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
#import "ActivityView.h"

@interface TweetViewController ()

@property (strong, nonatomic) RequestSender* requestSender;
@property (strong, nonatomic) TweetsLoader* tweetsLoader;
@property (strong, nonatomic) Loginer* log;
@property (strong, nonatomic) NSMutableDictionary* imageCache;
@property (strong, nonatomic) ActivityView* activityView;
@property (assign, nonatomic) BOOL isPreLoading;
@property (strong, nonatomic) UIImageView* logo;

@end


@implementation TweetViewController

@synthesize requestSender;
@synthesize tweetsLoader;
@synthesize log;
@synthesize imageCache;
@synthesize activityView;
@synthesize isPreLoading;
@synthesize logo;

- (void) viewDidUnload {
    self.requestSender = nil;
    self.tweetsLoader = nil;
    self.log = nil;
    self.imageCache = nil;
    self.activityView = nil;
    
    [super viewDidUnload];
}

- (void)setupActivityIndicator {
    self.activityView = [[ActivityView alloc] init];
    //[self.view addSubview:self.activityView];
}

- (id) init {
    self = [super init];
    if(self)
    {
        self.log = [[Loginer alloc] init];
        self.log.delegate = self;
        
        self.tweetsLoader = [[TweetsLoader alloc] initWithLoginer:self.log];
        self.tweetsLoader.delegate = self;
        
        [self setupActivityIndicator];
        
        NSString* path = [[NSBundle  mainBundle] pathForResource:@"twitter-logo" ofType:@"jpg"];
        self.logo = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:path]];
        self.logo.frame = CGRectMake(0, 0, 320, 480);

        self.imageCache = [NSMutableDictionary dictionary];
        self.isPreLoading = NO;
        
        self.navigationItem.title = @"Twitter";
        
        [self atLogouted];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self loginButtonAction];  
    });
}

- (void) viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] 
                                              initWithTitle:@"Login" 
                                              style:UIBarButtonItemStylePlain
                                              target:self 
                                              action:@selector(loginButtonAction)];
}

-(void) atLogouted {
    self.navigationItem.rightBarButtonItem.title = @"Login";
    self.tableView.userInteractionEnabled = NO;
    self.tableView.tableHeaderView = self.logo;
}

-(void) atLoginned {
    self.navigationItem.rightBarButtonItem.title = @"Logout";
    self.tableView.userInteractionEnabled = YES;
    self.tableView.tableHeaderView = nil;
}

- (void) loginButtonAction {
    if( !self.log.accessToken ) {
        [self.activityView startActivityWithMessage:@"Loading..." onView:self.view];
        [self.log startLogin];
    } else {
        [self atLogouted];
        [self.log logout];
        [self.tweetsLoader.tweets removeAllObjects];
        [self.tableView reloadData];
    }
}

#pragma mark - Table view data source

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    OXM_DLog(@"tweets count %d",[self.tweetsLoader.tweets count]);
    return [self.tweetsLoader.tweets count];
}

- (TweetViewCell*) configureCell:(TweetViewCell*)cell withIndexPath:(NSIndexPath *)indexPath
{
    Tweet* tw = [self.tweetsLoader.tweets objectAtIndex:indexPath.row];
    [cell setTweet:tw withImageCache:self.imageCache];
    [cell setRow:indexPath.row];
    
    if( !self.isPreLoading && [self.tweetsLoader.tweets count] - indexPath.row < kTweetsCountLeftForPreloading ) {
        self.isPreLoading = YES;
        [self.tweetsLoader silentPreload];
    }

    return cell;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    TweetViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[TweetViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle 
                                    reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return [self configureCell:cell withIndexPath:indexPath];
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Tweet* tw = [self.tweetsLoader.tweets objectAtIndex:[indexPath row]];
    return tw.fullHeight;
}

#pragma mark - TweetViewControllerDelegate

- (void) showLoginWindow:(NSString*)address {
    if( [address length] ) {
        WebViewController *web = [[WebViewController alloc] initWithUrl:address];
        web.delegate = self.log;
        [self presentViewController:web animated:YES completion:nil];
    }
}

- (void) userLoggedIn:(BOOL)success {
    [self.activityView stopActivity];
    if( success ) {
        OXM_DLog(@"User logged in");
        [self.tweetsLoader refreshTweets];
        [self atLoginned];
    }else {
        [self.log logout];
    }
}

- (void) tweetsLoaded {
    [self.activityView stopActivity];
    OXM_DLog(@"Tweets Loaded");
    self.isPreLoading = NO;
    [self.tableView reloadData];
}

#pragma mark - Pull2RefreshViewController

- (void) refresh {
    [super refresh];
    OXM_DLog(@"Refresh...");
    [self.tweetsLoader refreshTweets];
}
@end
