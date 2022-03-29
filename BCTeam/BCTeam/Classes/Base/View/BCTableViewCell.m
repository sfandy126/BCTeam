//
//  BCTableViewCell.m
//  BcExamApp
//
//  Created by beichen on 2021/12/13.
//  Copyright © 2021 apple. All rights reserved.
//

#import "BCTableViewCell.h"

@interface BCTableViewCell ()
@property (nonatomic,strong) UIView *sepLine;
@end

@implementation BCTableViewCell

- (UIView *)sepLine{
    if (!_sepLine) {
        _sepLine = [UIView new];
        _sepLine.backgroundColor = BCHexColor(@"#F6F6F6");
    }
    return _sepLine;
}

- (void)setIsHideSepLine:(BOOL)isHideSepLine{
    _isHideSepLine = isHideSepLine;
    self.sepLine.hidden = isHideSepLine;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.sepLine];
        [self setup];
    }
    return self;
}

- (void)setup{
    [self.sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.left.mas_equalTo(BCScale(15));
        make.right.mas_equalTo(self.contentView.mas_right).offset(BCScale(-15));
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
}

@end
