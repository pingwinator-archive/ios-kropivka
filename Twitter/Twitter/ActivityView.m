//
//  ActivityView.m
//  Twitter
//
//  Created by Michail Kropivka on 05.09.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ActivityView.h"
#import "UIView+Additions.h"

@interface ActivityView ()

@property (strong, nonatomic) UIActivityIndicatorView* activityIndicator;
@property (strong, nonatomic) UILabel* message;

- (void)setupActivityIndicator;
- (void)setupMessage;

@end

@implementation ActivityView

@synthesize activityIndicator;
@synthesize message;

- (void) dealloc {
    self.activityIndicator = nil;
    self.message = nil;
}
- (void)setupActivityIndicator {
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicator.center = CGPointMake(80, 40);
    [self addSubview:self.activityIndicator];
}

- (void)setupMessage {
    self.message = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 120, 20)];
    self.message.text = @"";
    self.message.textColor = [UIColor whiteColor];
    self.message.backgroundColor = [UIColor blackColor];
    self.message.textAlignment = UITextAlignmentCenter;
    [self addSubview:self.message];
}

- (id) init {
    self = [super init];
    if (self) {
        
        [self setupActivityIndicator];
        [self setupMessage];
        
        self.frame = CGRectMake(0, 0, 160, 160);
        [self roundCorners];
        
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void) startActivityWithMessage:(NSString*)text onView:(UIView*)view {
    self.center = view.center;
    [view addSubview:self];
    [self.activityIndicator startAnimating];
    self.message.text = text;
}

- (void) stopActivity {
    [self.activityIndicator stopAnimating];
    [self removeFromSuperview];
}

@end
