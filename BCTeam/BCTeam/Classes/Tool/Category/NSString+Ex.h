//
//  NSString+Ex.h
//  BcExamApp
//
//  Created by apple on 2019/12/2.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Ex)

/**
 *  去掉字符串前后空格
 *
 *  @return 去掉前后空格的字符串
 */
- (NSString *)trim;

//将 &lt 等类似的字符转化为HTML中的“<”等
- (NSString *)htmlEntityDecode;

//HTML适配图片文字
- (NSString *)adaptWebViewForHtml;

/**
*  手机号缺省
*/
- (NSString *)defaultPhoneMethod;

/// 00:00:00
+ (NSString *)getTimeStrWithSec:(NSUInteger)second;

///00:00:00  00:00
+ (NSString *)getTimeStrWithSecMin:(NSUInteger)second;

+ (NSString *)signStringAddEndTokenWithDic:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
