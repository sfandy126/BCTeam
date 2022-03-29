//
//  BCVersionAlterController.m
//  BcExamApp
//
//  Created by beichen on 2021/11/27.
//  Copyright © 2021 apple. All rights reserved.
//

#import "BCVersionAlterController.h"

@interface BCVersionAlterController ()
@property (nonatomic,strong) UIImageView *contentView;
@property (nonatomic,strong) UIButton *sureBut;
@property (nonatomic,strong) UIButton *cancelBut;
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UITextView *textView;

@end

@implementation BCVersionAlterController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [BCHexColor(@"#000000") colorWithAlphaComponent:0.5];
    [self.view addSubview:self.contentView];
    [self.contentView addSubview:self.sureBut];
    [self.contentView addSubview:self.cancelBut];
    [self.contentView addSubview:self.titleLab];
    [self.contentView addSubview:self.textView];

    [self.sureBut setTitle:self.sureTitle forState:UIControlStateNormal];
    self.titleLab.text = self.titleStr;
    self.textView.text = self.content;
    self.cancelBut.hidden = self.isForce;

    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(250, 308));
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(self.view.mas_centerY);
    }];
    
    [self.cancelBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(90, 30));
        make.left.mas_equalTo(20);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-20);
    }];
    
    [self.sureBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(90, 30));
        if (self.cancelBut.hidden) {
            make.centerX.mas_equalTo(self.contentView);
        }else{
            make.right.mas_equalTo(self.contentView.mas_right).offset(-20);
        }
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-20);
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(110);
        make.height.mas_equalTo(self.titleLab.font.pointSize);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
    }];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-20);
        make.top.mas_equalTo(self.titleLab.mas_bottom).offset(10);
        make.bottom.mas_equalTo(self.sureBut.mas_top).offset(-20);
    }];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.cancelBut.layer.cornerRadius = self.cancelBut.height/2.0;
    self.cancelBut.layer.masksToBounds = YES;
    self.sureBut.layer.cornerRadius = self.sureBut.height/2.0;
    self.sureBut.layer.masksToBounds = YES;
}

- (void)sureAction{
    NSURL *URL = [NSURL URLWithString:self.url];
    if ([[UIApplication sharedApplication] canOpenURL:URL]) {
        [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:nil];
    }
}

- (void)cancelAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImageView *)contentView{
    if (!_contentView) {
        _contentView = [UIImageView new];
        _contentView.image = [UIImage imageNamed:@"bc_alter_version_bg_icon"];
        _contentView.userInteractionEnabled = YES;
    }
    return _contentView;
}

- (UIButton *)sureBut{
    if (!_sureBut) {
        _sureBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureBut.backgroundColor = BCHexColor(@"#FE5922");
        [_sureBut setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _sureBut.titleLabel.font = BCFont(13);
        [_sureBut addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBut;
}

- (UIButton *)cancelBut{
    if (!_cancelBut) {
        _cancelBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBut.backgroundColor = UIColor.whiteColor;
        [_cancelBut setTitleColor:BCHexColor(@"#FE5922") forState:UIControlStateNormal];
        _cancelBut.titleLabel.font = BCFont(13);
        [_cancelBut setTitle:@"稍后" forState:UIControlStateNormal];
        _cancelBut.layer.borderWidth = 1.0;
        _cancelBut.layer.borderColor = BCHexColor(@"#FE5922").CGColor;
        [_cancelBut addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBut;
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab =[UILabel new];
        _titleLab.textColor = BCHexColor(@"#1A1A1A");
        _titleLab.font = BCBoldFont(16);
    }
    return _titleLab;
}

- (UITextView *)textView{
    if (!_textView) {
        _textView = [UITextView new];
        _textView.backgroundColor = UIColor.clearColor;
        _textView.showsVerticalScrollIndicator = NO;
        _textView.showsHorizontalScrollIndicator = NO;
        _textView.font = BCFont(15);
        _textView.textColor = BCHexColor(@"#1A1A1A");
//        _textView.textAlignment = NSTextAlignmentCenter;
        _textView.editable = NO;
        _textView.selectable = NO;
        _textView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return _textView;
}

#pragma mark - - Public method

+ (void)showVersionAlter:(UIViewController*)weakSelf parmas:(NSDictionary *)dict {
    BCVersionAlterController *vc = [BCVersionAlterController new];
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    vc.isForce = [[NSString stringValue:dict[@"is_coerce"]] integerValue] ==1;
    vc.titleStr = [NSString stringValue:dict[@"title"]];
    vc.content = [NSString stringValue:dict[@"content"]];
    vc.sureTitle = [NSString stringValue:dict[@"button_title"]];
    vc.url = [NSString stringValue:dict[@"download_url"]];
    [weakSelf presentViewController:vc animated:YES completion:nil];
}

@end
