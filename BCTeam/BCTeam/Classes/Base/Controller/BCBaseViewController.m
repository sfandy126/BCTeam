//
//  BCBaseViewController.m
//  BCTeam
//
//  Created by beichen on 2022/3/28.
//

#import "BCBaseViewController.h"

@interface BCBaseViewController ()

@end

@implementation BCBaseViewController

- (void)dealloc{
    BCLog(@"%s %@",__func__,NSStringFromClass([self class]));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    if (@available(iOS 15.0, *)) {
        UITableView.appearance.sectionHeaderTopPadding = 0.0;
    }
}


- (UIStatusBarStyle)preferredStatusBarStyle{
    if (@available(iOS 13.0, *)) {
        return UIStatusBarStyleDarkContent;
    }
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden{
    return NO;
}

#pragma mark 横竖屏控制

- (BOOL)shouldAutorotate {
    return YES;
}

//控制当前控制器支持哪些方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}

@end
