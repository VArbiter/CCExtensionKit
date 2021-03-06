//
//  NSNumber+MQExtension.m
//  MQExtensionKit
//
//  Created by 冯明庆 on 2017/4/20.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "NSNumber+MQExtension.h"
#import "NSObject+MQExtension.h"

@implementation NSNumber (MQExtension)

- (NSDecimalNumber *)to_decimal {
    NSDecimalNumber *t = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",self]];
    return mq_is_decimal_valued(t) ? t : nil;
}

@end

#pragma mark - -----

@implementation NSString (MQExtension_Number_Assist)

- (NSDecimalNumber *)to_decimal {
    NSDecimalNumber *t = [NSDecimalNumber decimalNumberWithString:self];
    return mq_is_decimal_valued(t) ? t : nil;
}

@end

#pragma mark - -----

@implementation NSDecimalNumber (MQExtension)

- (NSString *)round {
    return [self mq_round:2];
}

- (NSString *) mq_round : (short) point {
    return [self mq_round:point mode:NSRoundPlain];
}
- (NSString *) mq_round : (short) point
                  mode : (NSRoundingMode) mode {
    return [self mq_round_decimal:point mode:mode].stringValue;
}

- (instancetype) mq_round_decimal {
    return [self mq_round_decimal:2];
}
- (instancetype) mq_round_decimal : (short) point {
    return [self mq_round_decimal:point mode:NSRoundPlain];
}
- (instancetype) mq_round_decimal : (short) point
                           mode : (NSRoundingMode) mode {
    return [self decimalNumberByRoundingAccordingToBehavior:[NSDecimalNumberHandler
                                                             decimalNumberHandlerWithRoundingMode:mode
                                                             scale:point
                                                             raiseOnExactness:NO
                                                             raiseOnOverflow:NO
                                                             raiseOnUnderflow:NO
                                                             raiseOnDivideByZero:NO]];
}

- (instancetype) mq_mutiply : (NSDecimalNumber *) decimal {
    if (![decimal isKindOfClass:[NSDecimalNumber class]]) return self;
    if (!mq_is_decimal_valued(decimal) || !mq_is_decimal_valued(self)) return self;
    return [self decimalNumberByMultiplyingBy:decimal];
}
- (instancetype) mq_devide : (NSDecimalNumber *) decimal {
    if (![decimal isKindOfClass:[NSDecimalNumber class]]) return self;
    if (!mq_is_decimal_valued(decimal) || !mq_is_decimal_valued(self)) return self;
    if ([decimal isEqual:NSDecimalNumber.zero]) return self; // 0 can't be devided
    return [self decimalNumberByDividingBy:decimal];
}

@end
