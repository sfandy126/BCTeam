//
//  NSString+safe.h
//  JLWechat
//
//  Created by JL on 2020/12/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (safe)


+ (BOOL)isEmpty:(NSString *)str;

+ (BOOL)isNotEmpty:(NSString *)str;

+ (NSString *)stringValue:(NSString *)str;

- (NSString *)URLEncodedString;

- (NSString *)URLEncodedStringWithCFStringEncoding:(CFStringEncoding)encoding;

+ (NSString *)md5:(NSString *)str;

@end

NS_ASSUME_NONNULL_END
