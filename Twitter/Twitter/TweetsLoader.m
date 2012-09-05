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

@interface TweetsLoader ()

@property (strong, nonatomic) Loginer* loginer;
- (void) getHomeTimeline;

@end

@implementation TweetsLoader

@synthesize loginer;

- (id) initWithLoginer:(Loginer*)log
{
    self = [super init];
    if(self)
    {
        self.loginer = log;
    }
    return self;
}

- (void) getHomeTimeline
{
	OAConsumer *consumer = [[OAConsumer alloc] initWithKey:self.loginer.consumerKey
													secret:self.loginer.consumerSecret];
	
	OADataFetcher *fetcher = [[OADataFetcher alloc] init];
	
	NSURL *url = [NSURL URLWithString:@"http://api.twitter.com/1/statuses/home_timeline.xml"];
	
	OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url
																   consumer:consumer
																	  token:self.loginer.accessToken
																	  realm:nil
														  signatureProvider:nil];
	NSLog(@"Getting home timeline...");
	
	[fetcher fetchDataWithRequest:request 
						 delegate:self
				didFinishSelector:@selector(apiTicket:didFinishWithData:)
				  didFailSelector:@selector(apiTicket:didFailWithError:)];	
}

- (void) apiTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{
	if (ticket.didSucceed)
	{
		NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		NSLog(@"Got home timeline. Length: %d.", [responseBody length]);
		NSLog(@"Body:\n%@", responseBody);
	}
}

- (void) apiTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error
{
	NSLog(@"Getting home timeline failed: %@", [error localizedDescription]);
}

@end
