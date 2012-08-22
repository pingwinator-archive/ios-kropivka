//
//  UserInfoViewController.h
//  FacebookAPI
//
//  Created by Michail Kropivka on 22.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RequestSender;

@interface UserInfoViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *avatar;
@property (strong, nonatomic) IBOutlet UILabel *nameLable;
@property (strong, nonatomic) IBOutlet UILabel *linkLable;

@property (strong, nonatomic) RequestSender* requestSender;
@property (strong, nonatomic) RequestSender* requestSender2;

- (void) loadImage;
@end
