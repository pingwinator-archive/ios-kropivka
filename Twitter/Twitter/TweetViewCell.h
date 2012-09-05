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

@property (strong, nonatomic) Tweet* tweet;
@property (strong, nonatomic) UIImageView* avatarView;

@end
