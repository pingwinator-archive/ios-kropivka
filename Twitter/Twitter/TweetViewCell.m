//
//  TweetViewCell.m
//  Twitter
//
//  Created by Michail Kropivka on 05.09.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TweetViewCell.h"
#import "Tweet.h"

@interface TweetViewCell ()
@property (strong, nonatomic) UILabel* nameLabel;
@property (strong, nonatomic) UILabel* tweetLabel;
@end

@implementation TweetViewCell

@synthesize tweetLabel;
@synthesize nameLabel;
@synthesize avatarView;
@synthesize tweet;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        [self.contentView addSubview:self.avatarView];

        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 320-50, 20)];
        [self.contentView addSubview:self.nameLabel];
        self.nameLabel.font = [self.nameLabel.font fontWithSize:14];
        self.nameLabel.textColor = [UIColor colorWithRed:0.3 green:0.3 blue:1 alpha:1];
        
        self.tweetLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 20, 320-50, 100-20)];
        self.tweetLabel.numberOfLines = 10;
        self.tweetLabel.lineBreakMode = UILineBreakModeWordWrap;
        [self.contentView addSubview:self.tweetLabel];
        
        self.tweetLabel.font = kTweetFont;
    }
    return self;
}

- (void) setTweet:(Tweet*)tw{
    tweet = tw;
    self.tweetLabel.text = tw.text;
    self.nameLabel.text = tw.user;
    self.avatarView.image = tw.img;
    
    [self layoutSubviews];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.tweetLabel.frame = CGRectMake(50, 20, 320-50, self.tweet.tweetLabelHeight);
}
@end
