//
//  RequestSender.h
//  FacebookAPI
//
//  Created by Michail Kropivka on 21.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^OnFinishLoading)(NSData*,NSError*);

#define kKey @"AAACEdEose0cBAOyPROgB7J7DEHwbBzijrekaWKIlb8qnPPZCnuHeqv6iCKZBeZAEZBhhupeOXeW8ErtgP0bd3d1udV10EvGFGGVvU7Yd8HkLdQXmWTvw"

@interface RequestSender : NSObject <NSURLConnectionDataDelegate>


@property (strong, nonatomic) NSURLConnection* myConnection;
@property (strong, nonatomic) NSMutableData* resBuffer;
@property (copy, nonatomic) OnFinishLoading myBlock;
@property (strong, nonatomic) NSError* error;


//-(id)initWithRequest:(NSURLRequest*)request andWithBlock:(OnFinishLoading)block;

-(id)initWithURL:(NSString *)url andWithBlock:(OnFinishLoading)blockIn;

-(id)initWithURL:(NSString *)url 
  withHTTPMethod:(NSString*)method 
  withParameters:(NSDictionary*)params 
       withBlock:(OnFinishLoading)block;


@end
