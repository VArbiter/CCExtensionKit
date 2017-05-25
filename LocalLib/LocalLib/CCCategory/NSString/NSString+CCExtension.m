//
//  NSString+CCExtension.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/11.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "NSString+CCExtension.h"

#import "NSDate+CCExtension.h"
#import <CommonCrypto/CommonDigest.h>

#import "NSMutableAttributedString+CCExtension.h"

#import "CCCommonDefine.h"

@implementation NSString (CCExtension)

- (NSDecimalNumber *) ccDecimalValue {
    return [NSDecimalNumber decimalNumberWithString:self];
}

- (NSString *) ccTimeStick {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSDate *date = [formatter dateFromString:self];
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:date];
    
    long interval = (long) timeInterval;
    if (timeInterval / (60 * 60 * 24 * 30) >= 1 ) {
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

- (NSUInteger) ccIntegerDays {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSDate *date = [formatter dateFromString:self];
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:date];
    return timeInterval / (60 * 60 * 24);
}

- (NSString *) ccTimeStickWeekDays {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSDate *date = [formatter dateFromString:self];
    return date.ccWeekDays;
}

- (NSString *) ccTimeSince1970 : (NSTimeInterval) interval {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *string = [formatter stringFromDate:date];
    return string;
}

- (NSDate *) ccDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    return [formatter dateFromString:self];
}

+ (NSString *) ccMergeNeedLineBreak : (BOOL) isNeedBreak
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
    
    return [self ccMergeWithStringArray:arrayStrings
                      withNeedLineBreak:isNeedBreak
                        withNeedSpacing:isNeedSpacing];
}

+ (NSString *) ccMergeWithStringArray : (NSArray <NSString *> *) arrayStrings
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

- (NSString *) ccMD5String {
    if (!self.length) return nil;
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG) strlen(cStr), digest );
    NSMutableString *stringOutput = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [stringOutput appendFormat:@"%02x", digest[i]];
    return  stringOutput;
}

+ (NSString *) ccUUID {
    return [UIDevice currentDevice].identifierForVendor.UUIDString;
}

- (NSMutableAttributedString *) ccMAttributeString {
    if ([self isKindOfClass:[NSString class]])
        if (self.ccIsStringValued)
            return [[NSMutableAttributedString alloc] initWithString:self];
    return nil;
}

- (NSMutableAttributedString *) ccColor : (UIColor *) color {
    return [NSMutableAttributedString ccAttributeWithColor:color
                                                withString:self];
}

@end
