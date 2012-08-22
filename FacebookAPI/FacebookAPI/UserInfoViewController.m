//
//  UserInfoViewController.m
//  FacebookAPI
//
//  Created by Michail Kropivka on 22.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserInfoViewController.h"
#import "RequestSender.h"
#import "SBJson.h"

@implementation UserInfoViewController

@synthesize avatar;
@synthesize nameLable;
@synthesize linkLable;
@synthesize requestSender;

- (void)viewDidUnload
{
    [self setAvatar:nil];
    [self setNameLable:nil];
    [self setLinkLable:nil];
    
    self.requestSender = nil;
    
    [super viewDidUnload];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    

    NSString* urlstr = [[NSString alloc] initWithFormat:@"https://graph.facebook.com/me?access_token=%@",kKey];
    // get user info
    NSURL* url = [NSURL URLWithString:urlstr];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url]; 
    [urlRequest setHTTPMethod:@"GET"];
    
    //__block = nil;
    __block UserInfoViewController* safeSelf = self;
    
    OnFinishLoading block = ^(NSData* data, NSError* error)
    {
        if (error)
            return;
        
        // Create new SBJSON parser object
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        
        NSString *json_string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",json_string);
        
        // parse the JSON response into an object      
        NSDictionary *answerID = [parser objectWithString:json_string error:nil];
        
        safeSelf.nameLable.text = [answerID objectForKey:@"name"];
        safeSelf.linkLable.text = [answerID objectForKey:@"link"];
    };
    
    self.requestSender = [[RequestSender alloc] initWithRequest:urlRequest andWithBlock:block];
   
}

@end
