//
//  NSString+MQExtension.h
//  MQExtensionKit
//
//  Created by 冯明庆 on 2017/4/11.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MQExtensionConst.h"

#ifndef MQ_LOCALIZED_S
    #define MQ_LOCALIZED_S(_v_key_,_v_comment_) mq_localized_string(_v_key_,_v_comment_)
#endif

#ifndef MQ_LOCALIZED_B
    #define MQ_LOCALIZED_B(_v_module_,_v_strings_,_v_key_,_v_comment_) \
        mq_localized_string_module([self class],_v_module_,_v_strings_,_v_key_,_v_comment_)
#endif

@interface NSString (MQExtension)

/// note : the string that uses these blocks blow , can't be nil. or went crash . 使用 s 和 p 的字符串不能为 nil , 否则崩溃

/// append string // 追加 string
@property (nonatomic , copy , readonly) __kindof NSString *(^s)(id value) ;
/// append path // 追加 路径
@property (nonatomic , copy , readonly) __kindof NSString *(^p)(id value) ;
/// equals "substringFromIndex:"
@property (nonatomic , copy , readonly) __kindof NSString *(^sub_from)(NSUInteger index) ;
/// equals "substringToIndex:"
@property (nonatomic , copy , readonly) __kindof NSString *(^sub_to)(NSUInteger index) ;
/// equals "substringWithRange:"
@property (nonatomic , copy , readonly) __kindof NSString *(^sub_range)(NSUInteger location , NSUInteger length) ;
/// remove specific length of characters in string (from tail to head) . // 移除特定长度的字符串 (从 尾 到 头).
@property (nonatomic , copy , readonly) __kindof NSString *(^sub_drop_tail)(NSUInteger length) ;
/// remove specific length of characters in string (from head to tail) . // 移除特定长度的字符串 (从 头 到 尾).
@property (nonatomic , copy , readonly) __kindof NSString *(^sub_drop_header)(NSUInteger length) ;

/// for localizedString == MQ_LOCALIZED_S(...) // 本地化字符串
NSString * mq_localized_string(NSString *s_key , NSString *s_comment);
NSString * mq_localized_string_bundle(NSBundle *bundle , NSString *s_key , NSString *s_comment);
/// bundle , strings file , key , comment // bundle , 字符串文件 , key , 注释
NSString * mq_localized_string_specific(NSBundle *bundle ,
                                        NSString *s_strings_name ,
                                        NSString *s_key ,
                                        NSString *s_comment);
/// for those used in subspecs == MQ_LOCALIZED_B(...). // 适用于在 subspec 中的资源
NSString * mq_localized_string_module(Class cls ,
                                      NSString *s_module_name ,
                                      NSString *s_strings_name ,
                                      NSString *s_key ,
                                      NSString *s_comment);
    
@property (nonatomic , assign , readonly) NSRange range_full ;

@end

#pragma mark - -----

@interface NSString (MQExtension_Convert)

@property (nonatomic , readonly) NSInteger to_integer ;
@property (nonatomic , readonly) long long to_longlong ;
@property (nonatomic , readonly) int to_int;
@property (nonatomic , readonly) BOOL to_bool ;
@property (nonatomic , readonly) float to_float ;
@property (nonatomic , readonly) double to_double ;
@property (nonatomic , readonly) NSData *to_data ; // [self dataUsingEncoding:NSUTF8StringEncoding];

#ifndef __IPHONE_13_0
@property (nonatomic , readonly) NSString *to_MD5 ;
#endif
@property (nonatomic , readonly) NSString *to_SHA1 ;
@property (nonatomic , readonly) NSString *to_base64 ; // encode base 64 usign origin // 使用原生进行 base64 编码
@property (nonatomic , readonly) NSString *to_base64_decode ; // decode base 64 using origin // 使用原生进行 base 64 解码
@property (nonatomic , readonly) NSString *to_url_encoded ; // encode chinese character using origin // 针对中文进行 url 编码
@property (nonatomic , readonly) NSString *to_url_decoded ; // decode chinese character using origin // 针对中文进行 url 解码
@property (nonatomic , readonly) CGRect to_rect ; // only worked in which NSStringFromCGRect(CGRect rect) converted . 只针对 NSStringFromCGRect(CGRect rect) 转换的有效

/// only for chinese charactors . // 只针对汉字有效
/// default uppercase . // 默认大写 .
@property (nonatomic , readonly) NSString * to_pinyin ; // without marks . // 不带音标
@property (nonatomic , readonly) NSString * to_pinyin_marks ; // with marks . // 带音标
- (instancetype) mq_convert_to_PinYin : (BOOL) is_uppercase
                                marks : (BOOL) is_need_marks ;

@property (nonatomic , readonly) const char * to_UTF8 NS_RETURNS_INNER_POINTER;
NSString * MQ_STRING_FROM_UTF8(const char * c_UTF8) ; // if params doesn't exist , return @"". // 如果参数不存在 , 返回 @""

@end

#pragma mark - -----

@interface NSString (MQExtension_Filter)

