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

@end

@implementation TweetsLoader

@synthesize loginer;
@synthesize tweets;

- (id) initWithLoginer:(Loginer*)log
{
    self = [super init];
    if(self)
    {
        self.loginer = log;
    }
    return self;
}

- (void) loadTweets
{
    NSURL *url = [NSURL URLWithString:@"http://api.twitter.com/1/statuses/home_timeline.json"];
	OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url
																   consumer:[self.loginer consumer]
																	  token:self.loginer.accessToken
																	  realm:nil
														  signatureProvider:nil];
	NSLog(@"Getting home timeline...");
    
    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
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
