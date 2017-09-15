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

- (NSDecimalNumber *)decimal {
    return [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",self]].isDecimalValued;
}

@end

#pragma mark - -----

@implementation NSDecimalNumber (CCExtension)

- (NSString *)round {
    return [self ccRound:2];
}

- (NSString *) ccRound : (short) point {
    return [self ccRound:point mode:NSRoundPlain];
}
- (NSString *) ccRound : (short) point
                  mode : (NSRoundingMode) mode {
    return [self ccRoundDecimal:point mode:mode].stringValue;
}

- (instancetype) roundDecimal {
    return [self ccRoundDecimal:2];
}
- (instancetype) ccRoundDecimal : (short) point {
    return [self ccRoundDecimal:point mode:NSRoundPlain];
}
- (instancetype) ccRoundDecimal : (short) point
                           mode : (NSRoundingMode) mode {
    return [self decimalNumberByRoundingAccordingToBehavior:[NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:mode
                                                                                                                   scale:point
                                                                                                        raiseOnExactness:NO
                                                                                                         raiseOnOverflow:NO
                                                                                                        raiseOnUnderflow:NO
                                                                                                     raiseOnDivideByZero:NO]];
}

- (instancetype) ccMutiply : (NSDecimalNumber *) decimal {
    if (![decimal isKindOfClass:[NSDecimalNumber class]]) return self;
    if (!decimal.isDecimalValued || !self.isDecimalValued) return self;
    return [self decimalNumberByMultiplyingBy:decimal];
}
- (instancetype) ccDevide : (NSDecimalNumber *) decimal {
    if (![decimal isKindOfClass:[NSDecimalNumber class]]) return self;
    if (!decimal.isDecimalValued || !self.isDecimalValued) return self;
    if ([decimal isEqual:NSDecimalNumber.zero]) return self; // 0 can't be devided
    return [self decimalNumberByDividingBy:decimal];
}

@end
