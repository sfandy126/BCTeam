//
//  BCUserModel.m
//  BCTeam
//
//  Created by beichen on 2022/3/29.
//

#import "BCUserModel.h"

@implementation BCUserModel

+(instancetype)instance {
    static dispatch_once_t onceToken;
    static BCUserModel *config;
    dispatch_once(&onceToken, ^{
        config = [BCUserModel new];
    });
    return config;
}


+ (NSString *)userID{
    return [NSString stringValue:[BCUserModel instance].userID];
}

+ (NSString *)token{
    return [NSString stringValue:[BCUserModel instance].token];
}

///更新用户信息
+ (void)updateUserData:(NSDictionary *)dict{
    
}

+ (void)logout{
    BCUserModel *model = [BCUserModel instance];
    model.userID = @"";
    model.token = @"";
    model.iphone = @"";
    model.nickName = @"";
    model.photo = @"";
    model.department = @"";
    model.position = @"";
}

@end
