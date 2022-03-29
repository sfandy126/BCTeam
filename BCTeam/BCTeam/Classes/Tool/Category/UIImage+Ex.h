//
//  UIImage+Ex.h
//  BcExamApp
//
//  Created by apple on 2019/12/16.
//  Copyright © 2019 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,BCGradientType){
    BCGradientTypeTopToBottom,//从上到下
    BCGradientTypeLeftToRight,//从左到右
    BCGradientTypeUpleftToLowright,//左上到右下
    BCGradientTypeUprightToLowleft,//右上到左下
};

@interface UIImage (Ex)

- (UIImage *)fixOrientation;

+ (UIImage *)gradientColorImageFromColors:(NSArray<UIColor *> *)colors gradientType:(BCGradientType)gradientType imgSize:(CGSize)imgSize;

/*
 *压缩图片
 *image 原始图片
 *maxLength 压缩至最大kb
 */
+ (UIImage *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength;

@end

