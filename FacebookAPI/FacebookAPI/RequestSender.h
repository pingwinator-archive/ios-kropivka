//
//  RequestSender.h
//  FacebookAPI
//
//  Created by Michail Kropivka on 21.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^OnFinishLoading)(NSData*,NSError*);

#define kKey @"AAACEdEose0cBAG3Wu3xlM43WzXeRICTU9CcOEwbpFAkGPV7V7P9xcq60DCMn8eglnDA8D4CGg4r4ypY7ybRUYs0pcspJ6Jii69faaodUEI180YB6"

@interface RequestSender : NSObject


- (id) initWithRequest:(NSURLRequest*)request andWithBlock:(OnFinishLoading)block;

- (id) initWithURL:(NSString *)url andWithBlock:(OnFinishLoading)blockIn;

- (id) initWithURL:(NSString *)url 
  withHTTPMethod:(NSString*)method 
  withParameters:(NSDictionary*)params 
       withBlock:(OnFinishLoading)block;


@end
