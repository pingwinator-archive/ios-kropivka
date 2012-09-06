//
//  Loginer.h
//  Twitter
//
//  Created by Michail Kropivka on 04.09.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class OAToken;
@class OAConsumer;

@protocol TweetViewControllerDelegate;

@protocol LoginerDelegate
- (void) getAccessTokenWithPin:(NSString*) pinCode;
- (void) webViewFinished;
@end

@interface Loginer : NSObject <LoginerDelegate>

@property (weak, nonatomic) id<TweetViewControllerDelegate> delegate;
@property (strong, nonatomic) OAToken * accessToken;

- (OAConsumer *)consumer;
- (void) startLogin;

@end
