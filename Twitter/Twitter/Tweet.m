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
@synthesize id;

- (void) dealloc {
    self.user = nil;
    self.text = nil;
    self.imgUrl = nil;
    self.id = nil;
}

- (CGFloat)tweetLabelHeight {
    return [self.text sizeWithFont:kTweetFont 
                 constrainedToSize:CGSizeMake(320-(kAvataraSize.width + 2*kOffset), CGFLOAT_MAX) 
                     lineBreakMode:UILineBreakModeWordWrap].height;
}

- (CGFloat) fullHeight {
    CGFloat tweetHeight = [self tweetLabelHeight] + kNameLableSize.height + 2*kOffset;
    CGFloat minimumCellHeight = kAvataraSize.height + 2*kOffset;
    return tweetHeight < minimumCellHeight ? minimumCellHeight : tweetHeight;
}

@end
