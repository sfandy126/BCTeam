//
//  BCTabBarViewController.m
//  BCTeam
//
//  Created by beichen on 2022/3/28.
//

#import "BCTabBarViewController.h"
#import "BCNavigationController.h"
#import "BCTabBar.h"

@interface BCTabBarViewController ()<UITabBarControllerDelegate>
@property (nonatomic,strong) BCTabBar *cusTabbar;
@end

@implementation BCTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    self.cusTabbar = [BCTabBar new];
    self.cusTabbar.translucent = NO;
    [self setValue:self.cusTabbar forKeyPath:@"tabBar"];
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.cusTabbar.width, BCTabBarHeight)];//self.tabBar.height
    bgView.backgroundColor = [UIColor whiteColor];
    [self.cusTabbar insertSubview:bgView atIndex:0];
    [self addChildViewControllers];
}

//添加子控制器
- (void)addChildViewControllers{
//    [self addChildVc:[[BCHomeViewController alloc] init] title:@"首页" image:@"bc_home_unselect_icon" selectedImage:@"bc_home_selected_icon"];
//    [self addChildVc:[[BCReadClubHomeViewController alloc] init] title:@"读书" image:@"bc_read_unselect_icon" selectedImage:@"bc_read_selected_icon"];
//    [self addChildVc:[[BCStudyCenterController alloc] init] title:@"学习" image:@"bc_learn_unselect_icon" selectedImage:@"bc_learn_selected_icon"];
//    [self addChildVc:[[BCMineNewViewController alloc] init] title:@"我的" image:@"bc_mine_unselect_icon" selectedImage:@"bc_mine_selected_icon"];
}

#pragma mark - 添加子控制器  设置图片
- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage

{
    childVc.tabBarItem.title = title;

    childVc.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 普通状态下的文字属性
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSForegroundColorAttributeName] = BCHexColor(@"#333333");;
    normalAttrs[NSFontAttributeName] = BCFont(13);
    
    // 选中状态下的文字属性
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = BCHexColor(@"#FE5922");
    selectedAttrs[NSFontAttributeName] = BCFont(13);
    
    [childVc.tabBarItem setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    
    UITabBar * tabBar = [UITabBar appearance];
    if (@available(iOS 13.0, *)){
        UITabBarAppearance * tabBarAppearance = [[UITabBarAppearance alloc] init];
        [tabBarAppearance.stackedLayoutAppearance.normal setTitleTextAttributes:normalAttrs];
        [tabBarAppearance.stackedLayoutAppearance.selected setTitleTextAttributes:selectedAttrs];
        tabBarAppearance.shadowColor = [UIColor clearColor];
        [tabBar setStandardAppearance:tabBarAppearance];
    } else {
        tabBar.unselectedItemTintColor = BCHexColor(@"#333333");
        tabBar.tintColor = BCHexColor(@"#FE5922");
    }
    
    BCNavigationController *nav = [[BCNavigationController alloc] initWithRootViewController:childVc];
    [self addChildViewController:nav];
}

#pragma mark - -  UITabBarControllerDelegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
   
}


#pragma mark 横竖屏控制
- (BOOL)shouldAutorotate {
    return self.selectedViewController.shouldAutorotate;
}

//控制当前控制器支持哪些方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return self.selectedViewController.supportedInterfaceOrientations;
}


//- (UITraitCollection *)traitCollection {
//    UITraitCollection *oldTrait = super.traitCollection;
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
//        UITraitCollection *tmpTrait = [UITraitCollection traitCollectionWithHorizontalSizeClass: UIUserInterfaceSizeClassCompact];
//        UITraitCollection *newTrait = [UITraitCollection traitCollectionWithTraitsFromCollections:@[oldTrait, tmpTrait]];
//        return newTrait;
//    }
//    return oldTrait;
//}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return [self.selectedViewController preferredInterfaceOrientationForPresentation];
}

@end
