//
//  Worker.m
//  Blocks
//
//  Created by Michail Kropivka on 21.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Worker.h"

@implementation Worker

+ (void) repeatFromOneTo:(int)count withBlock:(ComputationBlock)block
{
    for (int i = 1; i < count + 1; ++i) {
        
        NSLog(@"i=%d, res=%d", i, block(i) );
    }
}

@end
