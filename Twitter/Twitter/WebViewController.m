//
//  WebViewController.m
//  Twitter
//
//  Created by Michail Kropivka on 04.09.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController () <UIWebViewDelegate>
@property (strong, nonatomic) UIWebView* web;
@property (strong, nonatomic) NSString* url;
@end


@implementation WebViewController

@synthesize web;
@synthesize url;
@synthesize token;

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
    
    self.web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 20, 320, 400)];
    self.web.delegate = self;
    [self.view addSubview:self.web];
    
    NSURL *url1 = [NSURL URLWithString:self.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url1];
    
    [web loadRequest:request];
}

- (void) denied {
	//[self performSelector: @selector(dismissModalViewControllerAnimated:) withObject:(id)kCFBooleanTrue afterDelay: 1.0];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	NSData				*data = [request HTTPBody];
	char				*raw = data ? (char *) [data bytes] : "";
	
	if (raw && (strstr(raw, "cancel=") || strstr(raw, "deny="))) {
		[self denied];
		return NO;
	}
	return YES;

}


@end
