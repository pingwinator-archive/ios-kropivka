//
//  NSDictionary+RequestAssitant.m
//  FacebookAPI
//
//  Created by Michail Kropivka on 21.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSDictionary+RequestAssitant.h"

@implementation NSDictionary (RequestAssitant)

- (NSString*) asPOSTRequest {
    
    __block NSString* paramsStr = @"";
    __block int idx = 0;
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString * sign = idx ? @"&" : @"";
        NSString * s = [[NSString alloc] initWithFormat:@"%@%@=%@", sign, key ,obj];
        paramsStr = [paramsStr stringByAppendingString:s];
        ++idx;
    }];
    
    return paramsStr;
}

- (NSString*) asGETRequest {
    
    return [@"?" stringByAppendingString:[self asPOSTRequest]];;
}

@end
