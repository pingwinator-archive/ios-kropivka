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

@interface TweetsLoader ()

@property (strong, nonatomic) Loginer* loginer;
@property (assign, nonatomic) BOOL refresh;

- (void) loadTweetsForNextPage;

@end

@implementation TweetsLoader

@synthesize loginer;
@synthesize tweets;
@synthesize delegate;
@synthesize refresh;

-(void)dealloc{
    self.tweets = nil;
}

- (id) initWithLoginer:(Loginer*)log
{
    self = [super init];
    if(self)
    {
        self.loginer = log;
        self.tweets = [NSMutableArray array];
    }
    return self;
}

- (void) refreshTweets {
    self.refresh = YES;
    [self loadTweetsForNextPage];
}

- (void) silentPreload
{
    [self loadTweetsForNextPage];
}

- (void) loadTweetsForNextPage {
    NSString* baseUrl =  @"http://api.twitter.com/1/statuses/home_timeline.json%@"; 

    NSString* parameters = @"";
    if( [self.tweets count] && !refresh )
    {
        parameters = [NSString stringWithFormat:@"?max_id=%@",[[self.tweets lastObject] id]];
    }
    
    NSString* str = [NSString stringWithFormat:baseUrl, parameters];
    
    NSURL *url = [NSURL URLWithString:str];
	OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url
																   consumer:[self.loginer consumer]
																	  token:self.loginer.accessToken
																	  realm:nil
														  signatureProvider:nil];
	NSLog(@"Getting home timeline...");
    
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
        NSLog( @"Got home timeline." );
        
        if(self.refresh){
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
            //tw.date = NSDate ;
            NSLog(@"%@", [tweetDict objectForKey:@"created_at"] );
            [self.tweets addObject:tw];
        }
        self.refresh = NO;
        [self.delegate performSelectorOnMainThread:@selector(tweetsLoaded) withObject:nil waitUntilDone:YES];
	}
}

- (void) apiTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error
{
	NSLog(@"Getting home timeline failed: %@", [error localizedDescription]);
    //add delegate
}

@end
