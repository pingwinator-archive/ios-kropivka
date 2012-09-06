//
//  TweetViewCell.h
//  Twitter
//
//  Created by Michail Kropivka on 05.09.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Tweet;

@interface TweetViewCell : UITableViewCell

- (void) setTweet:(Tweet*)tw withImageCache:(NSMutableDictionary*)imageCache;
- (void) setRow:(NSInteger)rowIndex;

@end
