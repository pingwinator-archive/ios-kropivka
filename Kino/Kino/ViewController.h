//
//  ViewController.h
//  Kino
//
//  Created by Michail Kropivka on 28.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UITableViewController <UITableViewDataSource,NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) UIButton* button;
@property (strong, nonatomic) UIButton* buttonJump;

@property (strong, nonatomic) UITapGestureRecognizer* tap;
@property (strong, nonatomic) NSFetchedResultsController* fetchedResultsController;

@end
