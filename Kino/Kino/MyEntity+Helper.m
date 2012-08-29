//
// Created by snowman647 on 29.08.12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "MyEntity+Helper.h"


@implementation MyEntity (Helper)

+ (id)entityWithContext:(NSManagedObjectContext *)context 
{
    return [NSEntityDescription insertNewObjectForEntityForName:@"MyEntity" inManagedObjectContext:context];
}

@end