//
//  NSNumber+CCExtension.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/20.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "NSNumber+CCExtension.h"
#import "NSObject+CCExtension.h"

@implementation NSNumber (CCExtension)

- (NSDecimalNumber *)toDecimal {
    NSDecimalNumber *t = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",self]];
    return CC_IS_DECIMAL_VALUED(t) ? t : nil;
}

@end

#pragma mark - -----

@implementation NSDecimalNumber (CCExtension)

- (NSString *)round {
    return [self cc_round:2];
}

- (NSString *) cc_round : (short) point {
    return [self cc_round:point mode:NSRoundPlain];
}
- (NSString *) cc_round : (short) point
                  mode : (NSRoundingMode) mode {
    return [self cc_round_decimal:point mode:mode].stringValue;
}

- (instancetype) cc_round_decimal {
    return [self cc_round_decimal:2];
}
- (instancetype) cc_round_decimal : (short) point {
    return [self cc_round_decimal:point mode:NSRoundPlain];
}
- (instancetype) cc_round_decimal : (short) point
                           mode : (NSRoundingMode) mode {
    return [self decimalNumberByRoundingAccordingToBehavior:[NSDecimalNumberHandler
                                                             decimalNumberHandlerWithRoundingMode:mode
                                                             scale:point
                                                             raiseOnExactness:NO
                                                             raiseOnOverflow:NO
                                                             raiseOnUnderflow:NO
                                                             raiseOnDivideByZero:NO]];
}

- (instancetype) cc_mutiply : (NSDecimalNumber *) decimal {
    if (![decimal isKindOfClass:[NSDecimalNumber class]]) return self;
    if (!CC_IS_DECIMAL_VALUED(decimal) || !CC_IS_DECIMAL_VALUED(self)) return self;
    return [self decimalNumberByMultiplyingBy:decimal];
}
- (instancetype) cc_devide : (NSDecimalNumber *) decimal {
    if (![decimal isKindOfClass:[NSDecimalNumber class]]) return self;
    if (!CC_IS_DECIMAL_VALUED(decimal) || !CC_IS_DECIMAL_VALUED(self)) return self;
    if ([decimal isEqual:NSDecimalNumber.zero]) return self; // 0 can't be devided
    return [self decimalNumberByDividingBy:decimal];
}

@end
