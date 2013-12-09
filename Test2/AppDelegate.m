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
#import <Parse/Parse.h>



@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|
     UIRemoteNotificationTypeAlert|
     UIRemoteNotificationTypeSound];
    
#pragma mark - External Library Initializations
    
    //Helpshift
    [Helpshift installForAppID:@"vitinfo-android_platform_20130524211329481-a3c8d4e32860316" domainName:@"vitinfo-android.helpshift.com" apiKey:@"91ff50eded9d62de7020a839c1e2292e"];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if([prefs stringForKey:@"registrationNumber"]){
        [Helpshift setUsername:[prefs stringForKey:@"registrationNumber"]];
    }
    
#warning Disable Crittrcism for dev
    //Crittercism
    //[Crittercism enableWithAppID: @"526e47368b2e337b2700000a"];
    
    //Google Analytics
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    [GAI sharedInstance].dispatchInterval = 30;
    //[[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    // Initialize tracker.
    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-38195928-4"];
    NSLog(@"%@", [tracker debugDescription]);
    
    //Parse
    [Parse setApplicationId:@"vtpDFHGacMwZIpMtpDaFuu0ToBol9b9nQM9VD57N"
                  clientKey:@"OCKn8dB6wqeGqvSdYbXHgYe9mDGFb2yukyDHT3Fs"];
    
    if (application.applicationState != UIApplicationStateBackground) {
        // Track an app open here if we launch with a push, unless
        // "content_available" was used to trigger a background push (introduced
        // in iOS 7). In that case, we skip tracking here to avoid double counting
        // the app-open.
        BOOL preBackgroundPush = ![application respondsToSelector:@selector(backgroundRefreshStatus)];
        BOOL oldPushHandlerOnly = ![self respondsToSelector:@selector(application:didReceiveRemoteNotification:fetchCompletionHandler:)];
        BOOL noPushPayload = ![launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (preBackgroundPush || oldPushHandlerOnly || noPushPayload) {
            [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
        }
    }
    
#pragma mark - Push Notification Handling
    
    @try{
        NSDictionary *notificationPayload = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
        if([launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey]){
            
            NSDictionary *deeper = [notificationPayload objectForKey:@"aps"];
            UIAlertView *pushAlert = [[UIAlertView alloc] initWithTitle:@"" message:[deeper objectForKey:@"alert"] delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [pushAlert show];
        }
 
    }
    @catch (NSException *e) {
        NSLog(@"%@", [e description]);
    }
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
    
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    if (currentInstallation.badge != 0) {
        currentInstallation.badge = 0;
        [currentInstallation saveEventually];
    }
    
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    if (application.applicationState == UIApplicationStateInactive) {
        [PFAnalytics trackAppOpenedWithRemoteNotificationPayload:userInfo];
    }
    [PFPush handlePush:userInfo];
}


- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))handler {
    
    NSDictionary *deeper = [userInfo objectForKey:@"aps"];
    if([deeper objectForKey:@"alert"]){
        UIAlertView *pushAlert = [[UIAlertView alloc] initWithTitle:@"" message:[deeper objectForKey:@"alert"] delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [pushAlert show];
    }

}

@end
