//
//  UIButton+touchArea.h
//  BcExamApp
//
//  Created by beichen on 2021/10/15.
//  Copyright © 2021 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (touchArea)

///扩大按钮响应区域
- (void)setEnlargeEdge:(CGFloat) size;

///扩大按钮响应区域
- (void)setEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left;

@end

NS_ASSUME_NONNULL_END
