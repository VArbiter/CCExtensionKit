//
//  NSDecimalNumber+CCExtension.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/11.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "NSDecimalNumber+CCExtension.h"

#import "NSObject+CCExtension.h"

@implementation NSDecimalNumber (CCExtension)

- (NSString *)roundingToString {
    return self.ccRoundingToString;
}
- (NSDecimalNumber *)rounding {
    return self.ccRounding;
}

- (NSString *) ccRoundingToString {
    return [self ccRoundingToStringAfter:_CC_DECIMAL_POINT_POSITION_];
}
- (NSString *) ccRoundingToStringAfter : (NSInteger) position {
    return [self ccRoundingToStringAfter:position
                               roundMode:NSRoundDown];
}
- (NSString *) ccRoundingToStringAfter : (NSInteger) position
                             roundMode : (NSRoundingMode) mode  {
    return [[self ccRoundingAfter:position
                        roundMode:NSRoundPlain] stringValue];
}

- (instancetype) ccRounding {
    return [self ccRoundingAfter:_CC_DECIMAL_POINT_POSITION_];
}

- (instancetype) ccRoundingAfter : (NSInteger)position {
    return [self ccRoundingAfter:position
                       roundMode:NSRoundPlain];
}

- (instancetype) ccRoundingAfter : (NSInteger) position
                       roundMode : (NSRoundingMode) mode {
    NSDecimalNumberHandler * handlerRoundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:mode
                                                                                                              scale:position
                                                                                                   raiseOnExactness:NO
                                                                                                    raiseOnOverflow:NO
                                                                                                   raiseOnUnderflow:NO
                                                                                                raiseOnDivideByZero:NO];
    NSDecimalNumber *decimalRoundedOunces = [self decimalNumberByRoundingAccordingToBehavior:handlerRoundingBehavior];
    
    return decimalRoundedOunces;
}

- (instancetype) ccMuti : (NSDecimalNumber *) decimalNumber {
    if (![decimalNumber isKindOfClass:[NSDecimalNumber class]])
        return nil;
    if (!decimalNumber.isDecimalValued || !self.isDecimalValued)
        return nil;
    return [self decimalNumberByMultiplyingBy:decimalNumber];
}

- (instancetype) ccDivide : (NSDecimalNumber *) decimalNumber {
    if (![decimalNumber isKindOfClass:[NSDecimalNumber class]])
        return nil;
    if (!decimalNumber.isDecimalValued || !self.isDecimalValued)
        return nil;
    if ([decimalNumber isEqual:NSDecimalNumber.zero]) // 0 不能作为除数
        return nil;
    return [self decimalNumberByDividingBy:decimalNumber];
}


@end
