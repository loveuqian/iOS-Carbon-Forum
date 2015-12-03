//
//  AppDelegate.m
//  iOS-Carbon-Forum
//
//  Created by WangShengFeng on 15/12/3.
//  Copyright © 2015年 WangShengFeng. All rights reserved.
//

#import "AppDelegate.h"
#import "CBNavigationController.h"
#import "CBTopicListViewController.h"

@interface AppDelegate ()

@property (nonatomic, strong) CBNavigationController *navVC;
@property (nonatomic, strong) CBTopicListViewController *topicVC;

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

- (CBNavigationController *)navVC
{
    if (!_navVC) {
        _navVC = [[CBNavigationController alloc] initWithRootViewController:self.topicVC];
    }
    return _navVC;
}

- (CBTopicListViewController *)topicVC
{
    if (!_topicVC) {
        _topicVC = [[CBTopicListViewController alloc] init];
    }
    return _topicVC;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window.rootViewController = self.navVC;

    return YES;
}

@end
