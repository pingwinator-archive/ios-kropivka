//
//  ViewController.h
//  TwitterAPI-2
//
//  Created by Michail Kropivka on 20.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SA_OAuthTwitterController.h"

@class SA_OAuthTwitterEngine;

@interface ViewController : UIViewController <UITextFieldDelegate, SA_OAuthTwitterControllerDelegate>
{ 
    

    SA_OAuthTwitterEngine *_engine;
	
}

@property(nonatomic, retain) IBOutlet UITextField *tweetTextField;

-(IBAction)updateTwitter:(id)sender; 

@end
