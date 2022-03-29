//
//  UIView+JLAdd.h
//  JLWechat
//
//  Created by JL on 2020/12/20.
//

#import <UIKit/UIKit.h>

@interface UIView (JLAdd)

///是否显示底部横线
- (void)addBottomLine:(UIColor *)lineColor;
///是否显示顶部横线
- (void)addTopLine:(UIColor *)lineColor;
///是否显示左部竖线
- (void)addLeftLine:(UIColor *)lineColor;
///是否显示右部竖线
- (void)addRightLine:(UIColor *)lineColor;
///显示四周边框
- (void)showBorder:(UIColor *)lineColor;
///添加上面两个圆角
- (void)addTopCornorRadius:(CGFloat)radius;

///添加下面两个圆角
- (void)addBottomCornorRadius:(CGFloat)radius;

// 添加圆角
- (void)addCornorRadius;

- (void)addCornorWithRadius:(CGFloat)radius;

///右侧添加圆角
- (void)addRightCornorRadius:(CGFloat)radius;

///添加tap gesture
- (void)bc_addTarget:(id)target action:(SEL)action;

@end

