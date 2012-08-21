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

- (void)blockExamples
{
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

- (void)GCD_1
{
    // GCD
    
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    dispatch_async(mainQueue, ^(void) {
        [[[UIAlertView alloc] initWithTitle:@"GCD" 
                                    message:@"GCD is amazing!" 
                                   delegate:nil 
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil, nil] show];
    });
}

- (void)GCD_2
{
    //[self GCD_1];
    
    
    void(^bigCalc)(void) = ^{
        for( int i =0; i< 1000; ++i )
        {
            NSLog(@" i = %d, thread = %@ ", i, [NSThread currentThread] );
        }
    };
    
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0); 
    
    dispatch_async(concurrentQueue, bigCalc);
    dispatch_async(concurrentQueue, bigCalc);
    dispatch_async(concurrentQueue, bigCalc);
    dispatch_async(concurrentQueue, bigCalc);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //[self blockExamples];
    void(^bigCalc1)(void) = ^{
        for( int i =0; i< 10; ++i )
        {
            NSLog(@"1: i = %d, thread = %@ ", i, [NSThread currentThread] );
        }
    };
    
    void(^bigCalc2)(void) = ^{
        for( int i =0; i< 10; ++i )
        {
            NSLog(@"2: i = %d, thread = %@ ", i, [NSThread currentThread] );
        }
    };
    
    dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);   
    dispatch_async(q, bigCalc1);
    NSLog(@"main");
    dispatch_sync(q, bigCalc2);
    NSLog(@"main");

}



@end
