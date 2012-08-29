//
//  MyEntity.h
//  Kino
//
//  Created by Michail Kropivka on 28.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MyEntity : NSManagedObject

@property (nonatomic, retain) NSNumber * number;
@property (nonatomic, retain) NSDate * date;

@end
