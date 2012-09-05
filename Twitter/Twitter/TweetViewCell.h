//
//  TweetViewCell.h
//  Twitter
//
//  Created by Michail Kropivka on 05.09.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TweetViewCell : UITableViewCell

@property (strong, nonatomic) UILabel* name;
@property (strong, nonatomic) UITextView* tweet;
@property (strong, nonatomic) UIImage* avatar;

@end
