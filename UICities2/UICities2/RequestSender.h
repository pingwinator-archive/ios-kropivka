//
//  RequestSender.h
//  FacebookAPI
//
//  Created by Michail Kropivka on 21.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^OnFinishLoading)(NSData*,NSError*);

#define kKey @"AAACEdEose0cBAHmx8KIJVDdGqRpAYykWeMYziX2sHQ1tCcTHRuJD2ZAXxdQNDZC7ZA6ZAZCCfg1CZBL6NxNSTZAqWN7FB5gZAvqXemvcprpY6vidv8CZCMMX1"

@interface RequestSender : NSObject


- (id) initWithRequest:(NSURLRequest*)request andWithBlock:(OnFinishLoading)block;

- (id) initWithURL:(NSString *)url andWithBlock:(OnFinishLoading)blockIn;

- (id) initWithURL:(NSString *)url 
  withHTTPMethod:(NSString*)method 
  withParameters:(NSDictionary*)params 
       withBlock:(OnFinishLoading)block;


@end
