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
@synthesize requestSender2;

- (void)viewDidUnload
{
    [self setAvatar:nil];
    [self setNameLable:nil];
    [self setLinkLable:nil];
    
    self.requestSender = nil;
    self.requestSender2 = nil;

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
    
    NSString* url = [NSString stringWithFormat:@"https://graph.facebook.com/me?access_token=%@", kKey];

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
    
    self.requestSender = [[RequestSender alloc] initWithURL:url andWithBlock:block];
    
    [self loadImage];
}

- (void) loadImage {
    
    dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    
    dispatch_sync(q,^(void){
        
        NSString* url = [NSString stringWithFormat:@"https://graph.facebook.com/me/picture?access_token=%@", kKey];

        __block UserInfoViewController* safeSelf = self;
        OnFinishLoading block = ^(NSData* data, NSError* error)
        {
            if (error)
                return;

            UIImage * img = [UIImage imageWithData:data];

            dispatch_async(dispatch_get_main_queue(),^(void){
                safeSelf.avatar.image = img;
            });
        };
        
        self.requestSender2 = [[RequestSender alloc] initWithURL:url 
                                                 withHTTPMethod:@"GET" 
                                                 withParameters:nil 
                                                      withBlock:block];
   });
}

@end
