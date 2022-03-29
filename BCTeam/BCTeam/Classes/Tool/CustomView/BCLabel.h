//
//  BCLabel.h
//  BcExamApp
//
//  Created by beichen on 2021/11/30.
//  Copyright © 2021 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BCLabel : UILabel
///设置文本内边距
@property (nonatomic,assign) UIEdgeInsets textInset;
///是否开启自动滚动
@property (nonatomic,assign) BOOL isAutoScroll;
///动画时间，默认根据文字长度自动计算，单个文字执行0.25
@property (nonatomic,assign) CFTimeInterval duration;

- (void)startScrollAnimation;

@end
