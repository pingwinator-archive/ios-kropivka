//
//  Cities+Helper.m
//  UICities2
//
//  Created by Michail Kropivka on 03.09.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Cities+Helper.h"

@implementation Cities (Helper)

+ (id)entityWithContext:(NSManagedObjectContext *)context 
{
    return [NSEntityDescription insertNewObjectForEntityForName:@"Cities" inManagedObjectContext:context];
}

- (void)removeWithContext:(NSManagedObjectContext*)context {
    if (self) {
        [context deleteObject:self];
        [context save:nil];
    }
}

@end
