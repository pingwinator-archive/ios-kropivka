//
//  RequestSender.m
//  FacebookAPI
//
//  Created by Michail Kropivka on 21.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RequestSender.h"

@implementation RequestSender

@synthesize connection;
@synthesize resBuffer;
@synthesize block;
@synthesize error;

-(void)dealloc{
    self.connection = nil;
    self.block = nil;
    self.error = nil;
    self.resBuffer = nil;
}

-(id)initWithRequest:(NSURLRequest*)request andWithBlock:(OnFinishLoading)blockIn
{
    self = [super init];
    self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
    self.resBuffer = [NSMutableData data];
    self.block = blockIn;
    self.error = nil;
    return self;
}

-(id)initWithURL:(NSURL *)url 
  withHTTPMethod:(NSString*)method 
  withParameters:(NSDictionary*)params 
       withBlock:(OnFinishLoading)block
{
    self = [super init];
    return self;
}


#pragma mark - NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // cast the response to NSHTTPURLResponse so we can look for 404 etc
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    
    if ([httpResponse statusCode] >= 400) {
        // do error handling here
        NSLog(@"remote url returned error %d %@",[httpResponse statusCode],[NSHTTPURLResponse localizedStringForStatusCode:[httpResponse statusCode]]);
        self.error = [NSError errorWithDomain:@"ups" code:123 userInfo:nil];
    } else {
        // start recieving data
    }
}

- (void)connection:(NSURLConnection *)connection1 didReceiveData:(NSData *)data
{
    if( connection1 == connection )
    {
        [resBuffer appendData:data];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    self.block(self.resBuffer, self.error);
    self.resBuffer = nil;
    self.error = nil;
}

#pragma mark - NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)errorIn {
    self.error = errorIn;
}



@end
