//
//  BCNavigationBar.m
//  BcExamApp
//
//  Created by beichen on 2021/10/25.
//  Copyright © 2021 apple. All rights reserved.
//

#import "BCNavigationBar.h"
#import "UINavigationBar+BCAdd.h"

@interface BCNavigationBar ()
@property (nonatomic, strong) UINavigationItem *navigationItem;
@property (nonatomic, strong) UIBarButtonItem *leftButton;
@property (nonatomic, strong) UIBarButtonItem *rightButton;
@property (nonatomic, strong) UIBarButtonItem *rightOhterButton;
@property (nonatomic, strong) UILabel *nameLab;
@end

@implementation BCNavigationBar

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup{
    self.frame = CGRectMake(0, 0, BCScreenWidth, BCNaviHeight);
    self.backgroundColor = [UIColor clearColor];
    [self setShadowImage:[[UIImage alloc] init]];
    [self setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(BCScreenWidth, BCNaviHeight)] forBarMetrics:UIBarMetricsDefault];
    
    self.nameLab.text = @"";
    self.navigationItem = [[UINavigationItem alloc] init];
    [self pushNavigationItem:_navigationItem animated:NO];
    
    [self setNavigationBarAlpha:0];
}

- (void)setLeftItemImage:(NSString *)ImageName target:(id)target action:(SEL)action {
    self.leftButton = [[UIBarButtonItem alloc] initWithImage:nil style:UIBarButtonItemStylePlain target:target action:action];
    [_leftButton setImage:[UIImage imageNamed:ImageName]];
    _leftButton.tintColor = BCHexColor(@"#222222");
    [_navigationItem setLeftBarButtonItem:_leftButton];
}

- (void)setRightItemImage:(NSString *)ImageName target:(id)target action:(SEL)action {
    self.rightButton = [[UIBarButtonItem alloc] initWithImage:nil style:UIBarButtonItemStylePlain target:target action:action];
    [_rightButton setImage:[UIImage imageNamed:ImageName]];
    _rightButton.tintColor = BCHexColor(@"#222222");
    [_navigationItem setRightBarButtonItem:_rightButton];
}


- (void)setRightItemsImages:(NSArray *)imageNames  target:(id)target action:(SEL)action  ohterAction:(SEL)otherAction{
    self.rightButton = [[UIBarButtonItem alloc] initWithImage:nil style:UIBarButtonItemStylePlain target:target action:action];
    [_rightButton setImage:[UIImage imageNamed:[NSString stringValue:[imageNames firstObject]]]];
    _rightButton.tintColor = BCHexColor(@"#5B5B5B");
    
    self.rightOhterButton = [[UIBarButtonItem alloc] initWithImage:nil style:UIBarButtonItemStylePlain target:target action:otherAction];
    [_rightOhterButton setImage:[UIImage imageNamed:[NSString stringValue:[imageNames objectAtIndexSafe:1]]]];
    _rightOhterButton.tintColor = BCHexColor(@"#5B5B5B");
    
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    
    [_navigationItem setRightBarButtonItems:@[_rightButton,_rightOhterButton,spaceItem]];
}

- (void)setLeftItem:(NSString *)name target:(id)target tintColor:(UIColor*)color  action:(SEL)action{
    self.leftButton = [[UIBarButtonItem alloc] initWithTitle:name style:UIBarButtonItemStylePlain target:target action:action];
    _leftButton.tintColor = color;
    [_navigationItem setLeftBarButtonItem:_leftButton];
}

- (void)setRightItem:(NSString *)name target:(id)target tintColor:(UIColor*)color  action:(SEL)action {
    self.rightButton = [[UIBarButtonItem alloc] initWithTitle:name style:UIBarButtonItemStylePlain target:target action:action];
    _rightButton.tintColor = color;
    [_navigationItem setRightBarButtonItem:_rightButton];
}


- (void)setRightItemWithFontOfSize:(UIFont *)font {
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil] forState:UIControlStateNormal];
}

- (UILabel *)nameLab {
    if (_nameLab == nil) {
        _nameLab = [[UILabel alloc] initWithFrame:CGRectMake(0, self.height - 44, self.width - 100, 44)];
        _nameLab.textAlignment = NSTextAlignmentCenter;
        _nameLab.font = [UIFont systemFontOfSize:19];
        _nameLab.textColor = [UIColor whiteColor];
        _nameLab.centerX = self.width * 0.5;
        [self addSubview:_nameLab];
    }
    return _nameLab;
}

- (void)setTitle:(NSString *)title {
    _nameLab.text = title;
}

- (void)setTitleHidden:(BOOL)hidden {
    _nameLab.hidden = hidden;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"_UINavigationBarContentView")]) {
            view.top = [UIApplication sharedApplication].statusBarFrame.size.height;
        } else if ([view isKindOfClass:NSClassFromString(@"_UIBarBackground")]) {
            view.frame = self.bounds;
        }
    }
    [self setNavigationBarAlpha:self.naviAlpha];
}

- (void)setOffsetY:(CGFloat)offsetY alphaBlock:(void(^)(CGFloat alpha))alphaBlock {
    
    CGFloat alpha = 0;
    if (offsetY > 50) {
        alpha = MIN(1, 1 - ((50 + self.height - offsetY) / self.height));
        
        [self setNavigationBarAlpha:alpha];
    }
    else {
        [self setNavigationBarAlpha:alpha];
    }
    self.naviAlpha = alpha;
    if (alphaBlock) {
        alphaBlock(alpha);
    }
    [self setNavigaionBarItemsAlpha:alpha];
}

/**
 ** 根据alpha值设置right left title的相对颜色值
 **/
- (void)setNavigaionBarItemsAlpha:(CGFloat)alpha {
    UIColor* colorAlpha;
    
    if (alpha > 0) {
        colorAlpha = BCHexColor(@"#222222");
    }
    else {
        colorAlpha = BCHexColor(@"#ffffff");
    }
    _leftButton.tintColor = colorAlpha;
    _rightButton.tintColor = colorAlpha;
    _rightOhterButton.tintColor = colorAlpha;
    _nameLab.textColor = colorAlpha;
}

- (void)updataNavigationAlpha:(CGFloat)alpha {
    self.naviAlpha = alpha;
    [self setNavigationBarAlpha:alpha];
    [self setNavigaionBarItemsAlpha:alpha];
}

- (void)setRightTintColor:(UIColor *)color{
    _rightButton.tintColor = color;
}

- (void)setLeftTintColor:(UIColor *)color{
    _leftButton.tintColor = color;
}

- (void)setTitleColor:(UIColor *)color{
    _nameLab.textColor = color;
}

- (void)setTitleFont:(UIFont *)font{
    _nameLab.font = font;
}

- (void)setItemsColor:(UIColor *)color {
    _leftButton.tintColor = color;
    _rightButton.tintColor = color;
    _rightOhterButton.tintColor = color;
    _nameLab.textColor = color;
}

- (void)setRightBarButtonItems:(NSArray *)items {
    [_navigationItem setRightBarButtonItems:items];
}

- (void)setRightBarButtonItem:(UIBarButtonItem *)item {
    [_navigationItem setRightBarButtonItem:item];
}

- (void)setTitleView:(UIView*)titleView {
    self.navigationItem.titleView = titleView;
    
    if (_nameLab) {
        [_nameLab removeFromSuperview];
        _nameLab  = nil;
    }
}

- (void)setTitleAlpha:(CGFloat)alpha {
    _nameLab.alpha = alpha;
}


@end
