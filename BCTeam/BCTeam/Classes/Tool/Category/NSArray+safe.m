//
//  NSArray+safe.m
//  JLWechat
//
//  Created by JL on 2020/12/14.
//

#import "NSArray+safe.h"

@implementation NSArray (safe)

+ (BOOL)isNotEmpty:(NSArray *)array {
    return array && [array isKindOfClass:[NSArray class]] && [array count] > 0;
}

+ (NSArray *)getArray:(NSArray *)array{
    if (array && [array isKindOfClass:[NSArray class]]) {
        return array;
    }
    return [NSArray array];
}

- (id)objectAtIndexSafe:(NSInteger )index{
    if (index>=0 && index < self.count) {
        return [self objectAtIndex:index];
    }
    return nil;
}

-(id)safeObjectAtIndex:(NSUInteger)index
{
    if(index<[self count]){
        return [self objectAtIndex:index];
    }else{
        return nil;
    }
}


@end
