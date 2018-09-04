//
//  NSString+MQExtension.m
//  MQExtensionKit
//
//  Created by 冯明庆 on 2017/4/11.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "NSString+MQExtension.h"

#import "NSDate+MQExtension.h"
#import "NSObject+MQExtension.h"
#import "NSPredicate+MQExtension.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (MQExtension)

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

+ (instancetype) mq_merge : (BOOL) is_need_break
                  spacing : (BOOL) is_need_spacing
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
    return [self mq_merge:arrayStrings
               need_break:is_need_break
                  spacing:is_need_spacing];
}
+ (instancetype) mq_merge : (NSArray <NSString *> *) array_strings
               need_break : (BOOL) is_need_break
                  spacing : (BOOL) is_need_spacing {
    __block NSString *string_result = @"";
    if (is_need_break) {
        [array_strings enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[NSString class]]) {
                string_result = [string_result stringByAppendingString:(NSString *) obj];
                if (idx != (array_strings.count - 1)) {
                    string_result = [string_result stringByAppendingString:@"\n"];
                }
            }
        }];
    }
    else if (is_need_spacing) {
        [array_strings enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[NSString class]]) {
                string_result = [string_result stringByAppendingString:(NSString *) obj];
                if (idx != (array_strings.count - 1)) {
                    string_result = [string_result stringByAppendingString:@""];
                }
            }
        }];
    }
    else {
        for (NSString *temp_string in array_strings) {
            string_result = [string_result stringByAppendingString:temp_string];
        }
    }
    return string_result;
}

/// for localizedString
+ (instancetype) mq_localized : (NSString *) s_key
                      comment : (NSString *) s_comment {
    return [self mq_localized:s_key
                       bundle:NSBundle.mainBundle
                      comment:s_comment];
}
+ (instancetype) mq_localized : (NSString *) s_key
                       bundle : (NSBundle *) bundle
                      comment : (NSString *) s_comment {
    return [self mq_localized:s_key
                      strings:@"Localizable"
                       bundle:bundle
                      comment:s_comment];
}
/// key , strings file , bundle , comment
+ (instancetype) mq_localized : (NSString *) s_key
                      strings : (NSString *) s_strings
                       bundle : (NSBundle *) bundle
                      comment : (NSString *) s_comment {
    if (!bundle) bundle = NSBundle.mainBundle;
    if (!s_strings) s_strings = @"Localizable";
    NSString *s = NSLocalizedStringFromTableInBundle(s_key, s_strings, bundle, nil);
#if DEBUG
    if (!(s && s.length)) NSLog(@"string Key Named \"%@\" not found , return @\"\" istead",s_key);
#endif
    return ((s && s.length) ? s : @"");
}

+ (instancetype) mq_localized : (Class) cls
                       module : (NSString *) s_module
                      strings : (NSString *) s_strings
                          key : (NSString *) s_key
                      comment : (NSString *) s_comment {
    NSBundle *b = [NSBundle bundleForClass:cls];
    NSString *s = nil;
    if (s_module && s_module.length) {
        s_module = [s_module stringByReplacingOccurrencesOfString:@"/" withString:@""];
        NSString *p = [b pathForResource:s_module
                                  ofType:@"bundle"
                             inDirectory:nil];
        NSBundle *bS = [NSBundle bundleWithPath:p];
        s = NSLocalizedStringFromTableInBundle(s_key, s_strings, bS, nil);
    }
    else s = NSLocalizedStringFromTableInBundle(s_key, s_strings, b, nil);
#if DEBUG
    if (!(s && s.length)) NSLog(@"string Key Named \"%@\" in module \"%@\" not found , return @\"\" istead",s_key,s_module);
#endif
    return ((s && s.length) ? s : @"");
}

- (NSRange)range_full {
    return NSMakeRange(0, self.length);
}

@end

#pragma mark - -----

@implementation NSString (MQExtension_Convert)

