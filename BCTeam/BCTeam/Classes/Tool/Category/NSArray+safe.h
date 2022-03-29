//
//  NSArray+safe.h
//  JLWechat
//
//  Created by JL on 2020/12/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (safe)

+ (BOOL)isNotEmpty:(NSArray *)array;

+ (NSArray *)getArray:(NSArray *)array;

- (id)objectAtIndexSafe:(NSInteger )index;

-(id)safeObjectAtIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
