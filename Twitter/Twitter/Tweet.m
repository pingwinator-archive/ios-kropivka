//
//  Tweet.m
//  Twitter
//
//  Created by Michail Kropivka on 05.09.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

@synthesize user;
@synthesize text;
@synthesize imgUrl;
@synthesize img;

- (CGFloat)tweetLabelHeight {
    return [self.text sizeWithFont:kTweetFont 
                 constrainedToSize:CGSizeMake(320-50, CGFLOAT_MAX) 
                     lineBreakMode:UILineBreakModeWordWrap].height;
}

- (CGFloat) fullHeight {
    CGFloat tweetHeight = [self tweetLabelHeight];
    tweetHeight += 20;
    return (tweetHeight < 50 ? 50 : tweetHeight) + 10;
}

@end
