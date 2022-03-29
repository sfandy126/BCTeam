//
//  UIView+Ex.m
//  BcExamApp
//
//  Created by apple on 2019/12/2.
//  Copyright © 2019 apple. All rights reserved.
//

#import "UIView+Ex.h"


@implementation UIView (Ex)

/**
 截图
 */
- (UIImage *)c_screenShot
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    if( [self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]){
        [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
    }else{
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenshot;
}

/**
 设置圆角
 */
- (void)c_setRoundedCorners:(UIRectCorner)corners radius:(CGFloat)radius
{
    if (CGSizeEqualToSize(self.bounds.size, self.layer.mask.bounds.size)) {
        return ;
    }
    CGRect rect = self.bounds;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect
                                                   byRoundingCorners:corners
                                                         cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = rect;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

/**
 设置阴影
 */
- (void)c_shadowWithColor:(UIColor *)color offset: (CGSize)offset opacity: (CGFloat)opacity radius: (CGFloat)radius
{
    self.clipsToBounds = NO;
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = offset;
    self.layer.shadowOpacity = opacity;
    self.layer.shadowRadius = radius;
}

/**
 设置渐变色
 
 @param isdown YES:向下   NO:向右
 */
- (void)c_setViewGradientStartColor:(UIColor *)sc endColor:(UIColor *)ec isDown:(BOOL)isdown
{
    for (int i = 0; i < self.layer.sublayers.count; i++) {
        if ([self.layer.sublayers[i] isKindOfClass:[CAGradientLayer class]]) {
            CAGradientLayer *gradient = (CAGradientLayer *)self.layer.sublayers[i];
            gradient.colors = @[(id)sc.CGColor, (id)ec.CGColor];
            self.layer.sublayers[i].frame = self.bounds;
            return ;
        }
    }
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.bounds;
    if (!isdown) {
        gradient.startPoint = CGPointMake(0, 0);
        gradient.endPoint   = CGPointMake(1, 0);
    }
    gradient.colors = @[(id)sc.CGColor, (id)ec.CGColor];
    [self.layer insertSublayer:gradient atIndex:0];
}

/**
 获取当前试图的试图控制器
 */
- (UIViewController *)c_getCurrentVC
{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController
                                          class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}














- (CGFloat)x {
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

@end


