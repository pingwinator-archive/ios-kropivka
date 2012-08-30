//
//  mainViewController.h
//  PictsBoard
//
//  Created by Michail Kropivka on 30.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface mainViewController : UIViewController


@property (retain, nonatomic) NSMutableArray *images;


@property (retain, nonatomic) IBOutlet UIView *topBar;
@property (retain, nonatomic) IBOutlet UIView *imagesView;
@property (retain, nonatomic) IBOutlet UIButton *addButton;
@property (retain, nonatomic) IBOutlet UISlider *slider;
- (IBAction)sliderChanged:(id)sender;
- (IBAction)addImage:(id)sender;


@end
