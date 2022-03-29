//
//  UIDevice+BCAdd.h
//  BcExamApp
//
//  Created by beichen on 2022/3/2.
//  Copyright © 2022 apple. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIDevice (BCAdd)

/**
 *获取网络ip地址
 *优先获取wifi_ip,其次获取wwan_ip
 */
- (NSString *)getIPAddress;

@end

