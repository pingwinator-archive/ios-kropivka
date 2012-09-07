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

#define kDeniedUrl      @"http://kropivka.com/?denied="
#define kCancelUrl      @"http://kropivka.com/?cancel="
#define kCallbackUrl    @"http://kropivka.com/?"
#define kValidPage      @"https://api.twitter.com/oauth/authorize"

@interface WebViewController () <UIWebViewDelegate>

@property (strong, nonatomic) UIWebView* webView;
@property (strong, nonatomic) NSString* url;
@property (strong, nonatomic) ActivityView* activityView;

- (void)setupWebView;
- (void)setupActivityView;

- (void) hide;
- (void) clearCookies;

@end


@implementation WebViewController

@synthesize webView;
@synthesize url;
@synthesize activityView;

@synthesize delegate;

- (void) viewDidUnload {
    self.webView = nil;
    self.url =  nil;
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

- (void)setupWebView {
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
}

- (void)setupActivityView {
    self.activityView = [[ActivityView alloc] init];
}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    [self setupWebView];
    [self setupActivityView];

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [self.webView loadRequest:request];
}

- (void) hide {
	[self performSelector: @selector(dismissModalViewControllerAnimated:) withObject:(id)kCFBooleanTrue afterDelay: 0.0];
}

-(void) clearCookies {
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
}

- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString *urlStr = [[request URL] absoluteString];
    OXM_DLog(@"Url = %@", urlStr);
    
    BOOL res = NO;
    
    if( [urlStr hasPrefix:kDeniedUrl] || [urlStr hasPrefix:kCancelUrl] ) {
        [self hide];
        [self.delegate webViewFinished];
        res = NO;
    } else if( [urlStr hasPrefix:kCallbackUrl] ) {
        [self.delegate getAccessTokenWithData:[urlStr substringFromIndex:kCallbackUrl.length]];
        [self hide];
        [self clearCookies];
        res = NO;
    } else if( [urlStr hasPrefix:kValidPage] ) {
        res = YES;
    }
    
	return res;
}

#pragma mark - UIWebViewDelegate

- (void) webViewDidStartLoad:(UIWebView *)webView {
    [self.activityView startActivityWithMessage:@"Loading..." onView:self.view];
}

- (void) webViewDidFinishLoad:(UIWebView *)webView {
    [self.activityView stopActivity];
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self hide];
    [self.delegate webViewFinished];
}

@end
