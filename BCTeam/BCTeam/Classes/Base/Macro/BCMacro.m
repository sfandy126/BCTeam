//
//  BCMacro.m
//  BCTeam
//
//  Created by beichen on 2022/3/28.
//

#import "BCMacro.h"

@implementation BCMacro

+ (CGFloat)scale:(CGFloat)x{
    CGFloat width = (BC_IS_IPHONE ? 375 : 580);
    CGFloat ratio = BCScreenWidth / width;
    return ceilf(x*ratio);
}

@end
