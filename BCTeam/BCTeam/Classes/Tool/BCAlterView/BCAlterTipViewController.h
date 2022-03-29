//
//  BCAlterTipViewController.h
//  BcExamApp
//
//  Created by beichen on 2021/11/30.
//  Copyright © 2021 apple. All rights reserved.
//

#import "BCBaseViewController.h"

typedef void(^AlterTipHandleBlock)(void);

@interface BCAlterTipViewController : BCBaseViewController

/**
 *提示弹窗（兑换成功），标题为红色标题，一个按钮
 *title 标题文案
 *subTitle 子标题，可选
 *message 展示提示内容
 *sureTitle 按钮名称
 */
+ (void)showTipAlter:(UIViewController*)weakSelf title:(NSString *)title subTitle:(NSString *)subTitle message:(NSString *)message sureTitle:(NSString *)sureTitle handleBlock:(AlterTipHandleBlock)block;

@end

