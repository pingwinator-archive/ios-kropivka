//
//  Macrosses.h
//  Twitter
//
//  Created by Michail Kropivka on 07.09.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#define OXM_CONSOLE_DEBUG 0

#if defined(DEBUG)
#	define OXM_DLog(desc, ...) if (OXM_CONSOLE_DEBUG) { NSLog((@"%s [Line %d] " desc), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__); }
#else
#   define OXM_DLog(...)
#endif