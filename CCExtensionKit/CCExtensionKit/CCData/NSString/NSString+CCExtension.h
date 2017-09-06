//
//  NSString+CCExtension.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/11.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

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

- (NSMutableAttributedString *) ccColor : (UIColor *) color ;

@property (nonatomic , readonly) NSInteger toInteger ;
@property (nonatomic , readonly) long long toLonglong ;
@property (nonatomic , readonly) int toInt;
@property (nonatomic , readonly) BOOL toBool ;
@property (nonatomic , readonly) float toFloat ;
@property (nonatomic , readonly) double toDouble ;

/// only numbers .
@property (nonatomic , readonly) NSDecimalNumber * toDecimal;
@property (nonatomic , readonly) NSMutableAttributedString * toAttribute;
/// yyyy-MM-dd HH:mm:ss
@property (nonatomic , readonly) NSDate * toDate;

- (instancetype) ccTimeStick : (BOOL) isNeedSpace ;
/// mil-senconds -> yyyy-MM-dd HH:mm
@property (nonatomic , readonly) NSString *toTimeStick ;
@property (nonatomic , readonly) NSString *toMD5 ;

@end
