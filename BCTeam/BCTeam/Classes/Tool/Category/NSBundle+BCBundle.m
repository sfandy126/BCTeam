//
//  NSBundle+BCBundle.m
//  BCTeam
//
//  Created by beichen on 2022/3/29.
//

#import "NSBundle+BCBundle.h"

@implementation NSBundle (BCBundle)

- (NSString *)appVersion{
    NSDictionary *info = [NSBundle mainBundle].infoDictionary;
    return [NSString stringValue:[info valueForKey:@"CFBundleShortVersionString"]];
}

@end
