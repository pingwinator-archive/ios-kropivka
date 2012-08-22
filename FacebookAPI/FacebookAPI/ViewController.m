//
//  ViewController.m
//  FacebookAPI
//
//  Created by Michail Kropivka on 20.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "RequestSender.h"
#import "SBJson.h"
#import "UserInfoViewController.h"


@implementation ViewController
@synthesize sentPhoto;

@synthesize button;
@synthesize status;
@synthesize requestSender;

- (IBAction)buttonPressed:(id)sender 
{
    [self.status resignFirstResponder];
    self.button.enabled = NO;
    NSString* url = @"https://graph.facebook.com/me/feed";

    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [params setObject:status.text   forKey:@"message"];
    [params setObject:kKey           forKey:@"access_token"];
    __block ViewController* safeSelf = self;
    OnFinishLoading block = ^(NSData *data, NSError *error1) {
        
        NSString* message = nil;
        
        if ([data length] >0 && error1 == nil) 
        {
            SBJsonParser *parser = [[SBJsonParser alloc] init];
            
            NSString *json_string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            NSLog(@"%@", json_string);
            
            // parse the JSON response into an object      
            NSDictionary *answerID = [parser objectWithString:json_string error:nil];
            
            // check for correct json
            message = [answerID objectForKey:@"id"];
            if( [[answerID allKeys] count] > 0 && [(NSString*)[[answerID allKeys] objectAtIndex:0] isEqualToString:@"error"])
            {
                message = json_string;
            }

        } 
        else if ([data length] == 0 && error1 == nil)
        { 
            message = @"Nothing was downloaded.";
        }
        else if (error1 != nil) 
        {
            message = [NSString stringWithFormat:@"Error happened = %@", error1.domain ];
        } 
        
        UIAlertView* alert = [[UIAlertView alloc] 
                              initWithTitle:@"Result" 
                              message:message
                              delegate:self  
                              cancelButtonTitle:@"Ok" 
                              otherButtonTitles:nil];
        [alert show];
        safeSelf.button.enabled = YES;
    };
    
    self.requestSender = [[RequestSender alloc] initWithURL:url 
                                             withHTTPMethod:@"POST" 
                                             withParameters:params 
                                                  withBlock:block];
    
}

- (IBAction)showProfilePressed:(id)sender {
    
    UserInfoViewController* infoView = [[UserInfoViewController alloc] initWithNibName:@"UserInfoViewController" bundle:nil];
    [self.navigationController pushViewController:infoView animated:YES];
}

- (IBAction)tapIn:(id)sender {
    [self.status resignFirstResponder];
}

- (IBAction)sentPhoto:(id)sender {
    
    UIImage *testImage = [UIImage imageNamed:@"pict.jpeg"];
    NSString* url = @"https://graph.facebook.com/me/photos";
  
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    self.status = nil;
    self.button = nil;
    self.requestSender = nil;
    
    [self setSentPhoto:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

@end
