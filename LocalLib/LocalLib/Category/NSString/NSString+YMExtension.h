//
//  NSString+YMExtension.h
//  ym_sell_ios
//
//  Created by 冯明庆 on 2017/4/11.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (YMExtension)

- (NSDecimalNumber *) ymDecimalValue ; // 仅限数字

- (NSString *) ymTimeStick ; // yyyy-MM-dd HH:mm

- (NSString *) ymTimeStickWeekDays ; // yyyy-MM-dd HH:mm

- (NSString *) ymTimeSince1970 : (NSTimeInterval) interval ;

- (NSDate *) ymDate ;

- (NSUInteger) ymIntegerDays ;

+ (NSString *) ymMergeNeedLineBreak : (BOOL) isNeedBreak // 回车优先级最高 , 高于空格
                    withNeedSpacing : (BOOL) isNeedSpacing
                         withString : (NSString *) string , ... NS_REQUIRES_NIL_TERMINATION; 

+ (NSString *) ymMergeWithStringArray : (NSArray <NSString *> *) arrayStrings
                    withNeedLineBreak : (BOOL) isNeedBreak // 回车优先级最高 , 高于空格
                      withNeedSpacing : (BOOL) isNeedSpacing ;

- (NSString *) ymMD5String ;

+ (NSString *) ymUUID ;

- (BOOL) ymIsStringValued ;

- (NSMutableAttributedString *) ymMAttributeString ;

- (NSMutableAttributedString *) ymColor : (UIColor *) color ;

@end
