//
//  UIControl+BCAOP.m
//  BcExamApp
//
//  Created by beichen on 2021/12/18.
//  Copyright © 2021 apple. All rights reserved.
//

#import "UIControl+BCAOP.h"
#import <objc/runtime.h>

static const char * UIControl_acceptEventInterval = "UIControl_acceptEventInterval";
static const char * UIControl_ignoreEvent = "UIControl_ignoreEvent";

@interface UIControl (BCAOP)
@property(nonatomic, assign) BOOL ignoreEvent;
@end

@implementation UIControl (BCAOP)

-(void)setEventInterval:(double)eventInterval {
    objc_setAssociatedObject(self, UIControl_acceptEventInterval,@(eventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSTimeInterval)eventInterval{
    return [objc_getAssociatedObject(self, UIControl_acceptEventInterval) doubleValue];
}

-(void)setIgnoreEvent:(BOOL)ignoreEvent {
    objc_setAssociatedObject(self, UIControl_ignoreEvent, @(ignoreEvent), OBJC_ASSOCIATION_ASSIGN);
}

-(BOOL)ignoreEvent{
    return [objc_getAssociatedObject(self, UIControl_ignoreEvent) boolValue];
}

void swizzleMethod(Class class, SEL originalSelector, SEL swizzledSelector){
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

+(void)load{
//    swizzleMethod([self class], @selector(sendAction:to:forEvent:), @selector(swizzing_sendAction:to:forEvent:));
}



-(void)swizzing_sendAction:(SEL)action to:(id)tagert forEvent:(UIEvent*)event{
    if (self.ignoreEvent) {
        NSLog(@"你点击的太快了");
        return;
    }
    if (self.eventInterval>0) {
        self.ignoreEvent = YES;
        [self performSelector:@selector(setIgnoreWithNo) withObject:nil afterDelay:self.eventInterval];
    }
    [self swizzing_sendAction:action to:tagert forEvent:event];
}
-(void)setIgnoreWithNo{
    self.ignoreEvent = NO;
}
@end
