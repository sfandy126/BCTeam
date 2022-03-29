//
//  BCEnvironmentConfig.m
//  BcExamApp
//
//  Created by beichen on 2021/12/13.
//  Copyright © 2021 apple. All rights reserved.
//

#import "BCEnvironmentConfig.h"

static __attribute__((unused)) NSString * GetBaseURLStr(BOOL isTest){
    if (isTest) {
        return @"http://api_test.edugkw.com";
    }
    return @"http://api.edulxw.cn";
}

@implementation BCEnvironmentConfig

+ (NSString *)baseURLString{
#ifdef DEBUG
    NSString *url = [[NSUserDefaults standardUserDefaults] valueForKey:BCEnvironmentConfigApiKey];
    if (url.length==0) {
        //debug默认为测试环境
        url = GetBaseURLStr(YES);
    }
    return url;
#else
    //release默认为正式环境
    NSString *url = GetBaseURLStr(NO);
    return url;
#endif
}

+ (NSString *)getBaseUrl:(BOOL)isTest{
    return GetBaseURLStr(isTest);
}

+ (BOOL)getPushEnv{
#ifdef DEBUG
    BOOL isProdction = [[NSUserDefaults standardUserDefaults] boolForKey:BCEnvironmentConfigPushKey];
    return isProdction;
#else
    return YES;
#endif
}



@end
