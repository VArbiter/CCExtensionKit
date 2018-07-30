//
//  NSString+MQExtension.h
//  MQExtensionKit
//
//  Created by 冯明庆 on 2017/4/11.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef CC_LOCALIZED_S
    #define CC_LOCALIZED_S(_vKey_,_vComment_) [NSString mq_localized:(_vKey_) comment:(_vComment_)]
#endif

#ifndef CC_LOCALIZED_B
    #define CC_LOCALIZED_B(_vModule_,_vStrings_,_vKey_,_vComment_) \
        [NSString mq_localized:self.class module:(_vModule_) strings:(_vStrings_) key:(_vKey_) comment:(_vComment_)];
#endif

@interface NSString (CCExtension)

/// note : the string that use 's' && 'p' can't be nil. or went crash . 使用 s 和 p 的字符串不能为 nil , 否则崩溃
@property (nonatomic , copy , readonly) NSString *(^s)(id value) ; // append string // 追加 string
@property (nonatomic , copy , readonly) NSString *(^p)(id value) ; // append path // 追加 路径

/// break has the topest priority . // 回车拥有最高优先级
+ (instancetype) mq_merge : (BOOL) isNeedBreak
                 spacing : (BOOL) isNeedSpacing
                    with : (NSString *) string , ... NS_REQUIRES_NIL_TERMINATION;
+ (instancetype) mq_merge : (NSArray <NSString *> *) arrayStrings
               need_break : (BOOL) isNeedBreak
                  spacing : (BOOL) isNeedSpacing ;

/// for localizedString == CC_LOCALIZED_S(...) // 本地化字符串
+ (instancetype) mq_localized : (NSString *) sKey
                      comment : (NSString *) sComment ;
+ (instancetype) mq_localized : (NSString *) sKey
                       bundle : (NSBundle *) bundle
                      comment : (NSString *) sComment ;
/// key , strings file , bundle , comment // key , 字符串文件 , bundle , 注释
+ (instancetype) mq_localized : (NSString *) sKey
                      strings : (NSString *) sStrings
                       bundle : (NSBundle *) bundle
                      comment : (NSString *) sComment ;

/// for those used in subspecs == CC_LOCALIZED_B(...). // 适用于在 subspec 中的资源
+ (instancetype) mq_localized : (Class) cls
                       module : (NSString *) sModule
                      strings : (NSString *) sStrings
                          key : (NSString *) sKey
                      comment : (NSString *) sComment ;

@property (nonatomic , assign , readonly) NSRange range_full ;

@end

#pragma mark - -----

@interface NSString (CCExtension_Convert)

@property (nonatomic , readonly) NSInteger toInteger ;
@property (nonatomic , readonly) long long toLonglong ;
@property (nonatomic , readonly) int toInt;
@property (nonatomic , readonly) BOOL toBool ;
@property (nonatomic , readonly) float toFloat ;
@property (nonatomic , readonly) double toDouble ;
@property (nonatomic , readonly) NSData *toData ; // [self dataUsingEncoding:NSUTF8StringEncoding];

/// only numbers . // 只针对数字字符起效
@property (nonatomic , readonly) NSDecimalNumber * toDecimal;

/// mil-senconds -> yyyy-MM-dd HH:mm
@property (nonatomic , readonly) NSString *toTimeStick ;
@property (nonatomic , readonly) NSString *toMD5 ;
@property (nonatomic , readonly) NSString *toSHA1 ;
@property (nonatomic , readonly) NSString *toBase64 ; // encode base 64 usign origin // 使用原生进行 base64 编码
@property (nonatomic , readonly) NSString *toBase64Decode ; // decode base 64 using origin // 使用原生进行 base 64 解码
@property (nonatomic , readonly) NSString *toUrlEncoded ; // encode chinese character using origin // 针对中文进行 url 编码
@property (nonatomic , readonly) NSString *toUrlDecoded ; // decode chinese character using origin // 针对中文进行 url 解码
@property (nonatomic , readonly) CGRect toRect ; // only worked in which NSStringFromCGRect(CGRect rect) converted . 只针对 NSStringFromCGRect(CGRect rect) 转换的有效

/// only for chinese charactors . // 只针对汉字有效
/// default uppercase . // 默认大写 .
@property (nonatomic , readonly) NSString * toPinYin ; // without marks . // 不带音标
@property (nonatomic , readonly) NSString * toPinYin_marks ; // with marks . // 带音标
- (instancetype) mq_convert_to_PinYin : (BOOL) is_uppercase
                                marks : (BOOL) is_need_marks ;

@property (nonatomic , readonly) const char * toUTF8 NS_RETURNS_INNER_POINTER ; // might null if can't be convert // 如果不能被转换 , 返回 NULL
NSString * CC_STRING_FROM_UTF8(const char * cUTF8) ; // if params doesn't exist , return @"". // 如果参数不存在 , 返回 @"" 

@end

#pragma mark - -----

@interface NSString (CCExtension_Filter)

@property (nonatomic , readonly) BOOL is_pure_letter ;
@property (nonatomic , readonly) BOOL is_pure_number ;
@property (nonatomic , readonly) BOOL is_pure_number_and_letter ;
@property (nonatomic , readonly) BOOL is_contains_emoji ;

/// detect that a string is constructed by the characters in params you gave . // 检查字符串是否由参数中所给定的字符串中的字符构成
- (BOOL) mq_is_constructed_by : (NSString *) s_content ;

@end
