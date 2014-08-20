//
//  NCCDAppDelegate.m
//  BlocksTest
//
//  Created by Sean Reed on 8/19/14.
//  Copyright (c) 2014 seanreed.test. All rights reserved.
//

#import "NCCDAppDelegate.h"

@implementation NCCDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
     NSLog(@"application didFinishLaunchingWithOptions:");
    // Override point for customization after application launch.

    
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    NSOperationQueue *myQueue = [[NSOperationQueue alloc]init];
    myQueue.name = @"My Queue";

    
    void (^completion)() = ^(){
        NSLog(@"completed");
        NSLog(@"currentOperationQueue is %@", [[NSOperationQueue currentQueue] name]);
    };
    void (^runFirst)() = ^(){
        NSLog(@"first");
        NSLog(@"currentOperationQueue is %@", [[NSOperationQueue currentQueue] name]);
    };
    void (^runSecond)() = ^(){
        NSLog(@"second");
        NSLog(@"currentOperationQueue is %@", [[NSOperationQueue currentQueue] name]);
    };
    
    NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:runFirst];
    NSBlockOperation *operation2 = [NSBlockOperation blockOperationWithBlock:runSecond];
    NSBlockOperation *completionOperation = [NSBlockOperation blockOperationWithBlock:completion];

    // For the NSInvocationQueueTest
    NSInvocationOperation *invocationOperation = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(invocationTest) object:nil];


    [operation2 addDependency:operation1];
    [completionOperation addDependency:operation2];
    
    [myQueue addOperation:operation2];
    [myQueue addOperation:operation1];
    [mainQueue addOperation:completionOperation];
    [myQueue addOperation:invocationOperation];
    

    
    return YES;
}

- (void)invocationTest
{
    NSLog(@"Invocation successful");
    NSLog(@"currentOperationQueue is %@", [[NSOperationQueue currentQueue] name]);
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
