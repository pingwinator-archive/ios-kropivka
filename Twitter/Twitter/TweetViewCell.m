//
//  TweetViewCell.m
//  Twitter
//
//  Created by Michail Kropivka on 05.09.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TweetViewCell.h"

@implementation TweetViewCell

@synthesize tweet;
@synthesize name;
@synthesize avatar;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.name = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 320-50, 20)];
        [self.contentView addSubview:self.name];
        self.name.font = [self.name.font fontWithSize:14];
        self.name.textColor = [UIColor colorWithRed:0.3 green:0.3 blue:1 alpha:1];
        
        self.tweet = [[UITextView alloc] initWithFrame:CGRectMake(50, 20, 320-50, 100-20)];
        [self.contentView addSubview:self.tweet];
        self.tweet.font = [self.tweet.font fontWithSize:12];
        self.tweet.editable = NO;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

@end
