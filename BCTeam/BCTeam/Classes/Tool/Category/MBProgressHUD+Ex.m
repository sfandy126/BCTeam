//
//  MBProgressHUD+Ex.m
//  BcExamApp
//
//  Created by apple on 2019/12/10.
//  Copyright © 2019 apple. All rights reserved.
//

#import "MBProgressHUD+Ex.h"

@implementation MBProgressHUD (Ex)

/**
 *  =======显示信息
 *  @param text 信息内容
 *  @param view 显示的视图
 */
+ (void)show:(NSString *)text view:(UIView *_Nullable)view
{
    if (!view){
        view = [UIApplication sharedApplication].keyWindow;
    }
    if (!view) {
        view = [UIApplication sharedApplication].delegate.window;
    }
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = text;
    hud.label.textColor = BCHexColor(@"333333");
    hud.label.font = [UIFont systemFontOfSize:16.0];
    hud.userInteractionEnabled = YES;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    //背景颜色
    hud.bezelView.backgroundColor = [UIColor whiteColor];
    // 设置模式
    hud.mode = MBProgressHUDModeIndeterminate;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
//    hud.dimBackground = YES;
    // 1秒之后再消失
//    [hud hideAnimated:YES afterDelay:1.];
}

/**
 *  =======显示 提示信息
 *  @param success 信息内容
 */
+ (void)showLoading:(NSString *)success
{
    [self showLoading:success toView:nil];
}

/**
 *  =======显示
 *  @param success 信息内容
 */
+ (void)showLoading:(NSString *)success toView:(UIView *_Nullable)view
{
    [self show:success view:view];
}


/**
 *  显示提示 + 菊花
 *  @param message 信息内容
 *  @return 直接返回一个MBProgressHUD， 需要手动关闭(  ?
 */
+ (MBProgressHUD *)showMessage:(NSString *)message
{
    if (message.length==0) {
        return nil;
    }
    return [self showMessage:message toView:nil];
}

/**
 *  显示一些信息
 *  @param message 信息内容
 *  @param view    需要显示信息的视图
 *  @return 直接返回一个MBProgressHUD
 */
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *_Nullable)view {
    if (!view){
        view = [UIApplication sharedApplication].keyWindow;
    }
    if (!view) {
        view = [UIApplication sharedApplication].delegate.window;
    }
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = message;
    // 设置模式
    hud.mode = MBProgressHUDModeText;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:1.5f];
    return hud;
}

/**
 *  手动关闭MBProgressHUD
 */
+ (void)hideHUD
{
    [self hideHUDForView:nil];
}
/**
 *  @param view    显示MBProgressHUD的视图
 */
+ (void)hideHUDForView:(UIView *_Nullable)view
{
    if (!view){
        view = [UIApplication sharedApplication].keyWindow;
    }
    if (!view) {
        view = [UIApplication sharedApplication].delegate.window;
    }
//    if (view) {
//        NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
//        for (UIView *subview in subviewsEnum){
//            if ([subview isKindOfClass:[MBProgressHUD class]]) {
//                MBProgressHUD *hud = (MBProgressHUD*)subview;
//                if (hud != nil) {
//                    hud.removeFromSuperViewOnHide = YES;
//                    [hud hideAnimated:NO];
//                }
//            }
//        }
//    }
    //多个显示时，只会隐藏一个，如果找不到哪里用到了2个，则可以直接用上面方法移除所有的
    [self hideHUDForView:view animated:YES];
}
@end
