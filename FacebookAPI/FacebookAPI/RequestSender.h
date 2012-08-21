//
//  RequestSender.h
//  FacebookAPI
//
//  Created by Michail Kropivka on 21.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^OnFinishLoading)(NSData*);

@interface RequestSender : NSObject <NSURLConnectionDataDelegate>


@property (strong, nonatomic) NSURLConnection* m_connection;
@property (strong, nonatomic) NSMutableData* m_resBuffer;
@property (strong, nonatomic) OnFinishLoading m_block;


-(id)initWithRequest:(NSURLRequest*)request andWithBlock:(OnFinishLoading)block;

@end
