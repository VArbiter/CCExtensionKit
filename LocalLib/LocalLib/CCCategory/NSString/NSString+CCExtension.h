//
//  NSString+CCExtension.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/11.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CCExtension)

- (NSDecimalNumber *) ccDecimalValue ; // 仅限数字

- (NSString *) ccTimeStick ; // yyyy-MM-dd HH:mm

- (NSString *) ccTimeStickWeekDays ; // yyyy-MM-dd HH:mm

- (NSString *) ccTimeSince1970 : (NSTimeInterval) interval ;

- (NSDate *) ccDate ;

- (NSUInteger) ccIntegerDays ;

+ (NSString *) ccMergeNeedLineBreak : (BOOL) isNeedBreak // 回车优先级最高 , 高于空格
                    withNeedSpacing : (BOOL) isNeedSpacing
                         withString : (NSString *) string , ... NS_REQUIRES_NIL_TERMINATION; 

+ (NSString *) ccMergeWithStringArray : (NSArray <NSString *> *) arrayStrings
                    withNeedLineBreak : (BOOL) isNeedBreak // 回车优先级最高 , 高于空格
                      withNeedSpacing : (BOOL) isNeedSpacing ;

- (NSString *) ccMD5String ;

+ (NSString *) ccUUID ;

- (NSMutableAttributedString *) ccMAttributeString ;

- (NSMutableAttributedString *) ccColor : (UIColor *) color ;

@end
