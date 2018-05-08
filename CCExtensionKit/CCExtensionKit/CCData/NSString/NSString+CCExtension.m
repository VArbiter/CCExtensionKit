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

+ (instancetype) cc_merge : (BOOL) isNeedBreak
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
    return [self cc_merge:arrayStrings
               need_break:isNeedBreak
                  spacing:isNeedSpacing];
}
+ (instancetype) cc_merge : (NSArray <NSString *> *) arrayStrings
               need_break : (BOOL) isNeedBreak
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
+ (instancetype) cc_localized : (NSString *) sKey
                      comment : (NSString *) sComment {
    return [self cc_localized:sKey
                       bundle:NSBundle.mainBundle
                      comment:sComment];
}
+ (instancetype) cc_localized : (NSString *) sKey
                       bundle : (NSBundle *) bundle
                      comment : (NSString *) sComment {
    return [self cc_localized:sKey
                      strings:@"Localizable"
                       bundle:bundle
                      comment:sComment];
}
/// key , strings file , bundle , comment
+ (instancetype) cc_localized : (NSString *) sKey
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

+ (instancetype) cc_localized : (Class) cls
                       module : (NSString *) sModule
                      strings : (NSString *) sStrings
                          key : (NSString *) sKey
                      comment : (NSString *) sComment {
    NSBundle *b = [NSBundle bundleForClass:cls];
    NSString *s = nil;
    if (sModule && sModule.length) {
        sModule = [sModule stringByReplacingOccurrencesOfString:@"/" withString:@""];
        NSString *p = [b pathForResource:sModule
                                  ofType:@"bundle"
                             inDirectory:nil];
        NSBundle *bS = [NSBundle bundleWithPath:p];
        s = NSLocalizedStringFromTableInBundle(sKey, sStrings, bS, nil);
    }
    else s = NSLocalizedStringFromTableInBundle(sKey, sStrings, b, nil);
#if DEBUG
    if (!(s && s.length)) NSLog(@"string Key Named \"%@\" in module \"%@\" not found , return @\"\" istead",sKey,sModule);
#endif
    return ((s && s.length) ? s : @"");
}

- (NSRange)range_full {
    return NSMakeRange(0, self.length);
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

- (NSString *)toMD5 {
    if (!CC_IS_STRING_VALUED(self)) return nil;
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG) strlen(cStr), digest );
    NSMutableString *stringOutput = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [stringOutput appendFormat:@"%02x", digest[i]];
    return  stringOutput;
}
- (NSString *)toSHA1 {
    if (!CC_IS_STRING_VALUED(self)) return nil;
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
    if (!CC_IS_STRING_VALUED(self)) return nil;
    NSData *d = self.toData;
    if (d && d.length) {
        return [d base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    }
    else return nil;
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

- (CGRect)toRect {
    return CGRectFromString(self);
}

- (NSString *)toPinYin {
    return [self cc_convert_to_PinYin:YES
                                marks:false];
}
- (NSString *)toPinYin_marks {
    return [self cc_convert_to_PinYin:YES
                                marks:YES];
}
- (instancetype) cc_convert_to_PinYin : (BOOL) is_uppercase
                                marks : (BOOL) is_need_marks {
    NSMutableString *s_mutable = [self mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)s_mutable, NULL, kCFStringTransformMandarinLatin, NO);
    if (!is_need_marks) {
        // remove marks . // 去除音标 .
        CFStringTransform((__bridge CFMutableStringRef)s_mutable, NULL, kCFStringTransformStripCombiningMarks , NO);
    }
    return is_uppercase ? [s_mutable uppercaseString] : [s_mutable lowercaseString];
}

- (const char *)toUTF8 {
    return self.UTF8String;
}
NSString * CC_STRING_FROM_UTF8(const char * cUTF8) {
    if (cUTF8 && (*cUTF8 != '\0')) {
        return [NSString stringWithUTF8String:cUTF8];
    }
    return nil;
}

@end
