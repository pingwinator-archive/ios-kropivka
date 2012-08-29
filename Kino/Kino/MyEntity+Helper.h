//
// Created by snowman647 on 29.08.12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "MyEntity.h"

@interface MyEntity (Helper)
+ (id)entityWithContext:(NSManagedObjectContext *)context;
@end