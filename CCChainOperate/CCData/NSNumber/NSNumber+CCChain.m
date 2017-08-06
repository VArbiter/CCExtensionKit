//
//  NSNumber+CCChain.m
//  CCLocalLibrary
//
//  Created by Elwinfrederick on 02/08/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "NSNumber+CCChain.h"

@implementation NSNumber (CCChain)

- (NSDecimalNumber *(^)())decimal {
    __weak typeof(self) pSelf = self;
    return ^NSDecimalNumber * {
        return [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",pSelf]];
    };
}

@end

#pragma mark - -----
#import "NSObject+CCChain.h"

@implementation NSDecimalNumber (CCChain)

- (NSString *(^)())round {
    __weak typeof(self) pSelf = self;
    return ^NSString * {
        return pSelf.roundAfter(2);
    };
}
- (NSString *(^)(short))roundAfter {
    __weak typeof(self) pSelf = self;
    return ^NSString *(short i) {
        return pSelf.roundAfterM(2, NSRoundPlain);
    };
}
- (NSString *(^)(short, NSRoundingMode))roundAfterM {
    __weak typeof(self) pSelf = self;
    return ^NSString *(short i , NSRoundingMode m) {
        return pSelf.roundAfterMD(i, m).stringValue;
    };
}

- (NSDecimalNumber *(^)())roundD {
    __weak typeof(self) pSelf = self;
    return ^NSDecimalNumber * {
        return pSelf.roundAfterD(2);
    };
}
- (NSDecimalNumber *(^)(short))roundAfterD {
    __weak typeof(self) pSelf = self;
    return ^NSDecimalNumber *(short i) {
        return pSelf.roundAfterMD(i, NSRoundPlain);
    };
}
-(NSDecimalNumber *(^)(short, NSRoundingMode))roundAfterMD {
    __weak typeof(self) pSelf = self;
    return ^NSDecimalNumber *(short i , NSRoundingMode m) {
        return [pSelf decimalNumberByRoundingAccordingToBehavior:[NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:m
                                                                                                                        scale:i
                                                                                                             raiseOnExactness:NO
                                                                                                              raiseOnOverflow:NO
                                                                                                             raiseOnUnderflow:NO
                                                                                                          raiseOnDivideByZero:NO]];
    };
}

- (NSDecimalNumber *(^)(NSDecimalNumber *))multiply {
    __weak typeof(self) pSelf = self;
    return ^NSDecimalNumber *(NSDecimalNumber *d) {
        if (![d isKindOfClass:[NSDecimalNumber class]]) return pSelf;
        if (!d.isDecimalValued || !pSelf.isDecimalValued) return pSelf;
        return [pSelf decimalNumberByMultiplyingBy:d];
    };
}
-(NSDecimalNumber *(^)(NSDecimalNumber *))devide {
    __weak typeof(self) pSelf = self;
    return ^NSDecimalNumber *(NSDecimalNumber *d) {
        if (![d isKindOfClass:[NSDecimalNumber class]]) return pSelf;
        if (!d.isDecimalValued || !pSelf.isDecimalValued) return pSelf;
        if ([d isEqual:NSDecimalNumber.zero]) return pSelf; // 0 can't be devided
        return [pSelf decimalNumberByDividingBy:d];
    };
}

@end
