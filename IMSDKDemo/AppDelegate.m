//
//  AppDelegate.m
//  IMSDKDemo
//
//  Created by jack on 13-9-24.
//  Copyright (c) 2013年 appkefu.com. All rights reserved.
//

#import "AppDelegate.h"

#import "LoginViewController.h"
#import "DemoViewController.h"

#import "AppKeFuIMSDK.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    DemoViewController *sampleViewController = [[DemoViewController alloc] init];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:sampleViewController];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    
    
    //请到http://appkefu.com/AppKeFu/admin 申请 app key
    if (![[AppKeFuIMSDK sharedInstance] initWithAppkey:@"521c3187dfc2a7fe724ca4fa725b1c43"])
    {
        NSLog(@"app key 无效，请到http://appkefu.com/AppKeFu/admin申请!");
    }
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:IS_USERNAME_SET])
    {
        [[AppKeFuIMSDK sharedInstance] loginWithUsername:[[NSUserDefaults standardUserDefaults] stringForKey:USERNAME]
                                                password:[[NSUserDefaults standardUserDefaults] stringForKey:PASSWORD]
                                                  inView:self.navigationController.view];
    }
    else
    {
        LoginViewController *loginVC = [[LoginViewController alloc] initWithStyle:UITableViewStyleGrouped];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self.navigationController presentViewController:navController animated:YES completion:^{
            
        }];
    }
    
    //NSLog(@"test language:%@",NSLocalizedString(@"language", @""));
    
    //NSLog(@"version: %f", [[[UIDevice currentDevice] systemVersion] floatValue]);
    
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
    
    //苹果官方规定除特定应用类型，如：音乐、VOIP类可以在后台运行，其他类型应用均不得在后台运行，所以在程序退到后台要执行logout登出，
    //离线消息通过服务器推送可接收到
    //在程序切换到前台时，执行重新登录，见applicationWillEnterForeground函数中
    [[AppKeFuIMSDK sharedInstance] logout];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    //切换到前台重新登录
    if ([[NSUserDefaults standardUserDefaults] boolForKey:IS_USERNAME_SET])
    {
        [[AppKeFuIMSDK sharedInstance] loginWithUsername:[[NSUserDefaults standardUserDefaults] stringForKey:USERNAME] password:[[NSUserDefaults standardUserDefaults] stringForKey:PASSWORD] inView:self.navigationController.view];
    }
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
