//
//  RequestSender.h
//  FacebookAPI
//
//  Created by Michail Kropivka on 21.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^OnFinishLoading)(NSData*,NSError*);

@interface RequestSender : NSObject <NSURLConnectionDataDelegate>


@property (strong, nonatomic) NSURLConnection* connection;
@property (strong, nonatomic) NSMutableData* resBuffer;
@property (copy, nonatomic) OnFinishLoading block;
@property (strong, nonatomic) NSError* error;


-(id)initWithRequest:(NSURLRequest*)request andWithBlock:(OnFinishLoading)block;
-(id)initWithURL:(NSURL *)url 
  withHTTPMethod:(NSString*)method 
  withParameters:(NSDictionary*)params 
       withBlock:(OnFinishLoading)block;


@end
