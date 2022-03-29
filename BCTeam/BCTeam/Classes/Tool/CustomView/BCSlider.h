//
//  BCSlider.h
//  BcExamApp
//
//  Created by beichen on 2021/10/21.
//  Copyright © 2021 apple. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BCSlider : UISlider
///背后导轨的高度，默认为 0，表示使用系统默认的高度。
@property (nonatomic,assign) CGFloat trackHeight;
///滑块的rect
@property (nonatomic,assign) CGRect thumbRect;
@end

