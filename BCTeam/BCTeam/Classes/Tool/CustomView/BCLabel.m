//
//  BCLabel.m
//  BcExamApp
//
//  Created by beichen on 2021/11/30.
//  Copyright © 2021 apple. All rights reserved.
//

#import "BCLabel.h"
static NSString * scrollAnimation = @"scrollAnimation";

@interface BCLabel ()
@property (nonatomic,strong) CATextLayer *textLayer;
@end

@implementation BCLabel


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self setup];
}

- (void)setup{
    self.textInset = UIEdgeInsetsZero;
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themesChangeNotification) name:DKNightVersionThemeChangingNotification object:nil];
}

//- (void)themesChangeNotification{
//    if (self.textLayer) {
//        if ([DKNightVersionManager sharedManager].themeVersion ==DKThemeVersionNight) {
//            self.textLayer.foregroundColor = BCHexColor(@"#B5B5B5").CGColor;
//        }else{
//            self.textLayer.foregroundColor = self.textColor.CGColor;
//        }
//    }
//
//}

- (void)drawTextInRect: (CGRect)rect {
    BOOL shouldScroll = [self shouldAutoScroll];
    if (!self.isAutoScroll || !shouldScroll) {
        //开启了不显示text,只显示layer上的text
        [super drawTextInRect: UIEdgeInsetsInsetRect(rect, self.textInset)];
    }
}

- (CGSize)intrinsicContentSize{
    CGSize size = [super intrinsicContentSize];
    size.width+= self.textInset.left + self.textInset.right;
    size.height+= self.textInset.top + self.textInset.bottom;
    return size;
}

- (void)startScrollAnimation{
    if (self.hidden) {
        return;
    }
    self.layer.masksToBounds = true;
    BOOL shouldScroll = [self shouldAutoScroll];
    if (shouldScroll){
        CABasicAnimation * ani = [self getAnimation];
        [self.textLayer addAnimation:ani forKey:nil];
        [self.layer addSublayer:self.textLayer];
    }else{
        [self.textLayer removeAllAnimations];
        [self.textLayer removeFromSuperlayer];
    }
}

- (CATextLayer *)textLayer
{
    if (!_textLayer) {
        _textLayer = [CATextLayer layer];
    }
    CGSize size = [self.text sizeWithAttributes:@{NSFontAttributeName:self.font}];
    CGFloat stringWidth = size.width;
    _textLayer.frame = CGRectMake(0, 0, stringWidth, self.frame.size.height);
    _textLayer.alignmentMode = kCAAlignmentCenter;
    _textLayer.font = (__bridge CFTypeRef _Nullable)(self.font.fontName);
    _textLayer.fontSize = self.font.pointSize;
    _textLayer.foregroundColor = self.textColor.CGColor;
    _textLayer.string = self.text;
    // 不写这句可能导致layer的文字在某些情况下不清晰
    _textLayer.contentsScale = [UIScreen mainScreen].scale;
    return _textLayer;
}

- (CABasicAnimation *)getAnimation
{
    CABasicAnimation * ani = objc_getAssociatedObject(self, &scrollAnimation);
    if (!ani) {
        ani = [CABasicAnimation animationWithKeyPath:@"position.x"];
        objc_setAssociatedObject(self, &scrollAnimation, ani, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    CGPoint point = self.textLayer.position;
    CGFloat lenth = self.textLayer.frame.size.width - self.frame.size.width;
    // 起点位置
    CGPoint pointSrc = CGPointMake(point.x + 20, point.y);
    // 终点位置
    CGPoint pointDes = CGPointMake(pointSrc.x - lenth - 30, pointSrc.y);
    id toValue = [NSValue valueWithCGPoint:pointDes];
    id fromValue = [NSValue valueWithCGPoint:pointSrc];
    ani.toValue = toValue;
    ani.fromValue = fromValue;
    if (self.duration>0) {
        ani.duration = self.duration;
    }else{
        ani.duration = self.text.length*0.25;
    }
    ani.fillMode = kCAFillModeBoth;
    ani.repeatCount = HUGE_VALF;
    // 结束后逆向执行动画
    ani.autoreverses = NO;
    ani.removedOnCompletion = false;
    return ani;
}

/// 判断是否需要滚动
- (BOOL)shouldAutoScroll
{
    BOOL shouldScroll = false;
    if (self.numberOfLines == 1) {
        CGSize size = [self.text sizeWithAttributes:@{NSFontAttributeName:self.font}];
        CGFloat stringWidth = size.width;
        CGFloat labelWidth = self.frame.size.width;
        if (labelWidth < stringWidth) {
            shouldScroll = true;
        }
    }
    
    Class ModelClass = NSClassFromString(@"_UIAlertControllerActionView");
    if ([self.superview.superview isKindOfClass:ModelClass]) {
        shouldScroll = false;
    }
    
    return shouldScroll;
}



@end
