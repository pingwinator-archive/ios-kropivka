//
//  TweetViewCell.m
//  Twitter
//
//  Created by Michail Kropivka on 05.09.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TweetViewCell.h"
#import "Tweet.h"
#import "UIView+Additions.h"

@interface TweetViewCell ()
@property (strong, nonatomic) UILabel* nameLabel;
@property (strong, nonatomic) UILabel* tweetLabel;

@property (strong, nonatomic) Tweet* tweet;
@property (strong, nonatomic) UIImageView* avatarView;

- (void) setupAvatarView;
- (void) setupNameLabel;
- (void) setupTweetLabel;

@end

@implementation TweetViewCell

@synthesize tweetLabel;
@synthesize nameLabel;
@synthesize avatarView;
@synthesize tweet;

-(void) dealloc {
    self.tweetLabel = nil;
    self.nameLabel = nil;
    self.avatarView = nil;
    self.tweet = nil;
}

- (void) setupAvatarView {
    
    self.avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(kOffset, 
                                                                    kOffset, 
                                                                    kAvataraSize.width, 
                                                                    kAvataraSize.height)];
    [self.contentView addSubview:self.avatarView];
}

- (void) setupNameLabel {
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(kAvataraSize.width+2*kOffset, 
                                                               0, 
                                                               kNameLableSize.width, 
                                                               kNameLableSize.height)];
    [self.contentView addSubview:self.nameLabel];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:13];
    self.nameLabel.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.4 alpha:1];
}

- (void) setupTweetLabel {
    self.tweetLabel = [[UILabel alloc] initWithFrame:CGRectMake(kAvataraSize.width+kOffset, 
                                                                kNameLableSize.height+kOffset, 
                                                                self.frame.size.width-(kAvataraSize.width+kOffset), 
                                                                100-20)]; // will be setted later
    self.tweetLabel.numberOfLines = 10;
    self.tweetLabel.lineBreakMode = UILineBreakModeWordWrap;
    [self.contentView addSubview:self.tweetLabel];
    self.tweetLabel.font = kTweetFont;
}

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setupAvatarView];
        [self setupNameLabel];
        [self setupTweetLabel];
        
    }
    return self;
}

- (void) setTweet:(Tweet*)tw withImageCache:(NSMutableDictionary*)imageCache {
    self.tweet = tw;
    self.tweetLabel.text = tw.text;
    self.nameLabel.text = tw.user;
    
    __block UIImage* img = [imageCache objectForKey:tw.imgUrl];
    if( img ) {
        self.avatarView.image = img;
    } else {
        
        dispatch_async(kBackgroundQueue, ^{
            NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:tw.imgUrl]];
            img = [[UIImage alloc] initWithData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.avatarView.image = img;
            });
            [imageCache setObject:img forKey:tw.imgUrl];
        });
    }
    
    [self.avatarView roundCorners];
    [self layoutSubviews];
}

- (void) setRow:(NSInteger)rowIndex { 
    
    UIColor* color = [UIColor whiteColor];

    if( rowIndex % 2 ) {
        color = [UIColor lightGrayColor];
    }
    
    self.contentView.backgroundColor = color;
    self.nameLabel.backgroundColor = color;
    self.tweetLabel.backgroundColor = color;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    self.tweetLabel.frame = CGRectMake(kAvataraSize.width + 2*kOffset,
                                       kNameLableSize.height + kOffset, 
                                       self.frame.size.width-(kAvataraSize.width + 3*kOffset), 
                                       self.tweet.tweetLabelHeight);
}

@end
