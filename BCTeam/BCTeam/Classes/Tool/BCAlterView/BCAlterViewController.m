//
//  BCAlterViewController.m
//  BcExamApp
//
//  Created by beichen on 2021/11/29.
//  Copyright © 2021 apple. All rights reserved.
//

#import "BCAlterViewController.h"

@interface BCAlterViewController ()
@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UIButton *sureBut;
@property (nonatomic,strong) UIButton *cancelBut;
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UILabel *contentLab;

@property (nonatomic,copy) NSString *titleStr;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSArray *butTitles;
@property (nonatomic,copy) AlterHandleBlock handleBlock;
@end

@implementation BCAlterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [BCHexColor(@"#000000") colorWithAlphaComponent:0.5];
    [self.view addSubview:self.contentView];
    [self.contentView addSubview:self.sureBut];
    [self.contentView addSubview:self.cancelBut];
    [self.contentView addSubview:self.titleLab];
    [self.contentView addSubview:self.contentLab];

    if (self.butTitles.count>=2) {
        [self.cancelBut setTitle:[self.butTitles firstObject] forState:UIControlStateNormal];
        [self.sureBut setTitle:[self.butTitles lastObject] forState:UIControlStateNormal];
    }else{
        [self.sureBut setTitle:[self.butTitles firstObject] forState:UIControlStateNormal];
    }

    self.titleLab.text = self.titleStr;
    self.titleLab.hidden = self.titleLab.text.length==0;
    self.contentLab.text = self.content;
    if (self.titleLab.hidden) {
        self.contentLab.font = BCBoldFont(14);
    }
    if (self.contentLab.text.length>0) {
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:self.contentLab.text];
        NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
        style.lineSpacing = 5;
        [attri addAttributes:@{NSParagraphStyleAttributeName:style} range:NSMakeRange(0, attri.length)];
        self.contentLab.attributedText = [attri copy];
        self.contentLab.textAlignment = NSTextAlignmentCenter;
    }

    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(250);
        make.height.mas_greaterThanOrEqualTo(140);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(self.view.mas_centerY);
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(25);
        make.height.mas_equalTo(self.titleLab.font.pointSize);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
    }];
    
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-20);
        if (self.titleLab.hidden) {
            make.top.mas_equalTo(25);
        }else{
            make.top.mas_equalTo(self.titleLab.mas_bottom).offset(10);
        }
    }];
    
    if (self.butTitles.count>=2) {
        [self.cancelBut mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentLab.mas_bottom).offset(20);
            make.height.mas_equalTo(36);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(self.contentView.mas_centerX);
            make.bottom.mas_equalTo(self.contentView.mas_bottom);
        }];
        
        [self.sureBut mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.cancelBut.mas_top);
            make.height.mas_equalTo(self.cancelBut.mas_height);
            make.left.mas_equalTo(self.cancelBut.mas_right);
            make.right.mas_equalTo(self.contentView.mas_right);
            make.bottom.mas_equalTo(self.contentView.mas_bottom);
        }];
    }else{
        self.sureBut.layer.cornerRadius = 36/2.0;
        self.sureBut.layer.masksToBounds = YES;
        [self.sureBut mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentLab.mas_bottom).offset(20);
            make.height.mas_equalTo(36);
            make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(0.5);
            make.centerX.mas_equalTo(self.contentView.mas_centerX);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-15);
        }];
    }
 
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];

}

- (void)sureAction{
    [self dismiss];
    if (self.handleBlock) {
        self.handleBlock(1);
    }
}

- (void)cancelAction{
    [self dismiss];
    if (self.handleBlock) {
        self.handleBlock(0);
    }
}

- (void)dismiss{
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
        _sureBut.titleLabel.font = BCFont(14);
        [_sureBut addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBut;
}

- (UIButton *)cancelBut{
    if (!_cancelBut) {
        _cancelBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBut.backgroundColor = BCHexColor(@"#E8E8E8");
        [_cancelBut setTitleColor:BCHexColor(@"#1A1A1A") forState:UIControlStateNormal];
        _cancelBut.titleLabel.font = BCFont(14);
        [_cancelBut setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBut addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBut;
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab =[UILabel new];
        _titleLab.textColor = BCHexColor(@"#1A1A1A");
        _titleLab.font = BCBoldFont(15);
    }
    return _titleLab;
}

- (UILabel *)contentLab{
    if (!_contentLab) {
        _contentLab = [UILabel new];
        _contentLab.backgroundColor = UIColor.clearColor;
        _contentLab.font = BCFont(13);
        _contentLab.textColor = BCHexColor(@"#323232");
        _contentLab.lineBreakMode = NSLineBreakByTruncatingTail;
        _contentLab.numberOfLines = 0;
        _contentLab.textAlignment = NSTextAlignmentCenter;
    }
    return _contentLab;
}

#pragma mark - - Public method

+ (BCAlterViewController *)showAlter:(UIViewController*)weakSelf title:(NSString *)title message:(NSString *)message butTitles:(NSArray *)butTitles handleBlock:(AlterHandleBlock)block{
    BCAlterViewController *vc = [BCAlterViewController new];
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    vc.titleStr = title;
    vc.content = message;
    vc.butTitles = butTitles;
    vc.handleBlock = block;
    if (weakSelf) {
        [weakSelf presentViewController:vc animated:YES completion:nil];
    }else{
        UIWindow *window = [UIApplication sharedApplication].delegate.window;
        if (!window) {
            window = [UIApplication sharedApplication].keyWindow;
        }
        [window.rootViewController presentViewController:vc animated:YES completion:nil];
    }
    return vc;
}

@end
