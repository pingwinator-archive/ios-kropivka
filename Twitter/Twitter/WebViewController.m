//
//  WebViewController.m
//  Twitter
//
//  Created by Michail Kropivka on 04.09.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WebViewController.h"
#import "Loginer.h"

#define kTel @"tel:"

@interface WebViewController () <UIWebViewDelegate>
@property (strong, nonatomic) UIWebView* web;
@property (strong, nonatomic) NSString* url;

- (void) hide;

@end


@implementation WebViewController

@synthesize web;
@synthesize url;
@synthesize token;
@synthesize delegate;



- (void) viewDidUnload {
    self.web = nil;
    self.url =  nil;
    self.token = nil;

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
    
    NSURL *url1 = [NSURL URLWithString:self.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url1];
    
    [web loadRequest:request];
}

- (void) gotPin: (NSString *) pin {
    
    NSLog(@"GOT PIN: %@", pin);
    [self.delegate getAccessTokenWithPin:pin];
    [self hide];
}

- (void) hide {
	[self performSelector: @selector(dismissModalViewControllerAnimated:) withObject:(id)kCFBooleanTrue afterDelay: 0.0];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlStr = [[request URL] absoluteString];
    
    //  format: tel:1349166
    if([[urlStr substringToIndex:kTel.length] isEqualToString:kTel])
    {
        [self gotPin:[urlStr substringFromIndex:kTel.length]];
    }
    
    NSLog(@"url = %@", urlStr);
    
    NSData *data = [request HTTPBody];
	char *raw = data ? (char *) [data bytes] : "";
	
	if (raw && (strstr(raw, "cancel=") || strstr(raw, "deny="))) {
		[self hide];
		return NO;
	}
	return YES;
}


@end
