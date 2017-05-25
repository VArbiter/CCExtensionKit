//
//  NSDecimalNumber+CCExtension.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/11.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "NSDecimalNumber+CCExtension.h"
#import "CCCommonDefine.h"

@implementation NSDecimalNumber (CCExtension)

- (NSString *) ccRounding {
    return [self ccRoundingAfterPoint:_CC_DECIMAL_POINT_POSITION_];
}

- (NSString *) ccRoundingAfterPoint : (NSInteger) position {
    return [self ccRoundingAfterPoint:position
                        withRoundMode:NSRoundDown];
}

- (NSString *) ccRoundingAfterPoint : (NSInteger) position
                        withRoundMode : (NSRoundingMode) mode  {
    return [[self ccRoundingDecimalAfterPoint:position
                                withRoundMode:NSRoundPlain] ccTransferToString];
}

- (instancetype) ccRoundingDecimal {
    return [self ccRoundingDecimalAfterPoint:_CC_DECIMAL_POINT_POSITION_];
}

- (instancetype) ccRoundingDecimalAfterPoint : (NSInteger)position {
    return [self ccRoundingDecimalAfterPoint:position
                               withRoundMode:NSRoundPlain];
}

- (instancetype) ccRoundingDecimalAfterPoint : (NSInteger) position
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

- (NSString *) ccTransferToString {
    return [NSString stringWithFormat:@"%@",self];
}

- (instancetype) ccMuti : (NSDecimalNumber *) decimalNumber {
    if (![decimalNumber isKindOfClass:[NSDecimalNumber class]])
        return nil;
    if (!decimalNumber.ccIsDecimalValued || !self.ccIsDecimalValued)
        return nil;
    return [self decimalNumberByMultiplyingBy:decimalNumber];
}

- (instancetype) ccDivide : (NSDecimalNumber *) decimalNumber {
    if (![decimalNumber isKindOfClass:[NSDecimalNumber class]])
        return nil;
    if (!decimalNumber.ccIsDecimalValued || !self.ccIsDecimalValued)
        return nil;
    if ([decimalNumber isEqual:NSDecimalNumber.zero]) // 0 不能作为除数
        return nil;
    return [self decimalNumberByDividingBy:decimalNumber];
}



@end
