//
//  NSDictionary+safe.m
//  JLWechat
//
//  Created by JL on 2020/12/15.
//

#import "NSDictionary+safe.h"

@implementation NSDictionary (safe)

+ (NSDictionary *)getDictionary:(id)dict {
    
    if (!dict) {
        return [NSDictionary dictionary];
    }
    
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return [NSDictionary dictionary];
    }
    
    return dict;
}

- (NSString*)string
{
    NSError *parseError = nil;
    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

+ (BOOL)isNotEmpty:(NSDictionary *)dic {
    return dic && [dic isKindOfClass:[NSDictionary class]] && [[dic allKeys] count] > 0;
}

- (void)setValue:(id)value safeForKey:(NSString *)key{
    if (value) {
        [self setValue:value forKey:key];
    }
}

- (void)setValue:(id)value safeForKeyPath:(NSString *)keyPath{
    if (value) {
        [self setValue:value forKeyPath:keyPath];
    }
}

@end
