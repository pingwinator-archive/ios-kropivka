//
//  Loginer.h
//  Twitter
//
//  Created by Michail Kropivka on 04.09.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class OAToken;

@protocol TweetViewControllerDelegate;

@protocol LoginerDelegate
- (void) getAccessTokenWithPin:(NSString*) pinCode;
@end

@interface Loginer : NSObject <LoginerDelegate>

@property (strong, nonatomic) NSString* consumerKey;
@property (strong, nonatomic) NSString* consumerSecret;
@property (strong, nonatomic) OAToken * accessToken;

@property (weak, nonatomic) id<TweetViewControllerDelegate> delegate;

- (void) startLogin;

@end
