//
//  BCAlterEditViewController.h
//  BcExamApp
//
//  Created by beichen on 2021/11/29.
//  Copyright © 2021 apple. All rights reserved.
//

#import "BCBaseViewController.h"

typedef void(^AlterEditHandleBlock)(NSString *text);

typedef NS_ENUM(NSInteger,BCAlterEditStyle) {
    BCAlterEditStyle_deault,
    BCAlterEditStyle_alterNick,//修改昵称
};

@interface BCAlterEditViewController : BCBaseViewController

/**
 *编辑弹窗 确认按钮默认文案：确认修改
 *title 黑色标题
 *placeholder 默认引导文案
 *sureTitle 自定义确认按钮名称
 *remark 备注文案
 *style 样式类型
 */
+ (void)showEditAlter:(UIViewController*)weakSelf title:(NSString *)title placeholder:(NSString *)placeholder sureTitle:(NSString *)sureTitle remark:(NSString *)remark style:(BCAlterEditStyle )style handleBlock:(AlterEditHandleBlock)block;

/**
 *编辑弹窗 确认按钮默认文案：确认修改
 *title 黑色标题
 *placeholder 默认引导文案
 *sureTitle 自定义确认按钮名称
 *remark 备注文案
 */
+ (void)showEditAlter:(UIViewController*)weakSelf title:(NSString *)title placeholder:(NSString *)placeholder sureTitle:(NSString *)sureTitle remark:(NSString *)remark handleBlock:(AlterEditHandleBlock)block;

@end
