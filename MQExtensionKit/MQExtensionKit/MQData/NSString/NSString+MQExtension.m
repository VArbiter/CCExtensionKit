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

- (__kindof NSString *(^)(id))s {
    __weak typeof(self) weak_self = self;
    return ^__kindof NSString *(id value) {
        __strong typeof(weak_self) strong_self = weak_self;
        if ([value isKindOfClass:NSString.class]) {
            return ((NSString *)value).length > 0 ? [strong_self stringByAppendingString:(NSString *)value] : strong_self;
        }
        return [strong_self stringByAppendingString:[NSString stringWithFormat:@"%@",value]];
    };
}

- (__kindof NSString *(^)(id))p {
    __weak typeof(self) weak_self = self;
    return ^__kindof NSString *(id value) {
        __strong typeof(weak_self) strong_self = weak_self;
        if ([value isKindOfClass:NSString.class]) {
            return ((NSString *)value).length > 0 ? [strong_self stringByAppendingPathComponent:(NSString *)value] : strong_self;
        }
        return [strong_self stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",value]];
    };
}

- (__kindof NSString *(^)(NSUInteger))sub_from {
    __weak typeof(self) weak_self = self;
    return ^__kindof NSString *(NSUInteger index) {
        __strong typeof(weak_self) strong_self = weak_self;
        if (index >= 0 && index <= (strong_self.length - 1)) {
            return [strong_self substringFromIndex:index];
        }
        return @"";
    };
}

- (__kindof NSString *(^)(NSUInteger))sub_to {
    __weak typeof(self) weak_self = self;
    return ^__kindof NSString *(NSUInteger index) {
        __strong typeof(weak_self) strong_self = weak_self;
        if (index >= 0 && index <= (strong_self.length - 1)) {
            return [strong_self substringToIndex:index];
        }
        return @"";
    };
}

- (__kindof NSString *(^)(NSUInteger, NSUInteger))sub_range {
    __weak typeof(self) weak_self = self;
    return ^__kindof NSString *(NSUInteger location , NSUInteger length) {
        __strong typeof(weak_self) strong_self = weak_self;
        
        if (location >=0
            && length >= 0
            && (location + length) < strong_self.length) {
            return [strong_self substringWithRange:NSMakeRange(location, length)];
        }
        else return @"";
        
    };
}

- (__kindof NSString *(^)(NSUInteger))sub_drop_tail {
    __weak typeof(self) weak_self = self;
    return ^__kindof NSString *(NSUInteger length) {
        __strong typeof(weak_self) strong_self = weak_self;
        if (strong_self.length <= length) return @"";
        else return [strong_self substringWithRange:(NSRange){0, strong_self.length - length}];
    };
}

- (__kindof NSString *(^)(NSUInteger))sub_drop_header {
    __weak typeof(self) weak_self = self;
    return ^__kindof NSString *(NSUInteger length) {
        __strong typeof(weak_self) strong_self = weak_self;
        if (strong_self.length <= length) return @"";
        else return [strong_self substringWithRange:(NSRange){length , strong_self.length - length}];
    };
}

+ (instancetype) mq_merge : (BOOL) is_need_break
                  spacing : (BOOL) is_need_spacing
                     with : (NSString *) string , ... NS_REQUIRES_NIL_TERMINATION {
    if (!string || !string.length) return nil;
    
    NSMutableArray *array_strings = [NSMutableArray array];
    NSString *string_temp;
    va_list argument_list;
    if (string) {
        [array_strings addObject:string];
        va_start(argument_list, string);
        while ((string_temp = va_arg(argument_list, id))) {
            [array_strings addObject:string_temp];
        }
        va_end(argument_list);
    }
    free(argument_list);
    return [self mq_merge:array_strings
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
    return NSRangeFromString(self);
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
    if (!mq_is_string_valued(self)) return nil;
    const char *c_str = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( c_str, (CC_LONG) strlen(c_str), digest );
    NSMutableString *s_output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [s_output appendFormat:@"%02x", digest[i]];
    return  s_output;
}
- (NSString *)to_SHA1 {
    if (!mq_is_string_valued(self)) return nil;
    const char *c_str = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:c_str length:self.length];
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
    if (!mq_is_string_valued(self)) return nil;
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

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (NSString *)to_url_encoded {
    
    // CharactersToBeEscaped = @":/?&=;+!@#$()~',*";
    // CharactersToLeaveUnescaped = @"[].";
    
    NSString *s_encoded = nil;
//    NSString *s_characters_to_escape = @"?!@#$^&%*+,:;='\"`<>()~[]{}/\\|";
    NSString *s_characters = @"#%^{}[]|\"<> ";
    if (@available(iOS 9.0, *)) {
        NSCharacterSet *s_allowed_characters = [[NSCharacterSet characterSetWithCharactersInString:s_characters] invertedSet];
        s_encoded = [self stringByAddingPercentEncodingWithAllowedCharacters:s_allowed_characters];
    }
    else {
        NSString *s_unencode = self;
//        @"!*'();:@&=+$,/?%#[]"
        s_encoded = (NSString *)
        CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                  (CFStringRef)s_unencode,
                                                                  NULL,
                                                                  (CFStringRef)s_characters,
                                                                  kCFStringEncodingUTF8));
    }
    
    return s_encoded;
}
- (NSString *)to_url_decoded {
    if (@available(iOS 7.0, *)) {
        return [self stringByRemovingPercentEncoding];
    }
    else {
        NSString *s_encode = self;
        NSString *s_decode = nil;
        s_decode = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                         (__bridge CFStringRef)s_encode,
                                                                                                         CFSTR(""),
                                                                                                         CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
        return s_decode;
    }
}
#pragma clang diagnostic pop

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

