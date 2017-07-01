//
//  NSString+CCChain.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 01/07/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "NSString+CCChain.h"

#import "CCCommonTools.h"

#import "NSObject+CCChain.h"
#import "NSPredicate+CCChain.h"
#import "NSAttributedString+CCChain.h"

#import <CommonCrypto/CommonDigest.h>

@implementation NSString (CCChain)

- (NSString *(^)(id))s {
    __weak typeof(self) pSelf = self;
    return ^NSString *(id value) {
        if ([value isKindOfClass:NSString.class]) {
            return [pSelf stringByAppendingString:(NSString *)value];
        }
        return [pSelf stringByAppendingString:[NSString stringWithFormat:@"%@",value]];
    };
}

- (NSString *(^)(id))path {
    __weak typeof(self) pSelf = self;
    return ^NSString *(id value) {
        if ([value isKindOfClass:NSString.class]) {
            return [pSelf stringByAppendingPathComponent:(NSString *)value];
        }
        return [pSelf stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",value]];
    };
}

- (NSString *(^)(NSTimeInterval))timeSince1970 {
    return ^NSString *(NSTimeInterval interval) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
        NSString *string = [formatter stringFromDate:date];
        return string;
    };
}

- (NSMutableAttributedString *(^)(UIColor *))colorAttribute {
    __weak typeof(self) pSelf = self;
    return ^NSMutableAttributedString *(UIColor *color) {
        return pSelf.toAttribute.color(color);
    };
}

- (NSString *(^)(BOOL, BOOL, NSArray<NSString *> *))merge {
    return ^NSString *(BOOL isBreak , BOOL isSpace , NSArray <NSString *> * array){
        __block NSString *stringResult = @"";
        if (isBreak) {
            [array enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                stringResult.isStringValued.s(obj).isStringValued.s(@"\n");
            }];
        }
        else if (isSpace) {
            [array enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                stringResult.isStringValued.s(obj).isStringValued.s(@" ");
            }];
        }
        else {
            [array enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                stringResult.isStringValued.s(obj);
            }];
        }
        return stringResult;
    };
}

- (NSString *(^)(BOOL, BOOL, NSString *, ...))mergeR {
    return ^NSString *(BOOL isBreak , BOOL isSpace , NSString * string , ...) {
        if (!string || !string.length) return nil;
        
        NSMutableArray < NSString * > * arrayStrings = [NSMutableArray array];
        NSString *stringTemp;
        va_list argumentList;
        if (string) {
            [arrayStrings addObject:string];
            va_start(argumentList, string);
            while ((stringTemp = va_arg(argumentList, id))) {
                [arrayStrings addObject:stringTemp];
            }
            va_end(argumentList);
        }
        return self.merge(isBreak, isSpace, arrayStrings);
    };
}

- (NSInteger)toInteger {
    return self.integerValue;
}
- (long long)toLonglong {
    return self.longLongValue;
}
- (int)toInt {
    return self.intValue;
}
- (BOOL)toBool {
    return self.boolValue;
}
- (float)toFloat {
    return self.floatValue;
}
- (double)toDouble {
    return self.doubleValue;
}

- (NSDecimalNumber *)toDecimal {
    return [NSDecimalNumber decimalNumberWithString:self];
}
- (NSMutableAttributedString *)toAttribute {
    if ([self isKindOfClass:[NSString class]])
        if (self.isStringValued)
            return [[NSMutableAttributedString alloc] initWithString:self];
    return nil;
}
- (NSDate *)toDate {
    NSString * string = NSPredicate.time().evaluate(self);
    if (!string.isStringValued) {
        return nil;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    return [formatter dateFromString:string];
}

- (NSString *(^)(BOOL))timeStick {
    __weak typeof(self) pSelf = self;
    return ^NSString *(BOOL isNeedSpace) {
        if (isNeedSpace) {
            return pSelf.s(@" ").s(pSelf.timeStickP);
        }
        return pSelf.s(pSelf.timeStickP);
    };
}
- (NSString *)timeStickP {
    NSDate *date = self.toDate;
    if (!date) {
        return nil;
    }
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:date];
    
    long interval = (long) timeInterval;
    if (timeInterval / (60 * 60 * 24 * 30) >= 1 ) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
        return [formatter stringFromDate:date];
    }
    else if (timeInterval / (60 * 60 * 24) >= 1) {
        return [NSString stringWithFormat:@"%ld %@",interval / (60 * 60 * 24) , ccLocalize(@"_CC_DAYS_AGO_", "天前")];
    }
    else if (timeInterval / (60 * 60) >= 1) {
        return [NSString stringWithFormat:@"%ld %@",interval / (60 * 60) , ccLocalize(@"_CC_HOURS_AGO_", "小时前")];
    }
    else if (timeInterval / 60 >= 1) {
        return [NSString stringWithFormat:@"%ld %@",interval / 60 , ccLocalize(@"_CC_MINUTES_AGO_", "分钟前")];
    }
    else {
        return ccLocalize(@"_CC_AGO_", "刚刚");
    }
}
- (NSString *)md5 {
    if (!self.length) return nil;
    const char *cStr = [self.isStringValued UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG) strlen(cStr), digest );
    NSMutableString *stringOutput = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [stringOutput appendFormat:@"%02x", digest[i]];
    return  stringOutput;
}

@end
