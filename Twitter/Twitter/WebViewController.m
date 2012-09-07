//
//  WebViewController.m
//  Twitter
//
//  Created by Michail Kropivka on 04.09.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WebViewController.h"
#import "Loginer.h"
#import "ActivityView.h"

#define kDeniedUrl @"http://kropivka.com/?denied="
#define kCancelUrl @"http://kropivka.com/?cancel="
#define kCallbackUrl @"http://kropivka.com/?"
#define kValidPage @"https://api.twitter.com/oauth/authorize"

@interface WebViewController () <UIWebViewDelegate>

@property (strong, nonatomic) UIWebView* web;
@property (strong, nonatomic) NSString* url;
@property (strong, nonatomic) ActivityView* activityView;

- (void) hide;
- (void) clearCookies;

@end

@implementation WebViewController

@synthesize web;
@synthesize url;
@synthesize activityView;

@synthesize token;
@synthesize delegate;


- (void) viewDidUnload {
    self.web = nil;
    self.url =  nil;
    self.token = nil;
    self.activityView = nil;
    [super viewDidUnload];
}

- (id) initWithUrl:(NSString*)urlin {
    self = [super init];
    if (self) {
        self.url = urlin;

    }   
    return self;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    self.web.delegate = self;
    [self.view addSubview:self.web];
    
    self.activityView = [[ActivityView alloc] init];
    [self.web addSubview:self.activityView];
    self.activityView.center = self.view.center;

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [web loadRequest:request];
}

- (void) hide {
	[self performSelector: @selector(dismissModalViewControllerAnimated:) withObject:(id)kCFBooleanTrue afterDelay: 0.0];
}

-(void)clearCookies {
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString *urlStr = [[request URL] absoluteString];
    OXM_DLog(@"url = %@", urlStr);
    
    
    if( [urlStr hasPrefix:kDeniedUrl] || [urlStr hasPrefix:kCancelUrl] ) {
        [self hide];
        [self.delegate webViewFinished];
        return NO;
    }
    
    if( [urlStr hasPrefix:kCallbackUrl] ) {

        [self.delegate getAccessTokenWithData:[urlStr substringFromIndex:kCallbackUrl.length]];
        [self hide];
        [self clearCookies];
        return NO;
    }
    if( [urlStr hasPrefix:kValidPage] )        
        return YES;
    
	return NO;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self.activityView startActivityWithMessage:@"Loading..."];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.activityView stopActivity];
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self hide];
    [self.delegate webViewFinished];
}

@end
