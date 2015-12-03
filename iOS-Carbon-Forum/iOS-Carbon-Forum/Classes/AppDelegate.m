//
//  AppDelegate.m
//  iOS-Carbon-Forum
//
//  Created by WangShengFeng on 15/12/3.
//  Copyright © 2015年 WangShengFeng. All rights reserved.
//

#import "AppDelegate.h"
#import "CBTopicViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (UIWindow *)window
{
    if (!_window) {
        _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [_window makeKeyAndVisible];
    }
    return _window;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    CBTopicViewController *tableVC = [[CBTopicViewController alloc] init];
    self.window.rootViewController = tableVC;

    return YES;
}

@end
