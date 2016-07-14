//
//  AppDelegate.m
//  125 项目:百思不得姐
//
//  Created by wudi on 16/6/23.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import "AppDelegate.h"
#import "WDTabBarController.h"
#import "WDGuideView.h"

@interface AppDelegate ()<UITabBarControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    WDTabBarController *tabBarC = [[WDTabBarController alloc] init];
    
    self.window.rootViewController = tabBarC;
    
    [self.window makeKeyAndVisible];
    
    // 判断是否显示引导使用页
    [WDGuideView show];
    
    // 将AppDelegate作为WDTabBarController的代理,监听tabBarItem的点击
    tabBarC.delegate = self;
    
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    
    // 每点击tabBar上面的某个按钮,就会来到该方法
    // 由于tabBar上的按钮和控制器相对应,所以点击按钮相当于选择了某个控制器
    
    // 在该方法中发出一个通知,内容为tabBar上的某个按钮被点击
    [[NSNotificationCenter defaultCenter] postNotificationName:WDTabBarSelectedItemNoti object:nil];
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
