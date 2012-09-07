//
//  UIView+Additions.m
//  Twitter
//
//  Created by Michail Kropivka on 07.09.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIView+Additions.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (Additions)

- (void)roundCorners {
    
    self.layer.cornerRadius = 5.0;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth = 1.0;
}

@end
