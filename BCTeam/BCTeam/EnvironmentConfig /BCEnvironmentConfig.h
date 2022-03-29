//
//  BCEnvironmentConfig.h
//  BcExamApp
//
//  Created by beichen on 2021/12/13.
//  Copyright © 2021 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *环境配置
 */

///api base url key
static NSString *BCEnvironmentConfigApiKey = @"bc_environment_config_api_key";

///push key
static NSString *BCEnvironmentConfigPushKey = @"bc_environment_config_push_key";

@interface BCEnvironmentConfig : NSObject

/**
 *获取配置的api baseURL
 */
+ (NSString *)baseURLString;

/**
 *获取指定环境的api baseURL
 */
+ (NSString *)getBaseUrl:(BOOL)isTest;

/**
 *获取推送环境配置，是否为生产环境
 */
+ (BOOL)getPushEnv;

@end

