//
//  AppDelegate.m
//  Swole
//
//  Created by gamaux01 on 2015/6/18.
//  Copyright (c) 2015年 Victor's Personal Projects. All rights reserved.
//

#import "AppDelegate.h"
#import "EntryListViewController.h"
#import "CRGradientNavigationBar.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
    EntryListViewController *entryListViewController = [[EntryListViewController alloc] initWithNibName:@"EntryListViewController" bundle:nil];
    
    //navigation bar gradient set up
    UINavigationController *nav = [[UINavigationController alloc] initWithNavigationBarClass:[CRGradientNavigationBar class] toolbarClass:nil];
    
    nav.navigationBar.tintColor = [UIColor whiteColor];

//    http://uigradients.com/#RedMist, http://ios7colors.com, http://www.color-hex.com/color/ff5e3a
    UIColor *secondColor = [UIColor colorWithRed:255.0f/255.0f green:94.f/255.0f blue:58.f/255.0f alpha:1.0f];
    UIColor *firstColor = [UIColor colorWithRed:255.0f/255.0f green:42.0f/255.0f blue:104.0f/255.0f alpha:1.0f];
    NSArray *colors = [NSArray arrayWithObjects:firstColor, secondColor, nil];
    [nav setViewControllers:@[entryListViewController]];
    
    [[CRGradientNavigationBar appearance] setBarTintGradientColors:colors];
    [[nav navigationBar] setTranslucent:NO]; // Remember, the default value is YES.
    
    [self.window setRootViewController:nav];
    [self.window makeKeyAndVisible];
    
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
