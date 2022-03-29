//
//  BCSearchTextField.h
//  BcExamApp
//
//  Created by beichen on 2021/11/23.
//  Copyright © 2021 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BCSearchTextField : UIView
@property (nonatomic,copy) NSString *placeholder;
///是否可以编辑，默认为YES
@property (nonatomic,assign) BOOL canEidt;
///点击回调 canEidt = NO时才会触发
@property (nonatomic,copy) void(^tapBlock)(void);

@end
