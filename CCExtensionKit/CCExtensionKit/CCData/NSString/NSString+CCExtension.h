//
//  NSString+CCExtension.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/11.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef CC_LOCALIZED_S
    #define CC_LOCALIZED_S(_vKey_,_vComment_) [NSString ccLocalized:(_vKey_) comment:(_vComment_)]
#endif

@interface NSString (CCExtension)

@property (nonatomic , copy , readonly) NSString *(^s)(id value) ; // append string
@property (nonatomic , copy , readonly) NSString *(^p)(id value) ; // append path

/// break has the topest priority .
+ (instancetype) ccMerge : (BOOL) isNeedBreak
                 spacing : (BOOL) isNeedSpacing
                    with : (NSString *) string , ... NS_REQUIRES_NIL_TERMINATION;
+ (instancetype) ccMerge : (NSArray <NSString *> *) arrayStrings
                  nBreak : (BOOL) isNeedBreak
                 spacing : (BOOL) isNeedSpacing ;

/// for localizedString
+ (instancetype) ccLocalized : (NSString *) sKey
                     comment : (NSString *) sComment ;
+ (instancetype) ccLocalized : (NSString *) sKey
                      bundle : (NSBundle *) bundle
                     comment : (NSString *) sComment ;
/// key , strings file , bundle , comment
+ (instancetype) ccLocalized : (NSString *) sKey
                     strings : (NSString *) sStrings
                      bundle : (NSBundle *) bundle
                     comment : (NSString *) sComment ;

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

/// only numbers .
@property (nonatomic , readonly) NSDecimalNumber * toDecimal;
/// yyyy-MM-dd HH:mm:ss
@property (nonatomic , readonly) NSDate * toDate;

- (instancetype) ccTimeStick : (BOOL) isNeedSpace ;
/// mil-senconds -> yyyy-MM-dd HH:mm
@property (nonatomic , readonly) NSString *toTimeStick ;
@property (nonatomic , readonly) NSString *toMD5 ;
@property (nonatomic , readonly) NSString *toSHA1 ;
@property (nonatomic , readonly) NSString *toBase64 ; // encode base 64 usign origin
@property (nonatomic , readonly) NSString *toBase64Decode ; // decode base 64 using origin

@end
