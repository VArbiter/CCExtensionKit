//
//  NSString+CCExtension.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/11.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "NSString+CCExtension.h"

#import "NSDate+CCExtension.h"
#import "NSObject+CCExtension.h"
#import "NSPredicate+CCExtension.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (CCExtension)

- (NSString *(^)(id))s {
    __weak typeof(self) pSelf = self;
    return ^NSString *(id value) {
        if ([value isKindOfClass:NSString.class]) {
            return ((NSString *)value).length > 0 ? [pSelf stringByAppendingString:(NSString *)value] : pSelf;
        }
        return [pSelf stringByAppendingString:[NSString stringWithFormat:@"%@",value]];
    };
}

- (NSString *(^)(id))p {
    __weak typeof(self) pSelf = self;
    return ^NSString *(id value) {
        if ([value isKindOfClass:NSString.class]) {
            return ((NSString *)value).length > 0 ? [pSelf stringByAppendingPathComponent:(NSString *)value] : pSelf;
        }
        return [pSelf stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",value]];
    };
}

+ (instancetype) ccMerge : (BOOL) isNeedBreak
                 spacing : (BOOL) isNeedSpacing
                    with : (NSString *) string , ... NS_REQUIRES_NIL_TERMINATION {
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
    free(argumentList);
    return [self ccMerge:arrayStrings
                  nBreak:isNeedBreak
                 spacing:isNeedSpacing];
}
+ (instancetype) ccMerge : (NSArray <NSString *> *) arrayStrings
                  nBreak : (BOOL) isNeedBreak
                 spacing : (BOOL) isNeedSpacing {
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

/// for localizedString
+ (instancetype) ccLocalized : (NSString *) sKey
                     comment : (NSString *) sComment {
    return [self ccLocalized:sKey
                      bundle:NSBundle.mainBundle
                     comment:sComment];
}
+ (instancetype) ccLocalized : (NSString *) sKey
                      bundle : (NSBundle *) bundle
                     comment : (NSString *) sComment {
    return [self ccLocalized:sKey
                     strings:@"Localizable"
                      bundle:bundle
                     comment:sComment];
}
/// key , strings file , bundle , comment
+ (instancetype) ccLocalized : (NSString *) sKey
                     strings : (NSString *) sStrings
                      bundle : (NSBundle *) bundle
                     comment : (NSString *) sComment {
    if (!bundle) bundle = NSBundle.mainBundle;
    if (!sStrings) sStrings = @"Localizable";
    NSString *s = NSLocalizedStringFromTableInBundle(sKey, sStrings, bundle, nil);
#if DEBUG
    if (!(s && s.length)) NSLog(@"string Key Named \"%@\" not found , return @\"\" istead",sKey);
#endif
    return ((s && s.length) ? s : @"");
}

@end

#pragma mark - -----

@implementation NSString (CCExtension_Convert)

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
- (NSData *)toData {
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSDecimalNumber *)toDecimal {
    return [NSDecimalNumber decimalNumberWithString:self];
}

- (NSDate *)toDate {
    if (!self.isTime.isStringValued) {
        return [NSDate date];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    return [formatter dateFromString:self];
}

- (instancetype) ccTimeStick : (BOOL) isNeedSpace {
    if (isNeedSpace) {
        return self.s(@" ").s(self.toTimeStick);
    }
    return self.s(self.toTimeStick);
}
- (NSString *)toTimeStick {
    NSDate *date = self.toDate;
    if (!date) {
        return @"";
    }
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:date];
    
    long interval = (long) timeInterval;
    if (timeInterval / (60 * 60 * 24 * 30) >= 1 ) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
        return [formatter stringFromDate:date];
    }
    else if (timeInterval / (60 * 60 * 24) >= 1) {
        return [NSString stringWithFormat:@"%ld %@",interval / (60 * 60 * 24) , [NSString ccLocalized:@"_CC_DAYS_AGO_" comment:@"天前"]];
    }
    else if (timeInterval / (60 * 60) >= 1) {
        return [NSString stringWithFormat:@"%ld %@",interval / (60 * 60) , [NSString ccLocalized:@"_CC_HOURS_AGO_" comment:@"小时前"]];
    }
    else if (timeInterval / 60 >= 1) {
        return [NSString stringWithFormat:@"%ld %@",interval / 60 , [NSString ccLocalized:@"_CC_MINUTES_AGO_" comment:@"分钟前"]];
    }
    else return [NSString ccLocalized:@"_CC_AGO_" comment:@"刚刚"];
}
- (NSString *)toMD5 {
    if (!self.length) return @"";
    const char *cStr = [self.isStringValued UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG) strlen(cStr), digest );
    NSMutableString *stringOutput = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [stringOutput appendFormat:@"%02x", digest[i]];
    return  stringOutput;
}
- (NSString *)toSHA1 {
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    // length
    // CC_SHA1 20,
    // CC_SHA256 32,
    // CC_SHA384 48,
    // CC_SHA512 64
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    //CC_SHA256, CC_SHA384, CC_SHA512
    CC_SHA1(data.bytes, (CC_LONG)(data.length), digest);
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) [output appendFormat:@"%02x", digest[i]];
    return output;
}
- (NSString *)toBase64 {
    NSData *d = self.toData;
    if (d && d.length) {
        return [d base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    }
    else return @"";
}
- (NSString *)toBase64Decode {
    NSData *d = [[NSData alloc] initWithBase64EncodedString:self
                                                    options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
}
- (NSString *)toUrlEncoded {
    
    // CharactersToBeEscaped = @":/?&=;+!@#$()~',*";
    // CharactersToLeaveUnescaped = @"[].";
    
    NSString *sUnencode = self;
    NSString *sEncode = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)sUnencode,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    return sEncode;
}
- (NSString *)toUrlDecoded {
    NSString *sEncode = self;
    NSString *sDecode = nil;
    sDecode = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                    (__bridge CFStringRef)sEncode,
                                                                                                    CFSTR(""),
                                                                                                    CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return sDecode;
}

@end
