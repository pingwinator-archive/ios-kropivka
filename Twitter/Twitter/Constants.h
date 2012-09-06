//
//  Constants.h
//  Twitter
//
//  Created by Michail Kropivka on 05.09.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#define kBackgroundQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)
#define kTweetFont [UIFont systemFontOfSize:14]
#define kUseLoginCache YES

#define kAvataraSize CGSizeMake(48,48)
#define kOffset 4
#define kNameLableSize CGSizeMake(320-(kAvataraSize.width+kOffset),20)
