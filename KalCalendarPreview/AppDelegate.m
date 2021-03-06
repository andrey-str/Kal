//
//  AppDelegate.m
//  QalendarPreview
//
//  Created by Andrey Streltsov on 23/07/14.
//  Copyright (c) 2014 Gagik. All rights reserved.
//

#import "AppDelegate.h"
#import "KalViewController.h"
#import "NSDate+Convenience.h"

@interface AppDelegate ()
{
    UINavigationController *_navController;
}

@property (nonatomic, strong) KalViewController* kalViewController;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    self.kalViewController = [[KalViewController alloc] initWithSelectionMode: KalSelectionModeSingle];
    self.kalViewController.selectedDate = [NSDate dateStartOfDay:[[NSDate date] offsetDay:1]];
    self.kalViewController.beginDate = [NSDate dateFromString:@"2014-07-01"];
    self.kalViewController.endDate = [NSDate dateFromString:@"2014-08-01"];
    [_kalViewController showAndSelectDate:[NSDate date]];
    self.kalViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Today", @"")
                                                                                                style:UIBarButtonItemStyleBordered
                                                                                               target:self
                                                                                               action:@selector(onTodayBtnTap:)];
    
    self.kalViewController.title = @"NativeCal";
    
//    [self presentViewController:self.kalViewController animated:NO completion:nil];
    
    self.kalViewController.viewMode = eMonthView;
    
    _navController = [[UINavigationController alloc] initWithRootViewController:self.kalViewController];
    _window.rootViewController = _navController;
    [_window makeKeyAndVisible];

    
    return YES;
}

- (void) onTodayBtnTap: (id) sender{
    
    int mode = (int)self.kalViewController.viewMode;
    
    mode++;
    if(mode == eKalViewMode_MAX)
        mode = eKalViewMode_MIN + 1;
    
    self.kalViewController.viewMode = (eKalViewMode)mode;
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
