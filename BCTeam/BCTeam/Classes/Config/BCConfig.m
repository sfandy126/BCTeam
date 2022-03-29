//
//  BCConfig.m
//  BCTeam
//
//  Created by beichen on 2022/3/29.
//

#import "BCConfig.h"

@interface BCConfig ()
///是否加载成功
@property (nonatomic,assign) BOOL isLoaded;
///默认尝试请求三次
@property (nonatomic,assign) NSInteger tryCount;
@end

@implementation BCConfig

+(instancetype)instance {
    static dispatch_once_t onceToken;
    static BCConfig *config;
    dispatch_once(&onceToken, ^{
        config = [BCConfig new];
    });
    return config;
}

+ (void)config{
    [[BCConfig instance] loadConfigData];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.tryCount = 3;
    }
    return self;
}

///app 配置信息接口
- (void)loadConfigData{
    if (self.isLoaded) {
        ///请求成功不再请求了，请求失败的话尝试三次之后还是失败的话，在首页、商城（课程列表、教材列表）、学习列表、我的页面，下拉刷新可以触发刷新
        return;
    }
//    [BCNetWork POSTRequstWithParams:@{} cmd:@"site_config" successBlock:^(NSDictionary *data) {
//        [self.model loadData:[NSDictionary getDictionary:data[@"data"]]];
//        self.tryCount = 0;
//        self.isLoaded = YES;
//    } failedBlock:^(NSString *msg) {
//        [self tryLoadConfigData];
//    } loginOutBlock:^{
//        
//    }];
}

- (void)tryLoadConfigData{
    if (self.tryCount<=0) {
        return;
    }
    [self loadConfigData];
    self.tryCount--;
}

- (BCConfigModel *)model{
    if (!_model) {
        _model = [BCConfigModel new];
    }
    return _model;
}

@end
