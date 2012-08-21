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
    NSString* key = @"AAACEdEose0cBACzGQihu4Razkv6avnVZASfBkMiNiQQgE5pyzI2JLDbNvYjOKVYSncvsUwYZAlMgOpeAh7BHeXZCMHcxEZCnVkyyWDauDEv3vMYuYbVa";
    
    NSURL* url = [[NSURL alloc] initWithString:@"https://graph.facebook.com/me/feed"];
    
    //NSDIct
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSString *post = [[NSString alloc] initWithFormat:@"message=%@&access_token=%@", status.text ,key];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    
    OnFinishLoading block = ^(NSData* data, NSError* error)
    {
        
        //if (error)
        //    return;
        
        // Create new SBJSON parser object
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        
        NSString *json_string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",json_string);

        // parse the JSON response into an object      
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
