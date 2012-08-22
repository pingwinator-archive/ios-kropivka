//
//  RequestSender.h
//  FacebookAPI
//
//  Created by Michail Kropivka on 21.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^OnFinishLoading)(NSData*,NSError*);
typedef void(^OnFinishLoading2)(NSURLResponse*, NSData*, NSError*);

#define kKey @"AAACEdEose0cBABFpsfGFR6slc4LmEMAMZAU6WfCO2bVlOIo47ZAb5fVJTc8vfg4LIh7iVG7xG1aEAgBNUEKDeFdwPHECepWUoGiyQc316ah4UCjszj"

@interface RequestSender : NSObject <NSURLConnectionDataDelegate>


@property (strong, nonatomic) NSURLConnection* myConnection;
@property (strong, nonatomic) NSMutableData* resBuffer;
@property (copy, nonatomic) OnFinishLoading myBlock;
@property (strong, nonatomic) NSError* error;


-(id)initWithRequest:(NSURLRequest*)request andWithBlock:(OnFinishLoading)block;

-(id)initWithURL:(NSURL *)url 
  withHTTPMethod:(NSString*)method 
  withParameters:(NSDictionary*)params 
       withBlock:(OnFinishLoading2)block;


@end
