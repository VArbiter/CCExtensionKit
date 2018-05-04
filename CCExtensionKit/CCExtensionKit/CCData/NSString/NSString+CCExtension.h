//
//  NSString+CCExtension.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/11.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef CC_LOCALIZED_S
    #define CC_LOCALIZED_S(_vKey_,_vComment_) [NSString cc_localized:(_vKey_) comment:(_vComment_)]
#endif

#ifndef CC_LOCALIZED_B
    #define CC_LOCALIZED_B(_vModule_,_vStrings_,_vKey_,_vComment_) \
        [NSString cc_localized:self.class module:(_vModule_) strings:(_vStrings_) key:(_vKey_) comment:(_vComment_)];
#endif

@interface NSString (CCExtension)

/// note : the string that use 's' && 'p' can't be nil. or went crash . 使用 s 和 p 的字符串不能为 nil , 否则崩溃
@property (nonatomic , copy , readonly) NSString *(^s)(id value) ; // append string // 追加 string
@property (nonatomic , copy , readonly) NSString *(^p)(id value) ; // append path // 追加 路径

/// break has the topest priority . // 回车拥有最高优先级
+ (instancetype) cc_merge : (BOOL) isNeedBreak
                 spacing : (BOOL) isNeedSpacing
                    with : (NSString *) string , ... NS_REQUIRES_NIL_TERMINATION;
+ (instancetype) cc_merge : (NSArray <NSString *> *) arrayStrings
               need_break : (BOOL) isNeedBreak
                  spacing : (BOOL) isNeedSpacing ;

/// for localizedString == CC_LOCALIZED_S(...) // 本地化字符串
+ (instancetype) cc_localized : (NSString *) sKey
                      comment : (NSString *) sComment ;
+ (instancetype) cc_localized : (NSString *) sKey
                       bundle : (NSBundle *) bundle
                      comment : (NSString *) sComment ;
/// key , strings file , bundle , comment // key , 字符串文件 , bundle , 注释
+ (instancetype) cc_localized : (NSString *) sKey
                      strings : (NSString *) sStrings
                       bundle : (NSBundle *) bundle
                      comment : (NSString *) sComment ;

/// for those used in subspecs == CC_LOCALIZED_B(...). // 适用于在 subspec 中的资源
+ (instancetype) cc_localized : (Class) cls
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

@property (nonatomic , readonly) const char * toUTF8 NS_RETURNS_INNER_POINTER ; // might null if can't be convert // 如果不能被转换 , 返回 NULL
NSString * CC_STRING_FROM_UTF8(const char * cUTF8) ; // if params doesn't exist , return @"". // 如果参数不存在 , 返回 @"" 

@end
