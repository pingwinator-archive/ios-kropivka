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
@property (strong, nonatomic) Loginer* loginer;
@property (strong, nonatomic) ActivityView* activityView;
@property (strong, nonatomic) UIImageView* twitterLogo;

@end


@implementation TweetViewController

@synthesize requestSender;
@synthesize tweetsLoader;
@synthesize loginer;
@synthesize activityView;
@synthesize twitterLogo;

- (void) viewDidUnload {
    self.requestSender = nil;
    self.tweetsLoader = nil;
    self.loginer = nil;
    self.activityView = nil;
    
    [super viewDidUnload];
}

- (void) setupActivityIndicator {
    self.activityView = [[ActivityView alloc] init];
}

- (void)setupTwitterLogo {
    NSString* path = [[NSBundle  mainBundle] pathForResource:@"twitter-logo" ofType:@"jpg"];
    self.twitterLogo = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:path]];
    self.twitterLogo.frame = CGRectMake(0, 0, 320, 480);
}

- (id) init {
    self = [super init];
    if(self)
    {
        self.loginer = [[Loginer alloc] init];
        self.loginer.delegate = self;
        
        self.tweetsLoader = [[TweetsLoader alloc] initWithLoginer:self.loginer];
        self.tweetsLoader.delegate = self;
        self.tableView.dataSource = self.tweetsLoader;
        
        [self setupActivityIndicator];
        [self setupTwitterLogo];
        
        self.navigationItem.title = @"Twitter";
        
        [self atLogouted];
    }
    return self;
}

- (void) viewDidAppear:(BOOL)animated {
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
    self.tableView.tableHeaderView = self.twitterLogo;
}

-(void) atLoginned {
    self.navigationItem.rightBarButtonItem.title = @"Logout";
    self.tableView.userInteractionEnabled = YES;
    self.tableView.tableHeaderView = nil;
}

- (void) loginButtonAction {
    if( !self.loginer.accessToken ) {
        [self.activityView startActivityWithMessage:@"Loading..." onView:self.view];
        [self.loginer startLogin];
    } else {
        [self atLogouted];
        [self.loginer logout];
        [self.tweetsLoader.tweets removeAllObjects];
        [self.tableView reloadData];
    }
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Tweet* tw = [self.tweetsLoader.tweets objectAtIndex:indexPath.row];
    return tw.fullHeight;
}

#pragma mark - TweetViewControllerDelegate

- (void) showLoginWindow:(NSString*)address {
    if( [address length] ) {
        [self.activityView stopActivity];
        WebViewController *web = [[WebViewController alloc] initWithUrl:address];
        web.delegate = self.loginer;
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
        [self.loginer logout];
    }
}

- (void) tweetsLoaded {
    OXM_DLog(@"Tweets Loaded");
    [self.tableView reloadData];
}

#pragma mark - Pull2RefreshViewController

- (void) refresh {
    [super refresh];
    OXM_DLog(@"Refresh...");
    [self.tweetsLoader refreshTweets];
}
@end
