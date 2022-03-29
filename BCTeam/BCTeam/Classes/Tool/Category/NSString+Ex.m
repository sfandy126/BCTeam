//
//  NSString+Ex.m
//  BcExamApp
//
//  Created by apple on 2019/12/2.
//  Copyright © 2019 apple. All rights reserved.
//

#import "NSString+Ex.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Ex)

/**
 *  去掉字符串前后空格
 *
 *  @return 去掉前后空格的字符串
 */
- (NSString *)trim{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

//将 &lt 等类似的字符转化为HTML中的“<”等
- (NSString *)htmlEntityDecode
{
    NSString * string;
    string = [self stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    string = [string stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"]; // Do this last so that, e.g. @"&amp;lt;" goes to @"&lt;" not @"<"
    return string;
}

//HTML适配图片文字
- (NSString *)adaptWebViewForHtml
{
    NSMutableString *headHtml = [[NSMutableString alloc] initWithCapacity:0];
    [headHtml appendString : @"<html>" ];
    [headHtml appendString : @"<head>" ];
    [headHtml appendString : @"<meta charset=\"utf-8\">" ];
    [headHtml appendString : @"<meta id=\"viewport\" name=\"viewport\" content=\"width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=false\" />" ];
    [headHtml appendString : @"<meta name=\"apple-mobile-web-app-capable\" content=\"yes\" />" ];
    [headHtml appendString : @"<meta name=\"apple-mobile-web-app-status-bar-style\" content=\"black\" />" ];
    [headHtml appendString : @"<meta name=\"black\" name=\"apple-mobile-web-app-status-bar-style\" />" ];
    //适配图片宽度，让图片宽度等于屏幕宽度
    //[headHtml appendString : @"<style>img{width:100%;}</style>" ];
    //[headHtml appendString : @"<style>img{height:auto;}</style>" ];
    
     //适配图片宽度，让图片宽度最大等于屏幕宽度
//    [headHtml appendString : @"<style>img{max-width:100%;width:auto;height:auto;}</style>"];
//适配图片宽度，如果图片宽度超过手机屏幕宽度，就让图片宽度等于手机屏幕宽度，高度自适应，如果图片宽度小于屏幕宽度，就显示图片大小
    [headHtml appendString : @"<script type='text/javascript'>"
     "window.onload = function(){\n"
     "var maxwidth=document.body.clientWidth;\n" //屏幕宽度
     "for(i=0;i <document.images.length;i++){\n"
     "var myimg = document.images[i];\n"
     "if(myimg.width > maxwidth){\n"
     "myimg.style.width = '100%';\n"
     "myimg.style.height = 'auto'\n;"
     "}\n"
     "}\n"
     "}\n"
     "</script>\n"];
    
    [headHtml appendString : @"<style>table{width:100%;}</style>" ];
    [headHtml appendString : @"<title>webview</title>" ];
    NSString * bodyHtml;
    bodyHtml = [NSString stringWithString:headHtml];
    bodyHtml = [bodyHtml stringByAppendingString:self];
    return bodyHtml;
}

/**
*  手机号缺省
*/
- (NSString *)defaultPhoneMethod{
    if (self.length < 11) return self;
    
    NSRange subRange = NSMakeRange(3, 4);
    NSString * subStr = [self substringWithRange:subRange];
    subStr = [self stringByReplacingOccurrencesOfString:subStr withString:@"****"];
    return subStr;
}

/// 00:00:00
+ (NSString *)getTimeStrWithSec:(NSUInteger)second{
    if (second<=0) {
        return @"00:00:00";
    }
    NSInteger sec = second % 60;
    NSInteger min = (second / 60) % 60;
    NSInteger hours = second / 3600;
//    if (hours<=0) {
//        return [NSString stringWithFormat:@"%02zd:%02zd",min,sec];
//    }
    return [NSString stringWithFormat:@"%02zd:%02zd:%02zd",hours,min,sec];
}
///00:00:00  00:00
+ (NSString *)getTimeStrWithSecMin:(NSUInteger)second{
    if (second<=0) {
        return @"00:00";
    }
    NSInteger sec = second % 60;
    NSInteger min = (second / 60) % 60;
    NSInteger hours = second / 3600;
    if (hours<=0) {
        return [NSString stringWithFormat:@"%02zd:%02zd",min,sec];
    }
    return [NSString stringWithFormat:@"%02zd:%02zd:%02zd",hours,min,sec];
}

+ (NSString *)signStringAddEndTokenWithDic:(NSDictionary *)dic{
    NSStringCompareOptions comparisonOptions = NSLiteralSearch|NSNumericSearch|
    
    NSWidthInsensitiveSearch|NSForcedOrderingSearch;
    
    NSComparator sort = ^(NSString *obj1,NSString *obj2){
        NSRange range = NSMakeRange(0,obj1.length);
        return [obj1 compare:obj2 options:comparisonOptions range:range];
    };
    
    NSArray *resultArray = [dic.allKeys sortedArrayUsingComparator:sort];
    NSMutableArray *string = [[NSMutableArray alloc]init];
    for (NSString *str in resultArray) {
        if ([dic[str]isKindOfClass:[NSString class]]) {
            if ( dic[str] !=nil) {
             //   [string appendString:[NSString stringWithFormat:@"&%@=%@",str,dic[str]]];
                [string addObject:[NSString stringWithFormat:@"%@=%@",str,dic[str]]];
            }
        }else if ([dic[str]isKindOfClass:[NSNumber class]]){
            if (dic[str] !=nil) {
                [string addObject:[NSString stringWithFormat:@"%@=%@",str,dic[str]]];
            }
        }
    }
    //str    __NSCFConstantString *    @"issmsverfy"    0x0000000101354df0
    NSString * string2 = [string componentsJoinedByString:@"&"];
    NSString * tokenStr = [NSString stringWithFormat:@"&token=%@",BCUserModel.token];
    NSString * string3 = [string2 stringByAppendingString:tokenStr];
    NSString * paw = [self md5HexDigest:string3];
    return paw;
}

//MD5 加密
+ (NSString *)md5HexDigest:(NSString*)password
{
    const char *original_str = [password UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
    {
        [hash appendFormat:@"%02X", result[i]];
    }
    NSString *mdfiveString = [hash lowercaseString];
    
    return mdfiveString;
}

@end
