//
//  AppDelegate.m
//  MacGo
//
//  Created by David Elsonbaty on 11/16/14.
//  Copyright (c) 2014 David Elsonbaty. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "LTHPasscodeViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [Parse setApplicationId:@"nTERmyCRrA1y3B8LhGQiXP38lx8wu2Mrdtpppwhr"
                  clientKey:@"0F15Y4JqxGMPeRfDfsjFML26Yu3I5oNkA6KDzcME"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    [[LTHPasscodeViewController sharedUser] setBackgroundColor:[UIColor colorWithRed:0.05 green:0.1 blue:0.11 alpha:1]];
    [[LTHPasscodeViewController sharedUser] setLabelTextColor:[UIColor whiteColor]];
    [[LTHPasscodeViewController sharedUser] setPasscodeTextColor:[UIColor whiteColor]];
    
    UINavigationController *navigationController = [LTHPasscodeViewController sharedUser].navigationController;
    navigationController.navigationBar.tintColor = [UIColor whiteColor];
    navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.82 green:0.76 blue:0.49 alpha:1];
    navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],
                                                                      NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Light" size:21]}];
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
