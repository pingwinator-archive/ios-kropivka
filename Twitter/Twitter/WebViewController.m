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


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    /*
    //Получаем URL
    NSURL *url1 = [request URL];
    
    //Проверяем на соответствие пользовательской URL-схеме
    //if ([url.scheme isEqualToString:URL_SCHEME])
    {
        //убираем индикатор сетевой активности
        UIApplication* app = [UIApplication sharedApplication];
        app.networkActivityIndicatorVisible = NO;
        
        //разбираем URL на отдельные элементы
        //наш токен будет в массиве arr под индексом 2
        NSArray *arr = [[url1 description] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"#=&"]];
        
        //говорим делегату об успешной авторизации и передаем токен

        self.token = [arr objectAtIndex:2];
        
        //запрещаем UIWebView открывать URL
        return NO;
    }
    */
    //разрешаем UIWebView переход по URL
    return YES;
}


@end
