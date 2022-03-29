//
//  BCTextView.m
//  BcExamApp
//
//  Created by beichen on 2022/2/24.
//  Copyright © 2022 apple. All rights reserved.
//

#import "BCTextView.h"

@interface BCTextView ()<UITextViewDelegate>
@property (nonatomic,strong) UILabel *placeholderLab;
@end

@implementation BCTextView

- (UILabel *)placeholderLab{
    if (!_placeholderLab) {
        _placeholderLab = [UILabel new];
    }
    return _placeholderLab;
}

- (void)setText:(NSString *)text{
    [super setText:text];
    if (self.placeholderLab.text.length>0) {
        self.placeholderLab.hidden = text.length>0;
    }
}

- (void)setPlaceholderText:(NSString *)placeholderText{
    _placeholderText = placeholderText;
    self.placeholderLab.text = placeholderText;
}

- (void)setPlaceholderFont:(UIFont *)placeholderFont{
    _placeholderFont = placeholderFont;
    self.placeholderLab.font = placeholderFont;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor{
    _placeholderColor = placeholderColor;
    self.placeholderLab.textColor = placeholderColor;
}

- (void)setLineSpacing:(NSInteger)lineSpacing{
    _lineSpacing = lineSpacing;
    if (lineSpacing>0) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 5;
        NSDictionary *attributes = @{NSParagraphStyleAttributeName:paragraphStyle};
        self.typingAttributes= attributes;
    }
}

- (void)setTextContainerInset:(UIEdgeInsets)textContainerInset{
    [super setTextContainerInset:textContainerInset];
    [self.placeholderLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.textContainerInset.left+4);
        make.top.mas_equalTo(self.textContainerInset.top);
        make.right.mas_equalTo(self.mas_right).offset(-self.textContainerInset.right);
    }];
}

- (void)setMaxTextCount:(NSInteger)maxTextCount{
    _maxTextCount = maxTextCount;
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
    }
    return self;
}

- (void)setup{
    self.maxTextCount = 1000;
    self.delegate = self;
    [self addSubview:self.placeholderLab];
    [self.placeholderLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.top.mas_equalTo(5);
        make.right.mas_equalTo(self.mas_right).offset(-5);
    }];
}


- (void)textViewDidChange:(UITextView *)textView{
    NSString *toBeString = textView.text;
    if (self.placeholderLab.text.length>0) {
        self.placeholderLab.hidden = toBeString.length>0;
    }
    if (self.isLimitEmoji) {
        // 禁止系统表情的输入
        NSString *text = [self disable_emoji:toBeString];
        if (![text isEqualToString:toBeString]) {
            textView.text = text;
        }
    }
    toBeString = textView.text;
    if (self.maxTextCount>0) {
        NSString *lang = [[self.nextResponder textInputMode] primaryLanguage]; // 键盘输入模式
        if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
            UITextRange *selectedRange = [textView markedTextRange];
            //获取高亮部分
            UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
            // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if (!position) {
                if (toBeString.length > self.maxTextCount) {
                    textView.text = [toBeString substringToIndex:self.maxTextCount];
                }
            }
            // 有高亮选择的字符串，则暂不对文字进行统计和限制
            else{
                
            }
        }
        // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        else{
            if (toBeString.length > self.maxTextCount) {
                textView.text = [toBeString substringToIndex:self.maxTextCount];
            }
        }
    }
    
    if (self.textViewDidChangeBlock) {
        self.textViewDidChangeBlock(textView);
    }
}

- (NSString *)disable_emoji:(NSString *)text{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]"options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text
                                                               options:0
                                                                 range:NSMakeRange(0, [text length])
                                                          withTemplate:@""];
    return modifiedString;
}
@end
