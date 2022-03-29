//
//  UIControl+BCAOP.h
//  BcExamApp
//
//  Created by beichen on 2021/12/18.
//  Copyright © 2021 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (BCAOP)
// 间隔多少秒才能响应事件
@property(nonatomic, assign) NSTimeInterval eventInterval;

@end

