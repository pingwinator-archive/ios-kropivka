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

#define kConsumerKey        @"xY36sQ4G9a7EIMaIg8yEhA"
#define kConsumerSecret     @"zztfHyLCcfQo4tP7bElIJNEVWVAfAKp4723iAT1Q"

#define kAccessTokenStr     @"AccessTokenHttp"

@interface Loginer ()
- (void) getRequestToken;
@end

@implementation Loginer

@synthesize delegate;
@synthesize accessToken;

-(void)dealloc
{
    self.accessToken = nil;
}

-(void) startLogin {
    
    NSString* httpBody = [[NSUserDefaults standardUserDefaults] objectForKey:kAccessTokenStr];
    if( httpBody && kUseLoginCache ) {
        self.accessToken = [[OAToken alloc] initWithHTTPResponseBody:httpBody];
        [self.delegate userLoggedIn:YES];
    }else {
        [self getRequestToken];
    }
}

- (OAConsumer *)consumer {
    return [[OAConsumer alloc] initWithKey:kConsumerKey 
                                    secret:kConsumerSecret ];
}

- (void) getRequestToken
{
	NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/oauth/request_token"];
	
	OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url
																   consumer:[self consumer]
																	  token:nil
																	  realm:nil
														  signatureProvider:nil];
	[request setHTTPMethod:@"POST"];
	
	NSLog(@"Getting request token...");
    
    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
	[fetcher fetchDataWithRequest:request 
						 delegate:self
				didFinishSelector:@selector(requestTokenTicket:didFinishWithData:)
				  didFailSelector:@selector(requestTokenTicket:didFailWithError:)];	
}

- (void) getAccessTokenWithPin:(NSString*)pinCode
{
	NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/oauth/access_token"];
	
	self.accessToken.pin = pinCode;
	NSLog(@"Using PIN %@", self.accessToken.pin);
	
	OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url
																   consumer:[self consumer]
																	  token:self.accessToken
																	  realm:nil
														  signatureProvider:nil];
    
	[request setHTTPMethod:@"POST"];
	NSLog(@"Getting access token...");
    
    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
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
    [self.delegate userLoggedIn:NO];
}

- (void) accessTokenTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{
	if (ticket.didSucceed)
	{
		NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		self.accessToken = [[OAToken alloc] initWithHTTPResponseBody:responseBody];
		
		NSLog(@"Got access token. Ready to use Twitter API.");
        
        if(kUseLoginCache) {
            [[NSUserDefaults standardUserDefaults] setObject:responseBody forKey:kAccessTokenStr];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        [self.delegate userLoggedIn:YES];
	}
}

- (void) accessTokenTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error
{
	NSLog(@"Getting access token failed: %@", [error localizedDescription]);
    [self.delegate userLoggedIn:NO];
}

- (void) webViewFinished
{
    NSLog(@"Web View finished");
    [self.delegate userLoggedIn:NO];
}

@end
