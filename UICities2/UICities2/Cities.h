//
//  Cities.h
//  UICities2
//
//  Created by Michail Kropivka on 03.09.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Cities : NSManagedObject

@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * json;

@end
