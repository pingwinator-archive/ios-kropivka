//
//  ViewController.m
//  runtime_test
//
//  Created by Michail Kropivka on 12.10.12.
//  Copyright (c) 2012 Michail Kropivka. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

#if TARGET_IPHONE_SIMULATOR
    #import <objc/objc-runtime.h>
#else
    #import <objc/runtime.h>
    #import <objc/message.h>
#endif

@interface ViewController ()
@end

void defSelector(id me, SEL cmd)
{
    NSLog(@"selector %@ called", NSStringFromSelector(cmd));
}

@interface TestClass : NSObject
- (void)fire;
- (void)task1;
- (void)task2;
@end


@implementation TestClass 

- (void)fire{
    [self task1];
    [self task2];
}

- (void)task1{
    NSLog(@"I am task1");
}

- (void)task2{
    NSLog(@"I am task2");
}

+ (BOOL) resolveInstanceMethod:(SEL)sel{
    class_addMethod([TestClass class], sel, (IMP)defSelector, "v@:");
    return [super resolveInstanceMethod:sel];
}

@end

@protocol TestProtocol <NSObject>
- (void)fixedTask;
@end

void fixedTask(id me, SEL cmd)
{
    NSLog(@"fixed task");
    [me fixedTask];
}

BOOL resolveInstanceMethod_(id me, SEL cmd){
    class_addMethod([TestClass class], cmd, (IMP)defSelector, "v@:");
    return [[me superclass] resolveInstanceMethod:cmd];
}

void makeClassImmortal(Class class){
    class_addMethod(class, @selector(resolveInstanceMethod), (IMP)resolveInstanceMethod_, "b@:");
}

@implementation ViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"hi!");
    
    TestClass* t = [[TestClass alloc] init];

    Class myClass = NSClassFromString(@"TestClass");
    if(myClass)
    {
        class_addMethod(myClass, @selector(fixedTask), (IMP)fixedTask, "v@:");
        makeClassImmortal(myClass);

        Method m1 = class_getInstanceMethod(myClass, @selector(task1));
        Method m2 = class_getInstanceMethod(myClass, @selector(fixedTask));
        method_exchangeImplementations(m1, m2);
    }

    [t performSelector:@selector(fcccire)];
    [t performSelector:@selector(sss123123)];
    [t performSelector:@selector(ssssfire)];
    [t performSelector:@selector(fire)];
}

@end
