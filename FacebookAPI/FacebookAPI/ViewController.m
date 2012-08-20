//
//  ViewController.m
//  FacebookAPI
//
//  Created by Michail Kropivka on 20.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "SBJson.h"


@interface ViewController () {
    NSURLConnection* m_connection;
    NSMutableData* m_resBuffer;
}

@end

@implementation ViewController

@synthesize button;
@synthesize status;

- (IBAction)buttonPressed:(id)sender 
{
    NSString* key = @"AAACEdEose0cBANuEZCsL9oSkA3PmNFzB4W2AmY4zKCFwRU1ZBlURGnzYb1FBGrkzSDAyMhtTFd4vZBpEM3yxkEZCzT93I4e6plbAXfZBMPhOYwR4YPltr";
    
    NSURL* url = [[NSURL alloc] initWithString:@"https://graph.facebook.com/me/feed"];
    
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

    
    NSString *post = [[NSString alloc] initWithFormat:@"message=%@&access_token=%@",status.text,key];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    m_connection = [NSURLConnection connectionWithRequest:request delegate:self];
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // cast the response to NSHTTPURLResponse so we can look for 404 etc
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    
    if ([httpResponse statusCode] >= 400) {
        // do error handling here
        NSLog(@"remote url returned error %d %@",[httpResponse statusCode],[NSHTTPURLResponse localizedStringForStatusCode:[httpResponse statusCode]]);
    } else {
        // start recieving data
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if( connection == m_connection )
    {
        [m_resBuffer appendData:data];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // Create new SBJSON parser object
    SBJsonParser *parser = [[SBJsonParser alloc] init];

    NSString *json_string = [[NSString alloc] initWithData:m_resBuffer encoding:NSUTF8StringEncoding];
    
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
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle: [error localizedDescription]
                               message: [error localizedFailureReason]
                               delegate:nil
                               cancelButtonTitle:@"OK"
                               otherButtonTitles:nil];
	[errorAlert show];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    m_resBuffer = [[NSMutableData alloc] init];
}

- (void)viewDidUnload
{
    self.status = nil;
    self.button = nil;
    m_resBuffer = nil;
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

@end
