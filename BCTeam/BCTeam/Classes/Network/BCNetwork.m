//
//  BCNetwork.m
//  BCTeam
//
//  Created by beichen on 2022/3/29.
//

#import "BCNetwork.h"
#import <AFNetworking.h>

static dispatch_once_t onceToken;
static BCNetwork * aFNetWork = nil;

@implementation BCNetwork

+ (instancetype)shareInstance{
    dispatch_once(&onceToken, ^{
        aFNetWork = [[super allocWithZone:NULL] init] ;
    });
    return aFNetWork;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [BCNetwork shareInstance];
}

- (id)copyWithZone:(struct _NSZone *)zone
{
    return [BCNetwork shareInstance];
}

- (AFHTTPSessionManager *)manager{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 30;
//    [manager.requestSerializer setValue:kNewLogin.accessToken forHTTPHeaderField:@"token"];
//    [manager.requestSerializer setValue:@"Application/json" forHTTPHeaderField:@"accept"];
//    [manager.requestSerializer setValue:@"Application/json" forHTTPHeaderField:@"Content-type"];

    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html",@"application/json",nil];
    // https ssl 验证。
    //    [manager setSecurityPolicy:[self customSecurityPolicy]];
    
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //User-Agent
    [manager.requestSerializer setValue:[NSBundle mainBundle].appVersion forHTTPHeaderField:@"versions"];
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"system-type"];

    
    return manager;
}


- (void)POSTRequstUrl:(NSString *)url Params:(NSMutableDictionary *)params Success:(void(^)(NSDictionary *))successBlock loginBlock:(void(^)(void))loginBlock failBlock:(void(^)(NSString *msg))failBlock noHud:(BOOL)noHud{
    AFHTTPSessionManager * manager = [self manager];
    [manager POST:url parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            if ([dic[@"status"] isEqual:@0] || ([dic[@"status"] isEqual:@-1] && [[dic objectForKey:@"msg"] isEqualToString:@"未知用户"])) {
                [BCUserModel logout];
                if (loginBlock) {
                    loginBlock();
                }
            }else if ([dic[@"status"] isEqual:@1]) {
                //请求数据成功
                NSDictionary *dict = [self filterNUllObject:dic];
                if (successBlock) {
                    successBlock(dict);
                }
            } else {
                if ([dic objectForKey:@"msg"]) {
                    failBlock(dic[@"msg"]);
                }else{
                    failBlock(@"请求失败");
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        BCLog(@"失败原因%@",error.description);
        failBlock(@"网络异常，请稍后重试");
    }];
}

- (NSDictionary *)filterNUllObject:(NSDictionary *)dict
{
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] initWithDictionary:dict];
    NSArray *keys = [dict allKeys];
    for (NSString *key in keys) {
        id obj = dict1[key];
        if ([obj isKindOfClass:[NSString class]]) {
            NSString *value = obj;
            if (value.length == 0) {
                [dict1 removeObjectForKey:key];
            }
        }
    }
    return [NSDictionary dictionaryWithDictionary:dict1];
}

+ (void)POSTRequstWithParams:(NSDictionary *)params cmd:(NSString *)cmd successBlock:(BCNetWorkSuccessBlock)successBlock failedBlock:(BCNetWorkFailedBlock)failedBlock loginOutBlock:(BCNetWorkLoginOutBlock)loginOutBlock{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",DEFAULT_SERVER_PATH,cmd];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:params];
    [dict setValue:BCUserModel.userID forKey:@"user_id"];
    [dict setValue:[NSBundle mainBundle].appVersion forKey:@"current_version"];
    NSString *sign = [NSString signStringAddEndTokenWithDic:[dict copy]];
    [dict setValue:[NSString stringValue:sign] forKey:@"sign"];

    [[BCNetwork shareInstance] POSTRequstUrl:urlString Params:[dict copy] Success:^(NSDictionary * _Nonnull dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } loginBlock:^{
        //表示user_id为空了，退出了登录
        if (loginOutBlock) {
            loginOutBlock();
        }
    } failBlock:^(NSString * _Nonnull msg) {
        if (failedBlock) {
            failedBlock([NSString stringValue:msg]);
        }
    } noHud:YES];
}

@end
