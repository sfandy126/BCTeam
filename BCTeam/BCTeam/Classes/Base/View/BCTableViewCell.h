//
//  BCTableViewCell.h
//  BcExamApp
//
//  Created by beichen on 2021/12/13.
//  Copyright © 2021 apple. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BCTableViewCell : UITableViewCell
/**
 *分割线，默认为底部分割线，可自行修改约束
 */
@property (nonatomic,strong,readonly) UIView *sepLine;

/**
 *是否隐藏分割线
 */
@property (nonatomic,assign) BOOL isHideSepLine;

/**
 *子类自定义cell
 */
- (void)setup;

@end