- (NSInteger)to_integer {
    return self.integerValue;
}
- (long long)to_longlong {
    return self.longLongValue;
}
- (int)to_int {
    return self.intValue;
}
- (BOOL)to_bool {
    return self.boolValue;
}
- (float)to_float {
    return self.floatValue;
}
- (double)to_double {
    return self.doubleValue;
}
- (NSData *)to_data {
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSDecimalNumber *)to_decimal {
    return [NSDecimalNumber decimalNumberWithString:self];
}

- (NSString *)to_MD5 {
    if (!MQ_IS_STRING_VALUED(self)) return nil;
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG) strlen(cStr), digest );
    NSMutableString *stringOutput = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [stringOutput appendFormat:@"%02x", digest[i]];
    return  stringOutput;
}
- (NSString *)to_SHA1 {
    if (!MQ_IS_STRING_VALUED(self)) return nil;
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
- (NSString *)to_base64 {
    if (!MQ_IS_STRING_VALUED(self)) return nil;
    NSData *d = self.to_data;
    if (d && d.length) {
        return [d base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    }
    else return nil;
}
- (NSString *)to_base64_decode {
    NSData *d = [[NSData alloc] initWithBase64EncodedString:self
                                                    options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
}
- (NSString *)to_url_encoded {
    
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
- (NSString *)to_url_decoded {
    NSString *sEncode = self;
    NSString *sDecode = nil;
    sDecode = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                    (__bridge CFStringRef)sEncode,
                                                                                                    CFSTR(""),
                                                                                                    CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return sDecode;
}

- (CGRect)to_rect {
    return CGRectFromString(self);
}

- (NSString *)to_pinyin {
    return [self mq_convert_to_PinYin:YES
                                marks:false];
}
- (NSString *)to_pinyin_marks {
    return [self mq_convert_to_PinYin:YES
                                marks:YES];
}
- (instancetype) mq_convert_to_PinYin : (BOOL) is_uppercase
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
NSString * MQ_STRING_FROM_UTF8(const char * cUTF8) {
    if (cUTF8 && (*cUTF8 != '\0')) {
        return [NSString stringWithUTF8String:cUTF8];
    }
    return nil;
}

@end

#pragma mark - ----- 

@implementation NSString (MQExtension_Filter)

- (BOOL)is_pure_letter {
    NSString *s_letter = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
    return [self mq_is_constructed_by:s_letter];
}

- (BOOL)is_pure_number {
    NSString *s_number = @"0123456789";
    return [self mq_is_constructed_by:s_number];
}

- (BOOL)is_pure_number_and_letter {
    NSString *s_number_letter = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    return [self mq_is_constructed_by:s_number_letter];
}

- (BOOL)is_contains_emoji {
    __block BOOL is_contain = NO;
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        
        const unichar hs = [substring characterAtIndex:0];
        // surrogate pair
        if (0xd800 <= hs && hs <= 0xdbff) {
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f77f) {
                    is_contain = YES;
                }
            }
        } else if (substring.length > 1) {
            const unichar ls = [substring characterAtIndex:1];
            if (ls == 0x20e3) {
                is_contain = YES;
            }
        } else {
            // non surrogate
            if (0x2100 <= hs && hs <= 0x27ff) {
                is_contain = YES;
            } else if (0x2B05 <= hs && hs <= 0x2b07) {
                is_contain = YES;
            } else if (0x2934 <= hs && hs <= 0x2935) {
                is_contain = YES;
            } else if (0x3297 <= hs && hs <= 0x3299) {
                is_contain = YES;
            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                is_contain = YES;
            }
        }
    }];
    return is_contain;
}

- (BOOL)is_contains_chinese {
    for(int i = 0 ; i < self.length ; i++){
        int s = [self characterAtIndex:i];
        if(s > 0x4e00 && s < 0x9fff) return YES ;
    }
    return false;
}

- (BOOL) mq_is_constructed_by : (NSString *) s_content {
    NSCharacterSet *t_set = [[NSCharacterSet characterSetWithCharactersInString:s_content] invertedSet];
    NSString *s_filter = [[self componentsSeparatedByCharactersInSet:t_set] componentsJoinedByString:@""];
    return [self isEqualToString:s_filter];
}

@end