@property (nonatomic , readonly) BOOL is_pure_letter ;
@property (nonatomic , readonly) BOOL is_pure_number ;
@property (nonatomic , readonly) BOOL is_pure_number_and_letter ;
@property (nonatomic , readonly) BOOL is_contains_emoji ;
@property (nonatomic , readonly) BOOL is_contains_chinese ;

/// detect that a string is constructed by the characters in params you gave . // 检查字符串是否由参数中所给定的字符串中的字符构成
- (BOOL) mq_is_constructed_by : (NSString *) s_content ;
    
/// using ASCII to estimate a character is fit the given condition . // 使用 ASCII 去判断字符是否符合e给出的条件 .
// note : emoji is sth that very special . some emoji contains two or more characters . thus it can't be processed as normal string . using [NSString.instance is_contains_emoji] above to decide whether this string contains an emoji .
// 注意 : emoji 是i一种很特殊的字符 . 一些 emoji 包含了 两个甚至多个字符 . 所以 它不能被当做普通字符串来处理 . 使用上方的 [NSString.instance is_contains_emoji] 来判定这个字符是否包含了 emoji .
    
BOOL mq_is_char_pure_letter(unichar c , BOOL is_uppercasing);
BOOL mq_is_char_pure_number(unichar c);
BOOL mq_is_char_pure_chinese_character(unichar c);
BOOL mq_is_pure_white_space(unichar c);
    
/// dynamic to custom the filter condition . // 动态定义判断条件 .
- (BOOL) mq_filter_string_with_character_enumerater : (BOOL (^)(unichar c , NSUInteger index)) character_enumerater ;

@end

#pragma mark - -----

@interface NSString (MQExtension_FitHeight)

/// note: all the fit recalls ignores the text-indent . // 所有适应无视缩进

/// system font size , default line break mode , system font size // 默认 系统字体 , line break mode
CGFloat MQ_TEXT_HEIGHT_S(CGFloat f_width ,
                         CGFloat f_estimate_height , // height that defualt to , if less than , return's it. (same below) // 默认高度 , 小于则返回它 (下同)
                         NSString *s);
CGFloat MQ_TEXT_HEIGHT_C(CGFloat f_width ,
                         CGFloat f_estimate_height ,
                         NSString *s ,
                         UIFont *font ,
                         NSLineBreakMode mode);

/// for attributed string , Using system attributed auto fit // 针对富文本 , 使用系统进行自适应
CGFloat MQ_TEXT_HEIGHT_A(CGFloat f_width ,
                         CGFloat f_estimate_height ,
                         NSAttributedString *s_attr);

/// using default for NSString // 使用 NSString 的默认设置
CGFloat MQ_TEXT_HEIGHT_AS(CGFloat f_width ,
                          CGFloat f_estimate_height ,
                          NSString *s ,
                          UIFont *font ,
                          NSLineBreakMode mode ,
                          CGFloat f_line_spacing ,
                          CGFloat f_character_spacing);

@end

#pragma mark - ----- ###########################################################

@interface NSString (MQExtension_Deprecated)

/// break has the topest priority . // 回车拥有最高优先级
+ (instancetype) mq_merge : (BOOL) is_need_break
                  spacing : (BOOL) is_need_spacing
                     with : (NSString *) string , ... NS_REQUIRES_NIL_TERMINATION MQ_EXTENSION_DEPRECATED("deprecated . use 's' && 'p' block . // 弃用 , 使用 's' 和 'p' 块代码 .");
+ (instancetype) mq_merge : (NSArray <NSString *> *) array_strings
               need_break : (BOOL) is_need_break
                  spacing : (BOOL) is_need_spacing MQ_EXTENSION_DEPRECATED("deprecated . use 's' && 'p' block . // 弃用 , 使用 's' 和 'p' 块代码 .");
    
+ (instancetype) mq_localized : (NSString *) s_key
                      comment : (NSString *) s_comment MQ_EXTENSION_DEPRECATED("deprecated . use 'mq_localized_string' . // 弃用 , 使用 'mq_localized_string'.");
+ (instancetype) mq_localized : (NSString *) s_key
                       bundle : (NSBundle *) bundle
                      comment : (NSString *) s_comment MQ_EXTENSION_DEPRECATED("deprecated . use 'mq_localized_string_bundle' . // 弃用 , 使用 'mq_localized_string_bundle'.");
+ (instancetype) mq_localized : (NSString *) s_key
                      strings : (NSString *) s_strings
                       bundle : (NSBundle *) bundle
                      comment : (NSString *) s_comment MQ_EXTENSION_DEPRECATED("deprecated . use 'mq_localized_string_specific' . // 弃用 , 使用 'mq_localized_string_specific' .");
+ (instancetype) mq_localized : (Class) cls
                       module : (NSString *) s_module
                      strings : (NSString *) s_strings
                          key : (NSString *) s_key
                      comment : (NSString *) s_comment MQ_EXTENSION_DEPRECATED("deprecated . use 'mq_localized_string_module' . // 弃用 , 使用 'mq_localized_string_module' .");
    
@end
