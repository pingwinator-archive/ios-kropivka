//
//  RequestSender.m
//  FacebookAPI
//
//  Created by Michail Kropivka on 21.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RequestSender.h"

@interface RequestSender () <NSURLConnectionDataDelegate>

@property (strong, nonatomic) NSURLConnection* myConnection;
@property (strong, nonatomic) NSMutableData* resBuffer;
@property (copy, nonatomic) OnFinishLoading myBlock;
@property (strong, nonatomic) NSError* error;

@end

@implementation RequestSender

@synthesize myConnection;
@synthesize resBuffer;
@synthesize myBlock;
@synthesize error;

- (void) dealloc {
    self.myConnection = nil;
    self.myBlock = nil;
    self.error = nil;
    self.resBuffer = nil;
}

- (id) initWithRequest:(NSURLRequest*)request andWithBlock:(OnFinishLoading)block
{
    self = [self init];
    
    self.myConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    self.resBuffer = [NSMutableData data];
    self.myBlock = block;
    self.error = nil;
    
    return self;
}

- (id) initWithURL:(NSString *)url andWithBlock:(OnFinishLoading)blockIn
{
    self = [super init];
    
    return [self initWithURL:url withHTTPMethod:@"GET" withParameters:nil withBlock:(OnFinishLoading)blockIn];
}

- (id) initWithURL:(NSString *)url 
  withHTTPMethod:(NSString*)method 
  withParameters:(NSDictionary*)params 
       withBlock:(OnFinishLoading)blockIn
{
    self = [super init];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]]; 
    [urlRequest setHTTPMethod:method];
    
    if( [method isEqualToString:@"POST"] ) 
    {
        if( params ){
            NSData *postData = [[params asPOSTRequest] dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
            NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
            [urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
            [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            [urlRequest setHTTPBody:postData];
        }
    }
    else
    {
        //TODO params
    }

    self.myConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    self.resBuffer = [NSMutableData data];
    self.myBlock = blockIn;
    self.error = nil;    
    return self;
}

#pragma mark - NSURLConnectionDataDelegate

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    if(self.myConnection != connection)
        return;
    
    NSInteger code = [(NSHTTPURLResponse*)response statusCode];
    if ( code > 400 ) 
    {
        self.error = [[NSError alloc] initWithDomain:[NSString stringWithFormat:@"error code %d",code] code:123 userInfo:nil];
    }
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if(self.myConnection != connection)
        return;
    
    [self.resBuffer appendData:data];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    if(self.myConnection != connection)
        return;
    
    if( self.myBlock ) {
        self.myBlock( self.resBuffer, self.error );
    }
        
}

@end
