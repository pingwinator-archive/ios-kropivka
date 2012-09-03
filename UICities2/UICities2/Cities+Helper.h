//
//  Cities+Helper.h
//  UICities2
//
//  Created by Michail Kropivka on 03.09.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Cities.h"

@interface Cities (Helper)

+ (id)entityWithContext:(NSManagedObjectContext *)context;
- (void)removeWithContext:(NSManagedObjectContext *)context;

@end
