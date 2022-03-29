//
//  BCAlterTipViewController.m
//  BcExamApp
//
//  Created by beichen on 2021/11/30.
//  Copyright © 2021 apple. All rights reserved.
//

#import "BCAlterTipViewController.h"

@interface BCAlterTipViewController ()
@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UIButton *closelBut;
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UILabel *subTitleLab;
@property (nonatomic,strong) UILabel *contentLab;
@property (nonatomic,strong) UIButton *sureBut;

@property (nonatomic,copy) NSString *titleStr;
@property (nonatomic,strong) NSString *subTitle;
@property (nonatomic,copy) NSString *content;
///确认按钮标题
@property (nonatomic,copy) NSString *sureTitle;
@property (nonatomic,copy) AlterTipHandleBlock handleBlock;
@end

@implementation BCAlterTipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [BCHexColor(@"#000000") colorWithAlphaComponent:0.5];
    [self.view addSubview:self.contentView];
    [self.contentView addSubview:self.closelBut];
    [self.contentView addSubview:self.titleLab];
    [self.contentView addSubview:self.subTitleLab];
    [self.contentView addSubview:self.contentLab];
    [self.contentView addSubview:self.sureBut];

    self.titleLab.text = self.titleStr;
    self.titleLab.hidden = self.titleLab.text.length==0;
    self.subTitleLab.text = self.subTitle;
    self.subTitleLab.hidden = self.subTitleLab.text.length==0;
    self.contentLab.text = self.content;
    [self.sureBut setTitle:self.sureTitle forState:UIControlStateNormal];
    
    if (self.titleLab.text.length==0 && self.subTitleLab.text.length==0) {
        self.contentLab.textColor = BCHexColor(@"#1A1A1A");
        self.contentLab.font = BCBoldFont(15);
        self.sureBut.titleLabel.font = BCFont(14);
    }

    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(260);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(self.view.mas_centerY);
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
    [self.subTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLab.mas_bottom).offset(20);
        make.height.mas_equalTo(self.subTitleLab.font.pointSize);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
    }];
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        if (self.titleLab.hidden && self.subTitleLab.hidden) {
            make.top.mas_equalTo(self.titleLab.mas_bottom);
        }else{
            if (self.subTitleLab.hidden) {
                make.top.mas_equalTo(self.titleLab.mas_bottom).offset(20);
            }else{
                make.top.mas_equalTo(self.subTitleLab.mas_bottom).offset(7);
            }
        }
    }];
    
    [self.sureBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentLab.mas_bottom).offset(15);
        if (self.titleLab.hidden && self.subTitleLab.hidden){
            make.size.mas_equalTo(CGSizeMake(125, 36));
        }else{
            make.size.mas_equalTo(CGSizeMake(80, 32));
        }
        make.centerX.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-20);
    }];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.sureBut.layer.cornerRadius = 5.0;
    self.sureBut.layer.masksToBounds = YES;
}

- (void)sureAction{
    if (self.handleBlock) {
        self.handleBlock();
    }
    [self cancelAction];
}

- (void)cancelAction{
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

- (UILabel *)subTitleLab{
    if (!_subTitleLab) {
        _subTitleLab =[UILabel new];
        _subTitleLab.textColor = BCHexColor(@"#1A1A1A");
        _subTitleLab.font = BCFont(14);
        _subTitleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _subTitleLab;
}

- (UILabel *)contentLab{
    if (!_contentLab) {
        _contentLab = [UILabel new];
        _contentLab.font = BCFont(13);
        _contentLab.textColor = BCHexColor(@"#999999");
        _contentLab.textAlignment = NSTextAlignmentCenter;
        _contentLab.numberOfLines = 0;
        _contentLab.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _contentLab;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [[touches allObjects] firstObject];
    if (touch.view == self.view) {
        [self cancelAction];
    }
}

#pragma mark - - Public method

+ (void)showTipAlter:(UIViewController*)weakSelf title:(NSString *)title subTitle:(NSString *)subTitle message:(NSString *)message sureTitle:(NSString *)sureTitle handleBlock:(AlterTipHandleBlock)block{
    BCAlterTipViewController *vc = [BCAlterTipViewController new];
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    vc.titleStr = title;
    vc.subTitle = subTitle;
    vc.content = message;
    vc.sureTitle = sureTitle;
    vc.handleBlock = block;
    [weakSelf presentViewController:vc animated:YES completion:nil];
}

@end
