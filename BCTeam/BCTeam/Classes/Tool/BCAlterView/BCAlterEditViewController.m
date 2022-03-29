//
//  BCAlterEditViewController.m
//  BcExamApp
//
//  Created by beichen on 2021/11/29.
//  Copyright © 2021 apple. All rights reserved.
//

#import "BCAlterEditViewController.h"

@interface BCAlterEditViewController ()
@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UIButton *closelBut;
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) BCTextField *textField;
@property (nonatomic,strong) UIButton *sureBut;
@property (nonatomic,strong) UILabel *markLab;

@property (nonatomic,copy) NSString *titleStr;
@property (nonatomic,copy) NSString *placeholder;
///确认按钮标题
@property (nonatomic,copy) NSString *sureTitle;
///备注
@property (nonatomic,copy) NSString *remark;
@property (nonatomic,copy) AlterEditHandleBlock handleBlock;
@property (nonatomic,assign) BCAlterEditStyle style;
@end

@implementation BCAlterEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [BCHexColor(@"#000000") colorWithAlphaComponent:0.5];
    [self.view addSubview:self.contentView];
    [self.contentView addSubview:self.closelBut];
    [self.contentView addSubview:self.titleLab];
    [self.contentView addSubview:self.textField];
    [self.contentView addSubview:self.sureBut];
    [self.contentView addSubview:self.markLab];

    self.titleLab.text = self.titleStr;
    self.textField.placeholder = self.placeholder;
    if (self.sureTitle.length>0) {
        [self.sureBut setTitle:self.sureTitle forState:UIControlStateNormal];
    }else{
        [self.sureBut setTitle:@"确认修改" forState:UIControlStateNormal];
    }
    self.markLab.text = self.remark;
    self.markLab.hidden = self.markLab.text.length==0;

    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(260);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(self.view.mas_centerY).offset(-40);
    }];
    
    [self.closelBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(18, 18));
        make.top.mas_equalTo(15);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.height.mas_equalTo(self.titleLab.font.pointSize);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.top.mas_equalTo(self.titleLab.mas_bottom).offset(25);
        make.height.mas_equalTo(36);
    }];
    
    if (self.style == BCAlterEditStyle_alterNick) {
        self.markLab.textAlignment = NSTextAlignmentCenter;
        if (!self.markLab.hidden) {
            [self.markLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.textField.mas_bottom).offset(15);
                make.left.mas_equalTo(self.textField.mas_left);
                make.right.mas_equalTo(self.textField.mas_right);
            }];
        }
        [self.sureBut mas_makeConstraints:^(MASConstraintMaker *make) {
            if (self.markLab.hidden) {
                make.top.mas_equalTo(self.textField.mas_bottom).offset(15);
            }else{
                make.top.mas_equalTo(self.markLab.mas_bottom).offset(15);
            }
            make.size.mas_equalTo(CGSizeMake(80, 32));
            make.centerX.mas_equalTo(self.contentView);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-20);
        }];
    }else{
        self.markLab.textAlignment = NSTextAlignmentLeft;
        [self.sureBut mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.textField.mas_bottom).offset(15);
            make.size.mas_equalTo(CGSizeMake(80, 32));
            make.centerX.mas_equalTo(self.contentView);
            if (self.markLab.hidden) {
                make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-20);
            }
        }];
        
        if (!self.markLab.hidden) {
            [self.markLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.sureBut.mas_bottom).offset(15);
                make.left.mas_equalTo(self.textField.mas_left);
                make.right.mas_equalTo(self.textField.mas_right);
                make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-20);
            }];
        }
    }
    
    if (self.style == BCAlterEditStyle_alterNick) {
        self.textField.isLimitEmoji = YES;
        self.textField.maxInputLength = 10;
    }
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.sureBut.layer.cornerRadius = 5.0;
    self.sureBut.layer.masksToBounds = YES;
}

- (void)sureAction{
    if (self.textField.text.length ==0) {
        [MBProgressHUD showMessage:@"你输入的内容为空"];
        return;
    }
    if (self.style == BCAlterEditStyle_alterNick) {
        //4-20个字符，可由中英文、数字组成
        if (self.textField.text.length<2 || self.textField.text.length>10) {
            [MBProgressHUD showMessage:@"你输入的内容不符合要求"];
            return;
        }
    }
    if (self.handleBlock) {
        self.handleBlock(self.textField.text);
    }
    [self cancelAction];
}

- (void)cancelAction{
    [self.textField resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.backgroundColor = UIColor.whiteColor;
        _contentView.layer.cornerRadius = 10;
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}

- (UIButton *)sureBut{
    if (!_sureBut) {
        _sureBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureBut.backgroundColor = BCHexColor(@"#FE5922");
        [_sureBut setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _sureBut.titleLabel.font = BCFont(12);
        [_sureBut addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBut;
}

- (UIButton *)closelBut{
    if (!_closelBut) {
        _closelBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closelBut setBackgroundImage:[UIImage imageNamed:@"bc_alter_close_icon"] forState:UIControlStateNormal];
        [_closelBut addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closelBut;
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab =[UILabel new];
        _titleLab.textColor = BCHexColor(@"#1A1A1A");
        _titleLab.font = BCBoldFont(15);
    }
    return _titleLab;
}

- (BCTextField *)textField{
    if (!_textField) {
        _textField = [BCTextField new];
        _textField.font = BCFont(12);
        _textField.textColor = BCHexColor(@"#1A1A1A");
        _textField.textAlignment = NSTextAlignmentCenter;
        _textField.layer.borderColor = BCHexColor(@"#999999").CGColor;
        _textField.layer.cornerRadius = 3;
        _textField.layer.borderWidth = 0.5;
        _textField.layer.masksToBounds = YES;
        _textField.tintColor = BCHexColor(@"#FE5922");
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.isLimitEmoji = YES;
    }
    return _textField;
}

- (UILabel *)markLab{
    if (!_markLab) {
        _markLab =[UILabel new];
        _markLab.textColor = BCHexColor(@"#999999");
        _markLab.font = BCFont(12);
        _markLab.numberOfLines = 0;
        _markLab.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _markLab;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [[touches allObjects] firstObject];
    if (touch.view == self.view) {
        [self.textField resignFirstResponder];
        [self cancelAction];
    }
}


#pragma mark - - Public method

+ (void)showEditAlter:(UIViewController*)weakSelf title:(NSString *)title placeholder:(NSString *)placeholder sureTitle:(NSString *)sureTitle remark:(NSString *)remark style:(BCAlterEditStyle )style handleBlock:(AlterEditHandleBlock)block{
    BCAlterEditViewController *vc = [BCAlterEditViewController new];
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    vc.titleStr = title;
    vc.placeholder = placeholder;
    vc.sureTitle = sureTitle;
    vc.remark = remark;
    vc.style = style;
    vc.handleBlock = block;
    [weakSelf presentViewController:vc animated:YES completion:nil];
}

+ (void)showEditAlter:(UIViewController*)weakSelf title:(NSString *)title placeholder:(NSString *)placeholder sureTitle:(NSString *)sureTitle remark:(NSString *)remark handleBlock:(AlterEditHandleBlock)block{
    [[self class] showEditAlter:weakSelf title:title placeholder:placeholder sureTitle:sureTitle remark:remark style:BCAlterEditStyle_deault handleBlock:block];
}

@end
