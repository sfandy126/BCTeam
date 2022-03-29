//
//  BCSearchTextField.m
//  BcExamApp
//
//  Created by beichen on 2021/11/23.
//  Copyright © 2021 apple. All rights reserved.
//

#import "BCSearchTextField.h"

@interface BCSearchTextField ()<UITextFieldDelegate>
@property (nonatomic,strong) UIImageView *icon;
@property (nonatomic,strong) UIView *sepLine;
@property (nonatomic,strong) UITextField *textField;
@end

@implementation BCSearchTextField

- (UIImageView *)icon{
    if (!_icon) {
        _icon = [UIImageView new];
    }
    return _icon;
}

- (UIView *)sepLine{
    if (!_sepLine) {
        _sepLine = [UIView new];
        _sepLine.backgroundColor = BCHexColor(@"#B8B8B8");
    }
    return _sepLine;
}

- (UITextField *)textField{
    if (!_textField) {
        _textField = [UITextField new];
        _textField.backgroundColor = UIColor.clearColor;
        _textField.delegate = self;
        _textField.font = BCFont(13);
        _textField.textColor = BCHexColor(@"#B8B8B8");
        _textField.returnKeyType = UIReturnKeySearch;
        _textField.tintColor = BCHexColor(@"#FE5922");
    }
    return _textField;
}

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
        [self defaultConfig];
    }
    return self;
}

- (void)setup{
    [self addSubview:self.icon];
    [self addSubview:self.sepLine];
    [self addSubview:self.textField];
    
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(12, 12));
        make.centerY.mas_equalTo(self);
    }];
    
    [self.sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.icon.mas_right).offset(6);
        make.size.mas_equalTo(CGSizeMake(1, 10));
        make.centerY.mas_equalTo(self);
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.sepLine.mas_right).offset(6);
        make.height.mas_equalTo(self.mas_height);
        make.right.mas_equalTo(self.mas_right);
        make.top.mas_equalTo(0);
    }];
}

- (void)defaultConfig{
    self.backgroundColor = BCHexColor(@"#F3F3F3");
    self.icon.image = [UIImage imageNamed:@"搜索"];
    self.canEidt = YES;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.layer.cornerRadius = self.height/2.0;
    self.layer.masksToBounds = YES;
}

- (void)tapAction{
    if (self.tapBlock) {
        self.tapBlock();
    }
}

#pragma mark - - setter

- (void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    self.textField.placeholder = placeholder;
}

- (void)setCanEidt:(BOOL)canEidt{
    _canEidt = canEidt;
    self.textField.enabled = canEidt;
    if (canEidt) {
        [self bc_addTarget:self action:@selector(tapAction)];
    }
}

#pragma mark - - UISearchBarDelegate



@end
