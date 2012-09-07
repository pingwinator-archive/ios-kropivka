//
//  TweetsLoader.m
//  Twitter
//
//  Created by Michail Kropivka on 05.09.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TweetsLoader.h"
#import "OAuthConsumer.h"
#import "Loginer.h"
#import "SBJson.h"
#import "Tweet.h"
#import "TweetViewController.h"
#import "NSDictionary+RequestAssitant.h"
#import "TweetViewCell.h"

@interface TweetsLoader ()

@property (strong, nonatomic) Loginer* loginer;
@property (assign, nonatomic) BOOL isRefreshing;
@property (strong, nonatomic) NSMutableDictionary* imageCache;
@property (assign, nonatomic) BOOL isPreLoading;

- (void) loadTweetsForNextPage;

@end

@implementation TweetsLoader

@synthesize loginer;
@synthesize tweets;
@synthesize delegate;
@synthesize isRefreshing;
@synthesize imageCache;
@synthesize isPreLoading;

- (void)dealloc {
    self.loginer = nil;
    self.tweets = nil;
    self.imageCache = nil;
}

- (id) initWithLoginer:(Loginer*)log {
    self = [super init];
    if(self)
    {
        self.loginer = log;
        self.tweets = [NSMutableArray array];
        self.isPreLoading = NO;
        self.imageCache = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void) refreshTweets {
    self.isRefreshing = YES;
    [self loadTweetsForNextPage];
}

- (void) silentPreload {
    [self loadTweetsForNextPage];
}

- (void) loadTweetsForNextPage {
    NSString* baseUrl =  @"http://api.twitter.com/1/statuses/home_timeline.json%@"; 

    NSString* parameters = @"";
    if( [self.tweets count] && !self.isRefreshing ) {
        parameters = [NSString stringWithFormat:@"?max_id=%@",[[self.tweets lastObject] id]];
    }
    
    NSString* url = [NSString stringWithFormat:baseUrl, parameters];
	OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]
																   consumer:[self.loginer consumer]
																	  token:self.loginer.accessToken
																	  realm:nil
														  signatureProvider:nil];
	OXM_DLog(@"Getting home timeline...");
    
    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
    dispatch_async(kBackgroundQueue, ^{
        [fetcher fetchDataWithRequest:request 
                             delegate:self
                    didFinishSelector:@selector(apiTicket:didFinishWithData:)
                      didFailSelector:@selector(apiTicket:didFailWithError:)];
    });
}

- (void) apiTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data {
	if(ticket.didSucceed) {
        OXM_DLog( @"Got home timeline." );
        
        if(self.isRefreshing) {
            [self.tweets removeAllObjects];
        }
        
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSString *json_string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSArray *mainArray = [parser objectWithString:json_string error:nil];    
        
        for(NSDictionary* tweetDict in mainArray)
        {
            Tweet* tw = [[Tweet alloc] init];
            
            tw.user = [[tweetDict objectForKey:@"user"] objectForKey:@"name"];
            tw.imgUrl = [[tweetDict objectForKey:@"user"] objectForKey:@"profile_image_url"];
            tw.text = [tweetDict objectForKey:@"text"];
            tw.id = [tweetDict objectForKey:@"id"];
            
            [self.tweets addObject:tw];
        }
        self.isRefreshing = NO;
        self.isPreLoading = NO;
        [self.delegate performSelectorOnMainThread:@selector(tweetsLoaded) withObject:nil waitUntilDone:YES];
	}
}

- (void) apiTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error {
	OXM_DLog(@"Getting home timeline failed: %@", [error localizedDescription]);
    //add delegate
}

#pragma mark - Table view data source

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    OXM_DLog(@"tweets count %d",[self.tweets count]);
    return [self.tweets count];
}

- (TweetViewCell*) configureCell:(TweetViewCell*)cell withIndexPath:(NSIndexPath *)indexPath {
    Tweet* tw = [self.tweets objectAtIndex:indexPath.row];
    [cell setTweet:tw withImageCache:self.imageCache];
    [cell setRow:indexPath.row];
    
    if( !self.isPreLoading && [self.tweets count] - indexPath.row < kTweetsCountLeftForPreloading ) {
        self.isPreLoading = YES;
        [self silentPreload];
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


@end
