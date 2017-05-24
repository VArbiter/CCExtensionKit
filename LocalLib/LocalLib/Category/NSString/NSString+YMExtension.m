//
//  NSString+YMExtension.m
//  ym_sell_ios
//
//  Created by 冯明庆 on 2017/4/11.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "NSString+YMExtension.h"

#import "NSDate+YMExtension.h"
#import <CommonCrypto/CommonDigest.h>

#import "NSMutableAttributedString+YMExtension.h"

@implementation NSString (YMExtension)

- (NSDecimalNumber *) ymDecimalValue {
    return [NSDecimalNumber decimalNumberWithString:self];
}

- (NSString *) ymTimeStick {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSDate *date = [formatter dateFromString:self];
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:date];
    
    long interval = (long) timeInterval;
    if (timeInterval / (60 * 60 * 24 * 30) >= 1 ) {
        return [formatter stringFromDate:date];
    }
    else if (timeInterval / (60 * 60 * 24) >= 1) {
        return [NSString stringWithFormat:@"%ld %@",interval / (60 * 60 * 24) , ccLocalize(@"_YM_DAYS_AGO_", "天前")];
    }
    else if (timeInterval / (60 * 60) >= 1) {
        return [NSString stringWithFormat:@"%ld %@",interval / (60 * 60) , ccLocalize(@"_YM_HOURS_AGO_", "小时前")];
    }
    else if (timeInterval / 60 >= 1) {
        return [NSString stringWithFormat:@"%ld %@",interval / 60 , ccLocalize(@"_YM_MINUTES_AGO_", "分钟前")];
    }
    else {
        return ccLocalize(@"_YM_AGO_", "刚刚");
    }
}

- (NSUInteger) ymIntegerDays {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSDate *date = [formatter dateFromString:self];
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:date];
    return timeInterval / (60 * 60 * 24);
}

- (NSString *) ymTimeStickWeekDays {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSDate *date = [formatter dateFromString:self];
    return date.ymWeekDays;
}

- (NSString *) ymTimeSince1970 : (NSTimeInterval) interval {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *string = [formatter stringFromDate:date];
    return string;
}

- (NSDate *) ymDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    return [formatter dateFromString:self];
}

+ (NSString *) ymMergeNeedLineBreak : (BOOL) isNeedBreak
                    withNeedSpacing : (BOOL) isNeedSpacing
                         withString : (NSString *) string , ... NS_REQUIRES_NIL_TERMINATION {
    if (!string || !string.length) return nil;
    
    NSMutableArray *arrayStrings = [NSMutableArray array];
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
    
    return [self ymMergeWithStringArray:arrayStrings
                      withNeedLineBreak:isNeedBreak
                        withNeedSpacing:isNeedSpacing];
}

+ (NSString *) ymMergeWithStringArray : (NSArray <NSString *> *) arrayStrings
                    withNeedLineBreak : (BOOL) isNeedBreak // 回车优先级最高 , 高于空格
                      withNeedSpacing : (BOOL) isNeedSpacing {
    __block NSString *stringResult = @"";
    if (isNeedBreak) {
        [arrayStrings enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[NSString class]]) {
                stringResult = [stringResult stringByAppendingString:(NSString *) obj];
                if (idx != (arrayStrings.count - 1)) {
                    stringResult = [stringResult stringByAppendingString:@"\n"];
                }
            }
        }];
    }
    else if (isNeedSpacing) {
        [arrayStrings enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[NSString class]]) {
                stringResult = [stringResult stringByAppendingString:(NSString *) obj];
                if (idx != (arrayStrings.count - 1)) {
                    stringResult = [stringResult stringByAppendingString:@""];
                }
            }
        }];
    }
    else {
        for (NSString *tempString in arrayStrings) {
            stringResult = [stringResult stringByAppendingString:tempString];
        }
    }
    return stringResult;
}

- (NSString *) ymMD5String {
    if (!self.length) return nil;
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG) strlen(cStr), digest );
    NSMutableString *stringOutput = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [stringOutput appendFormat:@"%02x", digest[i]];
    return  stringOutput;
}

+ (NSString *) ymUUID {
    return [UIDevice currentDevice].identifierForVendor.UUIDString;
}

- (BOOL) ymIsStringValued {
    if (self) {
        if (self.length && ![self isEqualToString:@"(null)"]) {
            return YES;
        }
    }
    return false;
}

- (NSMutableAttributedString *) ymMAttributeString {
    if ([self isKindOfClass:[NSString class]])
        if (self.ymIsStringValued)
            return [[NSMutableAttributedString alloc] initWithString:self];
    return nil;
}

- (NSMutableAttributedString *) ymColor : (UIColor *) color {
    return [NSMutableAttributedString ymAttributeWithColor:color
                                                withString:self];
}

@end
