//
//  NSDictionary+safe.h
//  JLWechat
//
//  Created by JL on 2020/12/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (safe)

+ (NSDictionary *)getDictionary:(id)dict;

 - (NSString*)string;

+ (BOOL)isNotEmpty:(NSDictionary *)dic;

- (void)setValue:(id)value safeForKey:(NSString *)key;

- (void)setValue:(id)value safeForKeyPath:(NSString *)keyPath;

@end

NS_ASSUME_NONNULL_END
