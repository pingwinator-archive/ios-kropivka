//
//  RequestSender.m
//  FacebookAPI
//
//  Created by Michail Kropivka on 21.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RequestSender.h"

@implementation RequestSender

@synthesize m_connection;
@synthesize m_resBuffer;
@synthesize m_block;

-(id)initWithRequest:(NSURLRequest*)request andWithBlock:(OnFinishLoading)block
{
    self = [super init];
    self.m_connection = [NSURLConnection connectionWithRequest:request delegate:self];
    self.m_resBuffer = [NSMutableData data];
    self.m_block = block;
    return self;
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
    self.m_block(m_resBuffer);
    m_resBuffer = nil;

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


@end
