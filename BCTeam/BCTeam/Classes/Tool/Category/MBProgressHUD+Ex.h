//
//  MBProgressHUD+Ex.h
//  BcExamApp
//
//  Created by apple on 2019/12/10.
//  Copyright © 2019 apple. All rights reserved.
//

#import "MBProgressHUD.h"

NS_ASSUME_NONNULL_BEGIN

@interface MBProgressHUD (Ex)

+ (void)showLoading:(NSString *)success;
+ (void)showLoading:(NSString *)success toView:(UIView * _Nullable)view;

+ (MBProgressHUD *)showMessage:(NSString *)message;
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *_Nullable)view;

+ (void)hideHUD;
+ (void)hideHUDForView:(UIView *_Nullable)view;

@end

NS_ASSUME_NONNULL_END
