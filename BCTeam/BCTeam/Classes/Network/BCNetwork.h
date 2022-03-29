//
//  BCNetwork.h
//  BCTeam
//
//  Created by beichen on 2022/3/29.
//

#import <Foundation/Foundation.h>

///是否登录成功回调
typedef void(^BCNetWorkSuccessBlock)(NSDictionary *dict);
typedef void(^BCNetWorkFailedBlock)(NSString *msg);
///退出登录回调
typedef void(^BCNetWorkLoginOutBlock)(void);

@interface BCNetwork : NSObject

/**
    post 请求
 */
+ (void)POSTRequstWithParams:(NSDictionary *)params cmd:(NSString *)cmd successBlock:(BCNetWorkSuccessBlock)successBlock failedBlock:(BCNetWorkFailedBlock)failedBlock loginOutBlock:(BCNetWorkLoginOutBlock)loginOutBlock;

@end

