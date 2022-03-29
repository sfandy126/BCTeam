//
//  NSString+safe.m
//  JLWechat
//
//  Created by JL on 2020/12/14.
//

#import "NSString+safe.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (safe)


+ (BOOL)isEmpty:(NSString *)str {
    if (!str) {
        return YES;
    }
    
    if (![str isKindOfClass:[NSString class]]) {
        return YES;
    }
    
    if ([str isEqualToString:@""]) {
        return YES;
    }
    
    return NO;
}
+ (BOOL)isNotEmpty:(NSString *)str {
    return ![NSString isEmpty:str];
}
+ (NSString *)stringValue:(NSString *)str {
    if (!str) {
        return @"";
    }
    
    if ([str isKindOfClass:[NSNumber class]]) {
        NSNumber *number = (NSNumber *)str;
        return [number stringValue];
    }
    
    if (![str isKindOfClass:[NSString class]]) {
        return @"";
    }
    
    return str;
}

- (NSString *)URLEncodedString
{
    return [self URLEncodedStringWithCFStringEncoding:kCFStringEncodingUTF8];
}


- (NSString *)URLEncodedStringWithCFStringEncoding:(CFStringEncoding)encoding
{
#warning todo 处理警告
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)[self mutableCopy], NULL, CFSTR("￼!*'();:@&=+$,/?%#[]"), encoding));
}

+ (NSString *)md5:(NSString *)str {
//    NSLog(@"description: %@",[str description]);
    
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
    return [[NSString stringWithFormat:
             @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}

@end
