//
//  BCResponder.m
//  BCTeam
//
//  Created by beichen on 2022/3/28.
//

#import "BCResponder.h"
#import "BCTabBarViewController.h"

@implementation BCResponder

- (void)configRootViewController{
    self.window.backgroundColor = UIColor.whiteColor;
    [self.window makeKeyAndVisible];
    BCTabBarViewController * tabbar = [BCTabBarViewController new];
    [self.window setRootViewController:tabbar];
}

@end
