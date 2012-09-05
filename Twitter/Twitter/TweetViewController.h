//
//  TweetViewController.h
//  Twitter
//
//  Created by Michail Kropivka on 04.09.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TweetViewControllerDelegate

- (void) showLoginWindow:(NSString*)address;
- (void) userLoggedIn;

@end

@protocol TweetsLoaderDelegate

- (void) tweetsLoaded;

@end

@interface TweetViewController : UITableViewController <TweetViewControllerDelegate,TweetsLoaderDelegate>
@end