- (const char *)to_UTF8 {
    return self.UTF8String;
}
NSString * MQ_STRING_FROM_UTF8(const char * c_UTF8) {
    if (c_UTF8 && (*c_UTF8 != '\0')) {
        return [NSString stringWithUTF8String:c_UTF8];
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

#pragma mark - -----

@implementation NSString (MQExtension_FitHeight)

CGFloat MQ_TEXT_HEIGHT_S(CGFloat f_width , CGFloat f_estimate_height , NSString *s) {
    return MQ_TEXT_HEIGHT_C(f_width,
                            f_estimate_height ,
                            s,
                            [UIFont systemFontOfSize:UIFont.systemFontSize],
                            NSLineBreakByWordWrapping);
}
CGFloat MQ_TEXT_HEIGHT_C(CGFloat f_width ,
                         CGFloat f_estimate_height ,
                         NSString *s ,
                         UIFont *font ,
                         NSLineBreakMode mode) {
    return MQ_TEXT_HEIGHT_AS(f_width,
                             f_estimate_height,
                             s,
                             font,
                             mode,
                             -1,
                             -1);
}

CGFloat MQ_TEXT_HEIGHT_A(CGFloat f_width , CGFloat f_estimate_height , NSAttributedString *s_attr) {
    CGRect rect = [s_attr boundingRectWithSize:(CGSize){f_width , CGFLOAT_MAX}
                                       options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                       context:nil];
    return rect.size.height >= f_estimate_height ? rect.size.height : f_estimate_height;
}
CGFloat MQ_TEXT_HEIGHT_AS(CGFloat f_width ,
                          CGFloat f_estimate_height ,
                          NSString *s ,
                          UIFont *font ,
                          NSLineBreakMode mode ,
                          CGFloat f_line_spacing ,
                          CGFloat f_character_spacing) {
    CGRect rect = CGRectZero;
    NSMutableParagraphStyle *style = NSMutableParagraphStyle.alloc.init;
    style.lineBreakMode = mode;
    if (f_line_spacing >= 0) style.lineSpacing = f_line_spacing;
    
    // kinda awkward . it turns out the differences between the NSMutableDictionary && NSDictionary && NSPlaceHolderDictioanry .
    // 有点尴尬 , 是 可变字典 , 不可变字典 , 字面量字典 之间的区别 .
    if (font && (f_character_spacing >= 0)) {
        rect = [s boundingRectWithSize:(CGSize){f_width , CGFLOAT_MAX}
                               options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                            attributes:@{NSParagraphStyleAttributeName : style,
                                         NSFontAttributeName : font ,
                                         NSKernAttributeName : @(f_character_spacing)}
                               context:nil];
    } else if (font) {
        rect = [s boundingRectWithSize:(CGSize){f_width , CGFLOAT_MAX}
                               options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                            attributes:@{NSParagraphStyleAttributeName : style,
                                         NSFontAttributeName : font}
                               context:nil];
    } else if (f_character_spacing >= 0) {
        rect = [s boundingRectWithSize:(CGSize){f_width , CGFLOAT_MAX}
                               options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                            attributes:@{NSParagraphStyleAttributeName : style,
                                         NSKernAttributeName : @(f_character_spacing)}
                               context:nil];
    } else {
        rect = [s boundingRectWithSize:(CGSize){f_width , CGFLOAT_MAX}
                               options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                            attributes:@{NSParagraphStyleAttributeName : style}
                               context:nil];
    }
    
    return rect.size.height >= f_estimate_height ? rect.size.height : f_estimate_height;
}

@end
