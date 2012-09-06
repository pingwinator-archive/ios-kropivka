//
//  TweetViewController.h
//  Twitter
//
//  Created by Michail Kropivka on 04.09.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pull2RefreshViewController.h"

@protocol TweetViewControllerDelegate

- (void) showLoginWindow:(NSString*)address;
- (void) userLoggedIn:(BOOL)success;

@end

@protocol TweetsLoaderDelegate

- (void) tweetsLoaded;

@end


@interface TweetViewController : Pull2RefreshViewController <TweetViewControllerDelegate,TweetsLoaderDelegate>
@end
