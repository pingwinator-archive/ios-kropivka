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

@interface ViewController ()

- (OnFinishLoading)getOnFinishBlock;

@end

@implementation ViewController
@synthesize sendPhoto;

@synthesize button;
@synthesize status;
@synthesize requestSender;

- (IBAction)buttonPressed:(id)sender 
{
    [self.status resignFirstResponder];
    self.button.enabled = NO;
    
    
    // Post status
    
    NSString* url = @"https://graph.facebook.com/me/feed";
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [params setObject:status.text   forKey:@"message"];
    [params setObject:kKey          forKey:@"access_token"];
    
    self.requestSender = [[RequestSender alloc] initWithURL:url 
                                             withHTTPMethod:@"POST" 
                                             withParameters:params 
                                                  withBlock:[self getOnFinishBlock]];
    self.button.enabled = YES;
}

- (IBAction)showProfilePressed:(id)sender {
    
    UserInfoViewController* infoView = [[UserInfoViewController alloc] initWithNibName:@"UserInfoViewController" bundle:nil];
    [self.navigationController pushViewController:infoView animated:YES];
}

- (IBAction)tapIn:(id)sender {
    [self.status resignFirstResponder];
}

- (NSMutableURLRequest *)makeRequesrWithPicture:(NSData *)imageData url:(NSString *)url {
    
    //----------
    // create request
    
    NSMutableDictionary* _params = [NSMutableDictionary dictionary];
    
    [_params setObject:kKey forKey:@"access_token"];
    //[_params setObject:@"NONONONO" forKey:@"message"];
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];                                    
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"POST"];
    
    // set Content-Type in HTTP header
    NSString* boundary = @"-------A9961491299512312312";
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    // add params (all params are strings)
    for (NSString *param in _params) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [_params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    // add image data
    if (imageData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"myname\"; filename=\"image.jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:@"Content-Type: image/jpeg\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%d", [body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setURL:[[NSURL alloc]  initWithString:url]];
    
    return request;
}

- (OnFinishLoading)getOnFinishBlock {
    return ^(NSData *data, NSError *error1) {
        
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
    };
}

- (IBAction)sendPhoto:(id)sender {
    
    UIImage *testImage = [UIImage imageNamed:@"chrysler.jpeg"];
    NSData *imageData = UIImagePNGRepresentation(testImage);
    self.sendPhoto.enabled = NO;

    NSString* url = @"https://graph.facebook.com/me/photos";

    NSMutableURLRequest *request;
    request = [self makeRequesrWithPicture:imageData url:url];
    
    self.requestSender = [[RequestSender alloc] initWithRequest:request andWithBlock:[self getOnFinishBlock]];
    self.sendPhoto.enabled = YES;
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
    
    [self setSendPhoto:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

@end
