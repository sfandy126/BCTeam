//
//  BCAlterViewController.h
//  BcExamApp
//
//  Created by beichen on 2021/11/29.
//  Copyright © 2021 apple. All rights reserved.
//

#import "BCBaseViewController.h"

///按钮从左->右
typedef void(^AlterHandleBlock)(NSInteger index);

@interface BCAlterViewController : BCBaseViewController

- (void)dismiss;

/**
 *自定义通用弹窗,类似UIAlertController，view根据内容自适应高度
 *weakSelf 从哪个页面 present   ,weakSelf=nil，则从rootViewController
 *title:可选
 *message:必传 ,title为空，则改变了message字号,默认最多展示2行，可改，目前2行应该足够适用
 *butTitles: 按钮名称数组，深色按钮在右侧，左侧为取消按钮，
 */
+ (BCAlterViewController *)showAlter:(UIViewController*)weakSelf title:(NSString *)title message:(NSString *)message butTitles:(NSArray *)butTitles handleBlock:(AlterHandleBlock)block;

@end

