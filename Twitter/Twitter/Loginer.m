//
//  Loginer.m
//  Twitter
//
//  Created by Michail Kropivka on 04.09.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Loginer.h"
#import "OAConsumer.h"
#import "OADataFetcher.h"
#import "OAToken.h"
#import "WebViewController.h"
#import "TweetViewController.h"

@interface Loginer ()
- (void) getRequestToken;
@end


@implementation Loginer

@synthesize delegate;

@synthesize consumerKey;
@synthesize consumerSecret;
@synthesize accessToken;

-(void)dealloc
{
    self.consumerKey = nil;
    self.consumerSecret = nil;
    self.accessToken = nil;
}

-(void) startLogin {
    if ( !self.accessToken ) {
        [self getRequestToken];
    }
}

- (void) getRequestToken
{
	OAConsumer *consumer = [[OAConsumer alloc] initWithKey:self.consumerKey 
													secret:self.consumerSecret ];
	
	OADataFetcher *fetcher = [[OADataFetcher alloc] init];
	
	NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/oauth/request_token"];
	
	OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url
																   consumer:consumer
																	  token:nil
																	  realm:nil
														  signatureProvider:nil];
	[request setHTTPMethod:@"POST"];
	
	NSLog(@"Getting request token...");
	
	[fetcher fetchDataWithRequest:request 
						 delegate:self
				didFinishSelector:@selector(requestTokenTicket:didFinishWithData:)
				  didFailSelector:@selector(requestTokenTicket:didFailWithError:)];	
}


- (void) getAccessTokenWithPin:(NSString*)pinCode
{
	OAConsumer *consumer = [[OAConsumer alloc] initWithKey:self.consumerKey
													secret:self.consumerSecret];
	
	OADataFetcher *fetcher = [[OADataFetcher alloc] init];
	
	NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/oauth/access_token"];
	
	self.accessToken.pin = pinCode;
	NSLog(@"Using PIN %@", self.accessToken.pin);
	
	OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url
																   consumer:consumer
																	  token:self.accessToken
																	  realm:nil
														  signatureProvider:nil];
	
	[request setHTTPMethod:@"POST"];
	NSLog(@"Getting access token...");
	
	[fetcher fetchDataWithRequest:request 
						 delegate:self
				didFinishSelector:@selector(accessTokenTicket:didFinishWithData:)
				  didFailSelector:@selector(accessTokenTicket:didFailWithError:)];	
}

- (void) requestTokenTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{
	if (ticket.didSucceed)
	{
		NSString *responseBody = [[NSString alloc] initWithData:data 
													   encoding:NSUTF8StringEncoding];
		accessToken = [[OAToken alloc] initWithHTTPResponseBody:responseBody];
		
		NSLog(@"Got request token. Redirecting to twitter auth page...");
		
		NSString* address = [NSString stringWithFormat:
							 @"https://api.twitter.com/oauth/authorize?oauth_token=%@",
							 accessToken.key];
        
        [self.delegate showLoginWindow:address];
	}
}

- (void) requestTokenTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error
{
	NSLog(@"Getting request token failed: %@", [error localizedDescription]);
}

- (void) accessTokenTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{
	if (ticket.didSucceed)
	{
		NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		self.accessToken = [[OAToken alloc] initWithHTTPResponseBody:responseBody];
		
		NSLog(@"Got access token. Ready to use Twitter API.");
	}
}

- (void) accessTokenTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error
{
	NSLog(@"Getting access token failed: %@", [error localizedDescription]);
}

@end
