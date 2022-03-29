//
//  BCNavigationController.m
//  BCTeam
//
//  Created by beichen on 2022/3/28.
//

#import "BCNavigationController.h"

@interface BCNavigationController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@end

@implementation BCNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationBar.translucent = NO;
    UIImage *barBgImg = [UIImage imageWithColor:[UIColor whiteColor]];
    barBgImg = [barBgImg resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch];
    UIFont *font = BCBoldFont(BCScale(14));
    
    UIImage *shadowImage = [UIImage imageWithColor:[UIColor clearColor]];
    shadowImage = [shadowImage resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch];
    
    NSDictionary *option = @{NSForegroundColorAttributeName:BCHexColor(@"#1A1A1A"),NSFontAttributeName:font};
    
    if (@available(iOS 15, *)) {
        UINavigationBarAppearance *appearance = self.navigationBar.standardAppearance;
        [appearance configureWithOpaqueBackground];
        [appearance setBackgroundImage:barBgImg];
        [appearance setTitleTextAttributes:option];
        appearance.shadowImage = shadowImage ;
        self.navigationBar.scrollEdgeAppearance = appearance;
    }else{
        [self.navigationBar setShadowImage:[UIImage new]];
        [self.navigationBar setBackgroundImage:barBgImg forBarMetrics:UIBarMetricsDefault];
        [self.navigationBar setTitleTextAttributes:option];
    }

    [self.navigationBar setTintColor:BCHexColor(@"#1A1A1A")];
    self.view.backgroundColor = [UIColor whiteColor];
    self.delegate = self;
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = nil;
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}


- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animate{
    
}

//重写这个方法，在跳转后自动隐藏tabbar
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    //关闭UINavigationController+FDFullscreenPopGesture中的block,返回的fd_viewwillAppear中的block会执行setNavigationBarHidden,导致导航栏切换效果不美好
    self.fd_viewControllerBasedNavigationBarAppearanceEnabled = NO;
    
    if ([self.viewControllers count] > 0){
        viewController.hidesBottomBarWhenPushed = YES;
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_black"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
        backItem.tintColor = [UIColor colorWithHexString:@"#5B5B5B"];
        viewController.navigationItem.leftBarButtonItem = backItem;
    }
    //一定要写在最后，要不然无效
    [super pushViewController:viewController animated:animated];
}

- (void)backAction{
    [self popViewControllerAnimated:YES];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    BOOL needHidder = NO;
    if ([[self needHidderNavigation] containsObject:viewController.className]) {
        needHidder = YES;
    }
    [self setNavigationBarHidden:needHidder animated:animated];
}

///所有需要隐藏导航栏的页面,其他任何地方不设置setNavigationBarHidden
- (NSArray *)needHidderNavigation{
    return @[];
}

#pragma mark 横竖屏控制
- (BOOL)shouldAutorotate {
    return self.topViewController.shouldAutorotate;
}

//控制当前控制器支持哪些方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return self.topViewController.supportedInterfaceOrientations;
}


@end
