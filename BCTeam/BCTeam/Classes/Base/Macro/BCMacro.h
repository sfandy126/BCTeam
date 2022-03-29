//
//  BCMacro.h
//  BCTeam
//
//  Created by beichen on 2022/3/28.
//

#import <Foundation/Foundation.h>
#import "BCEnvironmentConfig.h"
#import "UIColor+YYAdd.h"

#ifdef DEBUG
#define BCLog(format, ...) printf("[%s] %s [第%d行] %s\n", __TIME__, __FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);
#else
#define BCLog(...);
#endif

CG_INLINE UIColor *BCHexColor(NSString *str){
    return [UIColor colorWithHexString:str];
}

#define BCFont(x) [UIFont systemFontOfSize:x]
#define BCBoldFont(x) [UIFont boldSystemFontOfSize:x]


#define BCScreenWidth  [UIScreen mainScreen].bounds.size.width
#define BCScreenHeight  [UIScreen mainScreen].bounds.size.height

///是否为iPad
#define BC_IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
///是否为iPhone
#define BC_IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
///是否为iphone_X系列
#define BC_IPHONE_X (BCScreenWidth >=375.0f && BCScreenHeight >=812.0f && BC_IS_IPHONE)

///适配，缩放
#define BCScale(x) [BCMacro scale:x]

///cell identify
#define BCIdentify(Class) [NSString stringWithFormat:@"%@_identify",NSStringFromClass([Class class])]

///BaseURL
#define DEFAULT_SERVER_PATH [BCEnvironmentConfig baseURLString]

#define BCNaviHeight (BC_IPHONE_X?88:64)
#define BCTabBarHeight (BC_IPHONE_X?83:49)

///默认头像
#define BCDefaultHeadIcon [UIImage imageNamed:@"default_icon"]

///默认图片
#define BCDefaultPlaceholderImage [UIImage imageNamed:@"All_cell_placeHolder"]

@interface BCMacro : NSObject

+ (CGFloat)scale:(CGFloat)x;

@end

