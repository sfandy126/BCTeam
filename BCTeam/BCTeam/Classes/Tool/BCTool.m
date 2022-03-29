//
//  BCTool.m
//  BCTeam
//
//  Created by beichen on 2022/3/29.
//

#import "BCTool.h"

@implementation BCTool

/**
 获取当前视图控制器
 */
+ (UIViewController *)getCurrentVC{
    UIWindow* window = [[[UIApplication sharedApplication] delegate] window];
    if (!window) {
        window = [UIApplication sharedApplication].keyWindow;
    }
    NSAssert(window, @"The window is empty");
    UIViewController * currentViewController = window.rootViewController;
    BOOL runLoopFind = YES;
    while (runLoopFind) {
        if (currentViewController.presentedViewController) {
            currentViewController = currentViewController.presentedViewController;
        } else if ([currentViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController* navigationController = (UINavigationController* )currentViewController;
            currentViewController = [navigationController.childViewControllers lastObject];
        } else if ([currentViewController isKindOfClass:[UITabBarController class]]) {
            UITabBarController* tabBarController = (UITabBarController* )currentViewController;
            currentViewController = tabBarController.selectedViewController;
        } else {
            NSUInteger childViewControllerCount = currentViewController.childViewControllers.count;
            if (childViewControllerCount > 0) {
                currentViewController = currentViewController.childViewControllers.lastObject;
                return currentViewController;
            } else {
                return currentViewController;
            }
        }
    }
    return currentViewController;
}

@end
