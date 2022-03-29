//
//  AliyunOSSModel.m
//  RCB
//
//  Created by 郑楚根 on 2018/7/19.
//  Copyright © 2018年 郑楚根. All rights reserved.
//

#import "AliyunOSSModel.h"

@implementation AliyunOSSModel
- (instancetype)init{
    if (self = [super init]) {
        self.Endpoint = @"oss-cn-hangzhou.aliyuncs.com";
        self.BucketName = @"edulxw";
    }
    return self;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"Endpoint":@"endpoint",@"BucketName":@"bucket"};
}

@end
