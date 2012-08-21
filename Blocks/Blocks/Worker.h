//
//  Worker.h
//  Blocks
//
//  Created by Michail Kropivka on 21.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef int(^ComputationBlock)(int);

@interface Worker : NSObject

+ (void) repeatFromOneTo:(int)count withBlock:(ComputationBlock)block;

@end
