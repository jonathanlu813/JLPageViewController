//
//  JLAppDelegate.m
//  JLPageViewController
//
//  Created by Jonathan Lu on 23/9/13.
//  Copyright (c) 2013 Jonathan Lu. All rights reserved.
//

#import "JLAppDelegate.h"
#import "JLPageViewController.h"
#import "JLTableViewController.h"

@implementation JLAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    JLPageViewController *pageViewController = [[JLPageViewController alloc] init];
    pageViewController.viewControllers = [NSArray arrayWithObjects:[[JLTableViewController alloc] initWithStyle:UITableViewStylePlain], [[JLTableViewController alloc] initWithStyle:UITableViewStylePlain], [[JLTableViewController alloc] initWithStyle:UITableViewStylePlain], nil];
    pageViewController.titles = [NSArray arrayWithObjects:NSLocalizedString(@"FIRST", @""), NSLocalizedString(@"SECOND", @""), NSLocalizedString(@"THIRD", @""), nil];
    pageViewController.sideViewTitle = NSLocalizedString(@"SIDE", @"");
    pageViewController.selectedViewController = [pageViewController.viewControllers objectAtIndex:0];
    pageViewController.sideViewController = [[JLTableViewController alloc] initWithStyle:UITableViewStylePlain];
    pageViewController.sideViewWidth = 200.0;
    pageViewController.pageIndicatorTintColor = [UIColor colorWithWhite:0.0 alpha:0.2];
    pageViewController.currentPageIndicatorTintColor = [UIColor blackColor];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:pageViewController];
    self.window.rootViewController = navigationController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    // Setup for demo
    pageViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Left" style:UIBarButtonItemStylePlain target:pageViewController action:@selector(showSideView:)];
    pageViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Right" style:UIBarButtonItemStylePlain target:pageViewController action:nil];
    
    // Turn off translucent nav bar on iOS7
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0){
        navigationController.navigationBar.translucent = NO;
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
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
