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


-(id)initWithURL:(NSURL *)url 
  withHTTPMethod:(NSString*)method 
  withParameters:(NSDictionary*)params 
       withBlock:(OnFinishLoading2)blockIn
{
    self = [super init];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url]; 
    [urlRequest setHTTPMethod:method];
    
    NSData *postData = [[params asPOSTRequest] 
                        dataUsingEncoding:NSASCIIStringEncoding 
                        allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    [urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPBody:postData];

    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest 
                                       queue:queue 
                           completionHandler:blockIn];
    return self;
}


@end
