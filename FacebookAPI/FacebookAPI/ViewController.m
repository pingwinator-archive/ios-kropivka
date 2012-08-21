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


@implementation ViewController

@synthesize button;
@synthesize status;
@synthesize requestSender;

- (IBAction)buttonPressed:(id)sender 
{
    NSString* key = @"AAACEdEose0cBAFsFZBcCmDKqMCIau8Rfo2s6tNFAbAUT8bNKYtvZAF9vCSLzTonVw9k9ZBf62FRCC9AeW43j2ZBrTjn7BAZC5Q0pOUqj88VaL4l7YhxRC";
    
    NSURL* url = [[NSURL alloc] initWithString:@"https://graph.facebook.com/me/feed"];
    
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

    
    NSString *post = [[NSString alloc] initWithFormat:@"message=%@&access_token=%@",status.text,key];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    
    OnFinishLoading block = ^(NSData* data)
    {
        // Create new SBJSON parser object
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        
        NSString *json_string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        // parse the JSON response into an object
        // Here we're using NSArray since we're parsing an array of JSON status objects
        //NSArray *result = 
        
        NSDictionary *answerID = [parser objectWithString:json_string error:nil];
        
        UIAlertView* alert = [[UIAlertView alloc] 
                              initWithTitle:@"Title" 
                              message:[answerID objectForKey:@"id"] 
                              delegate:self  
                              cancelButtonTitle:@"Ok" 
                              otherButtonTitles:nil];
        [alert show];
    };
    
    self.requestSender = [[RequestSender alloc] initWithRequest:request andWithBlock:block];
    
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
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

@end
