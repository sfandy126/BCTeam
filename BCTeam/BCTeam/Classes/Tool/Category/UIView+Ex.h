//
//  UIView+Ex.h
//  BcExamApp
//
//  Created by apple on 2019/12/2.
//  Copyright © 2019 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Ex)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGSize  size;
@property (nonatomic, assign) CGPoint origin;

/**
    截图
 */
- (UIImage *)c_screenShot;

/**
    设置圆角
 */
- (void)c_setRoundedCorners:(UIRectCorner)corners radius:(CGFloat)radius;

/**
    设置阴影
 */
-(void)c_shadowWithColor: (UIColor *)color offset: (CGSize)offset opacity: (CGFloat)opacity radius: (CGFloat)radius;

/**
 设置渐变色
 
 @param isdown YES:向下   NO:向右
 */
- (void)c_setViewGradientStartColor:(UIColor *)sc endColor:(UIColor *)ec isDown:(BOOL)isdown;

/**
 获取当前试图的试图控制器
 */
- (UIViewController *)c_getCurrentVC;


@end

NS_ASSUME_NONNULL_END
