//
//  UIView+JLAdd.m
//  JLWechat
//
//  Created by JL on 2020/12/20.
//

#import "UIView+JLAdd.h"

@implementation UIView (JLAdd)

//是否显示底部横线
- (void)addBottomLine:(UIColor *)lineColor
{
  UIView *_line = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-0.5, self.frame.size.width, 0.5)];
  _line.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
  _line.backgroundColor = lineColor;
  [self addSubview:_line];
}

//是否显示顶部横线
- (void)addTopLine:(UIColor *)lineColor
{
  UIView *_line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0.5)];
  _line.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
  _line.backgroundColor = lineColor;
  [self addSubview:_line];
}

//是否显示左部竖线
- (void)addLeftLine:(UIColor *)lineColor
{
  UIView *_line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.5, self.frame.size.height)];
  _line.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
  _line.backgroundColor = lineColor;
  [self addSubview:_line];
}

//是否显示右部竖线
- (void)addRightLine:(UIColor *)lineColor
{
  UIView *_line = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width-0.5, 0, 0.5, self.frame.size.height)];
  _line.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
  _line.backgroundColor = lineColor;
  [self addSubview:_line];
}

//是否显示四周边框
- (void)showBorder:(UIColor *)lineColor
{
  self.layer.borderWidth = 0.5;
  self.layer.borderColor = lineColor.CGColor;
}

// 添加圆角
- (void)addCornorRadius {
    [self layoutIfNeeded];
    // 添加圆角
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:self.bounds.size];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    //设置大小
    maskLayer.frame = self.bounds;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)addCornorWithRadius:(CGFloat)radius {
    [self layoutIfNeeded];
    // 添加圆角
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radius, radius)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    //设置大小
    maskLayer.frame = self.bounds;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)addTopCornorRadius:(CGFloat)radius {
    [self layoutIfNeeded];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)addBottomCornorRadius:(CGFloat)radius {
    [self layoutIfNeeded];

    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)addRightCornorRadius:(CGFloat)radius {
   [self layoutIfNeeded];
   
   UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerBottomRight | UIRectCornerTopRight cornerRadii:CGSizeMake(radius, radius)];
   CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
   maskLayer.frame = self.bounds;
   maskLayer.path = maskPath.CGPath;
   self.layer.mask = maskLayer;
}

- (void)bc_addTarget:(id)target action:(SEL)action{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:tap];
}


@end
