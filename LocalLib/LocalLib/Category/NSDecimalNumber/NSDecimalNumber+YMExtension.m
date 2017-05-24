//
//  NSDecimalNumber+YMExtension.m
//  ym_sell_ios
//
//  Created by 冯明庆 on 2017/4/11.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "NSDecimalNumber+YMExtension.h"

@implementation NSDecimalNumber (YMExtension)

- (NSString *) ymRounding {
    return [self ymRoundingAfterPoint:_YM_DECIMAL_POINT_POSITION_];
}

- (NSString *) ymRoundingAfterPoint : (NSInteger) position {
    return [self ymRoundingAfterPoint:position
                        withRoundMode:NSRoundDown];
}

- (NSString *) ymRoundingAfterPoint : (NSInteger) position
                        withRoundMode : (NSRoundingMode) mode  {
    return [[self ymRoundingDecimalAfterPoint:position
                                withRoundMode:NSRoundPlain] ymTransferToString];
}

- (instancetype) ymRoundingDecimal {
    return [self ymRoundingDecimalAfterPoint:_YM_DECIMAL_POINT_POSITION_];
}

- (instancetype) ymRoundingDecimalAfterPoint : (NSInteger)position {
    return [self ymRoundingDecimalAfterPoint:position
                               withRoundMode:NSRoundPlain];
}

- (instancetype) ymRoundingDecimalAfterPoint : (NSInteger) position
                               withRoundMode : (NSRoundingMode) mode {
    NSDecimalNumberHandler * handlerRoundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:mode
                                                                                                              scale:position
                                                                                                   raiseOnExactness:NO
                                                                                                    raiseOnOverflow:NO
                                                                                                   raiseOnUnderflow:NO
                                                                                                raiseOnDivideByZero:NO];
    NSDecimalNumber *decimalRoundedOunces = [self decimalNumberByRoundingAccordingToBehavior:handlerRoundingBehavior];
    
    return decimalRoundedOunces;
}

- (NSString *) ymTransferToString {
    return [NSString stringWithFormat:@"%@",self];
}

- (instancetype) ymMuti : (NSDecimalNumber *) decimalNumber {
    if (![decimalNumber isKindOfClass:[NSDecimalNumber class]])
        return nil;
    if (!decimalNumber.ymIsDecimalValued || !self.ymIsDecimalValued)
        return nil;
    return [self decimalNumberByMultiplyingBy:decimalNumber];
}

- (instancetype) ymDivide : (NSDecimalNumber *) decimalNumber {
    if (![decimalNumber isKindOfClass:[NSDecimalNumber class]])
        return nil;
    if (!decimalNumber.ymIsDecimalValued || !self.ymIsDecimalValued)
        return nil;
    if ([decimalNumber isEqual:NSDecimalNumber.zero]) // 0 不能作为除数
        return nil;
    return [self decimalNumberByDividingBy:decimalNumber];
}

- (BOOL) ymIsDecimalValued {
    if (self) {
        if ([self isKindOfClass:[NSDecimalNumber class]]) {
            if (![self isEqual:NSDecimalNumber.notANumber]) {
                return YES;
            }
        }
    }
    return false;
}

@end
