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

#define kConsumerKey        @"mg74DLx2RcK3URAtlO6xHA"
#define kConsumerSecret     @"hL3Jss3x4r5qFgN5KbgfMErlP3rRHrSqyFHLCaVMVw"

#define kAccessTokenStr     @"AccessTokenHttp"

@interface Loginer ()
- (void) getRequestToken;
@end

@implementation Loginer

@synthesize delegate;
@synthesize accessToken;

- (void)dealloc {
    self.accessToken = nil;
}

- (void) logout {
    self.accessToken = nil;
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kAccessTokenStr];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) startLogin {
    
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

- (void) getRequestToken {
	NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/oauth/request_token"];
	
	OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url
																   consumer:[self consumer]
																	  token:nil
																	  realm:nil
														  signatureProvider:nil];
	[request setHTTPMethod:@"POST"];
	
	OXM_DLog(@"Getting request token...");
    
    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
	[fetcher fetchDataWithRequest:request 
						 delegate:self
				didFinishSelector:@selector(requestTokenTicket:didFinishWithData:)
				  didFailSelector:@selector(requestTokenTicket:didFailWithError:)];	
}

#pragma mark - LoginerDelegate

- (void) webViewFinished {
    OXM_DLog(@"Web View finished");
    [self.delegate userLoggedIn:NO];
}

- (void) getAccessTokenWithData:(NSString*)data {
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/oauth/access_token?%@",data]];
    
	OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url
																   consumer:[self consumer]
																	  token:nil
																	  realm:nil
														  signatureProvider:nil];
    
	[request setHTTPMethod:@"POST"];
	OXM_DLog(@"Getting access token...");
    
    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
	[fetcher fetchDataWithRequest:request 
						 delegate:self
				didFinishSelector:@selector(accessTokenTicket:didFinishWithData:)
				  didFailSelector:@selector(accessTokenTicket:didFailWithError:)];	
}

- (void) requestTokenTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data {
	if (ticket.didSucceed) {
		NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		accessToken = [[OAToken alloc] initWithHTTPResponseBody:responseBody];
		
		OXM_DLog(@"Got request token. Redirecting to twitter auth page...");
		
		NSString* address = [NSString stringWithFormat:
							 @"https://api.twitter.com/oauth/authorize?oauth_token=%@",
							 accessToken.key];
        
        [self.delegate showLoginWindow:address];
	}
}

- (void) requestTokenTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error {
	OXM_DLog(@"Getting request token failed: %@", [error localizedDescription]);
    [self.delegate userLoggedIn:NO];
}

- (void) accessTokenTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data {
	if (ticket.didSucceed)
	{
		NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		self.accessToken = [[OAToken alloc] initWithHTTPResponseBody:responseBody];
		
		OXM_DLog(@"Got access token. Ready to use Twitter API.");
        
        if(kUseLoginCache) {
            [[NSUserDefaults standardUserDefaults] setObject:responseBody forKey:kAccessTokenStr];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        [self.delegate userLoggedIn:YES];
	}
}

- (void) accessTokenTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error {
	OXM_DLog(@"Getting access token failed: %@", [error localizedDescription]);
    [self.delegate userLoggedIn:NO];
}



@end
