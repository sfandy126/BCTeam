//
//  BCTextField.m
//  BcExamApp
//
//  Created by beichen on 2022/2/15.
//  Copyright © 2022 apple. All rights reserved.
//

#import "BCTextField.h"

@interface BCTextField ()<UITextFieldDelegate>

@end

@implementation BCTextField

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self defaultConfig];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self defaultConfig];
    }
    return self;
}

- (void)defaultConfig{
    self.delegate = self;
    self.maxInputLength = -1;
}

- (void)setMaxInputLength:(NSInteger)maxInputLength{
    _maxInputLength = maxInputLength;
    if (maxInputLength>0) {
        [self addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
 
    return YES;
}

- (void)textFieldEditChanged:(UITextField *)textField{
    
    [self textFieldEditChanged:textField withMaxLength:self.maxInputLength];
}

- (void)textFieldEditChanged:(UITextField *)textField withMaxLength:(NSInteger)maxlength{
    NSString *toBeString = textField.text;
    if (self.isLimitEmoji) {
        // 禁止系统表情的输入
        NSString *text = [self disable_emoji:toBeString];
        if (![text isEqualToString:toBeString]) {
            textField.text = text;
        }
    }
    NSString *lang = [[self.nextResponder textInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > maxlength) {
                textField.text = [toBeString substringToIndex:maxlength];
                textField.text = [textField.text substringToIndex:maxlength];
                if (self.tipLimit.length>0) {
                    [MBProgressHUD showMessage:self.tipLimit];
                }
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > maxlength) {
            textField.text = [toBeString substringToIndex:maxlength];
            textField.text = [textField.text substringToIndex:maxlength];
            if (self.tipLimit.length>0) {
                [MBProgressHUD showMessage:self.tipLimit];
            }
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.returnKeyType == UIReturnKeyDone || textField.returnKeyType == UIReturnKeyGo || textField.returnKeyType == UIReturnKeyJoin || textField.returnKeyType == UIReturnKeyNext || textField.returnKeyType == UIReturnKeySearch || textField.returnKeyType == UIReturnKeySend) {
        [textField resignFirstResponder];
    }
    return YES;
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
