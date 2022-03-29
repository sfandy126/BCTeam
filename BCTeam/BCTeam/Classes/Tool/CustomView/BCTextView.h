//
//  BCTextView.h
//  BcExamApp
//
//  Created by beichen on 2022/2/24.
//  Copyright © 2022 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *子类不能再设置delegate，否则当前类的回调不执行
 */
@interface BCTextView : UITextView
@property (nonatomic,copy) NSString *placeholderText;
@property (nonatomic,strong) UIFont *placeholderFont;
@property (nonatomic,strong) UIColor *placeholderColor;

///设置textview显示的行间距
@property (nonatomic,assign) NSInteger lineSpacing;
///默认为0,不限制
@property (nonatomic,assign) NSInteger maxTextCount;
///是否限制输入表情，默认不限制NO
@property (nonatomic,assign) BOOL isLimitEmoji;

@property (nonatomic,copy) void(^textViewDidChangeBlock)(UITextView *textView);

@end
