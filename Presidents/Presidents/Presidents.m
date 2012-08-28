//
//  Presidents.m
//  Presidents
//
//  Created by Michail Kropivka on 28.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Presidents.h"

@implementation BIDPresident

@synthesize number; 
@synthesize name; 
@synthesize fromYear; 
@synthesize toYear; 
@synthesize party;

#pragma mark - #pragma mark NSCoding 
- (void)encodeWithCoder:(NSCoder *)coder {
    
    [coder encodeInt:self.number forKey:kPresidentNumberKey]; 
    [coder encodeObject:self.name forKey:kPresidentNameKey]; 
    [coder encodeObject:self.fromYear forKey:kPresidentFromKey]; 
    [coder encodeObject:self.toYear forKey:kPresidentToKey]; 
    [coder encodeObject:self.party forKey:kPresidentPartyKey];
}

- (id)initWithCoder:(NSCoder *)coder { 
    
    if (self = [super init]) {
        self.number = [coder decodeIntForKey:kPresidentNumberKey]; 
        self.name = [coder decodeObjectForKey:kPresidentNameKey]; 
        self.fromYear = [coder decodeObjectForKey:kPresidentFromKey]; 
        self.toYear = [coder decodeObjectForKey:kPresidentToKey]; 
        self.party = [coder decodeObjectForKey:kPresidentPartyKey];
    } return self;
}
@end
