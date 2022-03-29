//
//  UINavigationBar+BCAdd.m
//  BcExamApp
//
//  Created by beichen on 2021/10/25.
//  Copyright © 2021 apple. All rights reserved.
//

#import "UINavigationBar+BCAdd.h"

@implementation UINavigationBar (BCAdd)

- (void)setNavigationBarAlpha:(CGFloat)alpha {
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")] || [view isKindOfClass:NSClassFromString(@"_UIBarBackground")]) {
            view.alpha = alpha;
        }
    }
}

@end
