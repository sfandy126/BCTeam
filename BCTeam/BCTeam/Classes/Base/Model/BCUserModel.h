//
//  BCUserModel.h
//  BCTeam
//
//  Created by beichen on 2022/3/29.
//

#import <Foundation/Foundation.h>

@interface BCUserModel : NSObject

///用户id
@property (nonatomic,copy) NSString *userID;
///用户token
@property (nonatomic,copy) NSString *token;
///昵称
@property (nonatomic,copy) NSString *nickName;
///手机号
@property (nonatomic,copy) NSString *iphone;
///头像
@property (nonatomic,copy) NSString *photo;
///所属部门
@property (nonatomic,copy) NSString *department;
///职位(岗位)
@property (nonatomic,copy) NSString *position;

+(instancetype)instance;

+ (NSString *)userID;
+ (NSString *)token;

///更新用户信息
+ (void)updateUserData:(NSDictionary *)dict;

///退出登录，清空用户信息
+ (void)logout;

@end
