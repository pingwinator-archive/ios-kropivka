//
//  Loginer.h
//  Twitter
//
//  Created by Michail Kropivka on 04.09.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Loginer : NSObject

@property (strong, nonatomic) NSString* consumerKey;
@property (strong, nonatomic) NSString* consumerSecret;
@property (strong, nonatomic) NSString* pinCode;

@property (strong, nonatomic) NSString* address;
@property (strong, nonatomic) id delegate;

- (void) getRequestToken;
- (void) getAccessToken;
- (void) getHomeTimeline;

@end
