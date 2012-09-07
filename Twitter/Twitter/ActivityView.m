//
//  ActivityView.m
//  Twitter
//
//  Created by Michail Kropivka on 05.09.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ActivityView.h"

@interface ActivityView ()

- (void)setupActivityIndicator;
- (void)setupMessage;

@end


@implementation ActivityView

@synthesize activityIndicator;
@synthesize message;

- (void)setupActivityIndicator {
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicator.center = CGPointMake(80, 40);
    [self addSubview:self.activityIndicator];
}

- (void)setupMessage {
    self.message = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 140, 20)];
    self.message.text = @"";
    self.message.textColor = [UIColor whiteColor];
    self.message.backgroundColor = [UIColor blackColor];
    [self addSubview:self.message];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupActivityIndicator];
        [self setupMessage];
        
        self.hidden = YES;
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void) startActivityWithMessage:(NSString*)text {
    [self.superview bringSubviewToFront:self];
    [self.activityIndicator startAnimating];
    self.message.text = text;
    self.hidden = NO;
}

- (void) stopActivity {
    [self.activityIndicator stopAnimating];
    self.hidden = YES;
}

@end
