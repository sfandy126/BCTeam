//
//  BCSlider.m
//  BcExamApp
//
//  Created by beichen on 2021/10/21.
//  Copyright © 2021 apple. All rights reserved.
//

#import "BCSlider.h"

#define thumbBound_x 10

#define thumbBound_y 20

@interface BCSlider ()
{
    CGRect  lastBounds;
}
@end

@implementation BCSlider

- (CGRect)trackRectForBounds:(CGRect)bounds {
    CGRect result = [super trackRectForBounds:bounds];
    if (self.trackHeight == 0) {
        return result;
    }
    result = CGRectMake(result.origin.x, result.origin.y, result.size.width, self.trackHeight);
    return result;
}


- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value
{

    rect.origin.y = rect.origin.y-10;
    rect.size.height = rect.size.height+20 ;
    CGRect result = [super thumbRectForBounds:bounds trackRect:rect value:value];
    lastBounds = result;
    self.thumbRect = result;
    return result;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    UIView *result = [super hitTest:point withEvent:event];
      if (point.x < 0 || point.x > self.bounds.size.width){

        return result;

      }

    if ((point.y >= -thumbBound_y) && (point.y < lastBounds.size.height + thumbBound_y)) {
        float value = 0.0;
        value = point.x - self.bounds.origin.x;
        value = value/self.bounds.size.width;
        
        value = value < 0? 0 : value;
        value = value > 1? 1: value;
        
        value = value * (self.maximumValue - self.minimumValue) + self.minimumValue;
//        [self setValue:value animated:YES];
    }
    return result;
    
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    BOOL result = [super pointInside:point withEvent:event];
    if (!result && point.y > -10) {
        if ((point.x >= lastBounds.origin.x - thumbBound_x) && (point.x <= (lastBounds.origin.x + lastBounds.size.width + thumbBound_x)) && (point.y < (lastBounds.size.height + thumbBound_y))) {
            result = YES;
        }
      
    }
      return result;
}


@end
