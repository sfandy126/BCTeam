//
//  BCTextField.h
//  BcExamApp
//
//  Created by beichen on 2022/2/15.
//  Copyright © 2022 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BCTextField : UITextField
/**
 是否限制输入表情，默认不限制NO
 */
@property (nonatomic,assign) BOOL isLimitEmoji;
/**
 最大输入长度，默认为-1，不限制
 */
@property (nonatomic,assign) NSInteger maxInputLength;
/**
 限制提示语，默认为空，不提示
 */
@property (nonatomic,copy) NSString *tipLimit;

@end

