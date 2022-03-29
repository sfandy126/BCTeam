//
//  BCTabBar.m
//  CocoaPodsTest
//
//  Created by apple on 2019/11/29.
//  Copyright © 2019 apple. All rights reserved.
//

#import "BCTabBar.h"

@interface BCTabBar ()

@end

@implementation BCTabBar

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self config];
        //兼容iphone12 UITabBar选中时多了一层imageview
        self.tintColor = [UIColor clearColor];
        //适配iOS13以下顶部多了线条
        self.shadowImage = [UIImage imageWithColor:[UIColor whiteColor]];
        self.translucent = NO;
    }
    return self;
}

- (void)config{

}

- (void)layoutSubviews{
    [super layoutSubviews];
}

@end
