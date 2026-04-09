//
//  BOAppDelegate.m
//  BreakOut3b
//
//  Created by Carl Tengwall on 2012-11-06.
//  Copyright (c) 2012 Carl Tengwall. All rights reserved.
//

#import "BOAppDelegate.h"

@implementation BOAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    //_ NSlog(@"In BOAppDelegate didFinishLaunchingWithOptions:");
    
    // Create default arrays of players, scores and background colors selected by player
    NSArray *defaultUsers = @[];
    NSArray *defaultDiffs = @[];
    NSArray *defaultScores = @[];
    NSArray *defaultBackgroundColors = @[];
    
    // Set default currentPlayer to '-1'
    NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithInt:-1], @"currentPlayer" // The "-1" setting means that this is a "cold start" of the app
                                 , [NSNumber numberWithInt:0], @"noOfUsers"
                                 , defaultUsers , @"users"
                                 , defaultDiffs , @"diffs"
                                 , defaultScores , @"scores"
                                 , defaultBackgroundColors, @"colors"
                                 , nil];
    
    // Register the defaults
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Override point for customization after application launch.
    BOSettingsTableViewController *bostvc;
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    bostvc = (BOSettingsTableViewController *)navigationController.topViewController;
    
    
    // Ge länkar till BOSettingsTableViewController
    NSMutableArray *users = [[NSMutableArray alloc] init];
    bostvc.users = users;
    

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
