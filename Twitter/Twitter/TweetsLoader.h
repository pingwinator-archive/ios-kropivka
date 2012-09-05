//
//  TweetsLoader.h
//  Twitter
//
//  Created by Michail Kropivka on 05.09.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Loginer;
@protocol TweetsLoaderDelegate;


@interface TweetsLoader : NSObject

@property (strong, nonatomic) NSMutableArray* tweets;
@property (weak, nonatomic) id <TweetsLoaderDelegate> delegate;

- (id) initWithLoginer:(Loginer*)log;
- (void) loadTweets;

@end
