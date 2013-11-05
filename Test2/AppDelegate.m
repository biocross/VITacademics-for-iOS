//
//  AppDelegate.m
//  Test2
//
//  Created by Siddharth Gupta on 5/7/13.
//  Copyright (c) 2013 Siddharth Gupta. All rights reserved.
//

#import "AppDelegate.h"
#import <CoreData/CoreData.h>
#import "Helpshift.h"
#import "GAI.h"
#import "Crittercism.h"



@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
#pragma mark - External Library Initializations
    
    //Helpshift
    [Helpshift installForAppID:@"vitinfo-android_platform_20130524211329481-a3c8d4e32860316" domainName:@"vitinfo-android.helpshift.com" apiKey:@"91ff50eded9d62de7020a839c1e2292e"];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if([prefs stringForKey:@"registrationNumber"]){
        [Helpshift setUsername:[prefs stringForKey:@"registrationNumber"]];
    }
    
    //Crittercism
    [Crittercism enableWithAppID: @"526e47368b2e337b2700000a"];
    
    //Google Analytics
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    [GAI sharedInstance].dispatchInterval = 30;
    //[[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    // Initialize tracker.
    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-38195928-4"];
    NSLog(@"%@", [tracker debugDescription]);
    
    return YES;
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
