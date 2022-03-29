//
//  BCConfig.h
//  BCTeam
//
//  Created by beichen on 2022/3/29.
//

#import <Foundation/Foundation.h>
#import "BCConfigModel.h"


@interface BCConfig : NSObject

@property (nonatomic,strong) BCConfigModel *model;

+ (instancetype)instance;

+ (void)config;

///app 配置信息接口
- (void)loadConfigData;

@end

