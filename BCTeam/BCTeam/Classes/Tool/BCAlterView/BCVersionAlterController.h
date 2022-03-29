//
//  BCVersionAlterController.h
//  BcExamApp
//
//  Created by beichen on 2021/11/27.
//  Copyright © 2021 apple. All rights reserved.
//

#import "BCBaseViewController.h"

@interface BCVersionAlterController : BCBaseViewController
///是否为强制
@property (nonatomic,assign) BOOL isForce;
@property (nonatomic,copy) NSString *titleStr;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *url;
@property (nonatomic,copy) NSString *sureTitle;

+ (void)showVersionAlter:(UIViewController*)weakSelf parmas:(NSDictionary *)dict;

@end

