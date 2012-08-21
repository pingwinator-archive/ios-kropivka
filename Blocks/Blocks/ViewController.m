//
//  ViewController.m
//  Blocks
//
//  Created by Michail Kropivka on 21.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "Worker.h"

@implementation ViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    __block NSDate *date = [NSDate date];
    NSLog(@"The date and time is %@", date);    
    sleep(2);
    date = [NSDate date];
    void (^now)(void) = ^{
        NSLog(@"The date and time is %@", date);
    };
    
    now();
    
    int (^triple)(int) = ^(int x){
        return x*3;
    };
    
    int y = triple(4);
    NSLog(@"%d",y);
    
    int (^multiply)(int,int) = ^(int x, int y) {
        return x*y;
    };
    
    NSLog(@"%d",multiply(5,6));
    
    ComputationBlock myBlock = ^(int x) {
        return x*x;
    };
    
    [Worker repeatFromOneTo:5 withBlock:myBlock];
    
    // Array
    
    void (^enumBlock)(id, NSUInteger, BOOL*) =  ^(id obj, NSUInteger idx, BOOL *stop) {
        NSLog(@"idx = %d, value = %@", idx, obj);  
    };
    
    NSArray *array = [[NSArray alloc] initWithObjects:@"who",@"are",@"you",@"?", nil];
    [array enumerateObjectsUsingBlock:enumBlock];
    
}

@end
