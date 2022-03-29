//
//  AliyunOSSModel.h
//  RCB
//
//  Created by 郑楚根 on 2018/7/19.
//  Copyright © 2018年 郑楚根. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AliyunOSSModel : NSObject
@property (nonatomic ,strong)NSString *AccessKeyId;
@property (nonatomic ,strong)NSString *AccessKeySecret;
@property (nonatomic ,strong)NSString *SecurityToken;
@property (nonatomic ,strong)NSString *BucketName;
@property (nonatomic ,strong)NSString *Endpoint;
@property (nonatomic ,strong)NSString *Expiration;

@end
