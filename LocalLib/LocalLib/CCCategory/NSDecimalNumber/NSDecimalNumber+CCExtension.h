//
//  NSDecimalNumber+CCExtension.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/11.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

#define _CC_DECIMAL_POINT_POSITION_ 2 

@interface NSDecimalNumber (CCExtension)

- (NSString *) ccRounding ; // 保留小数后几位

- (NSString *) ccRoundingAfterPoint : (NSInteger)position ; // 保留小数后几位

- (NSString *) ccRoundingAfterPoint : (NSInteger) position
                      withRoundMode : (NSRoundingMode) mode ; // 是否向上取整 , 只入不舍

- (instancetype) ccRoundingDecimal ; // 保留小数后几位

- (instancetype) ccRoundingDecimalAfterPoint : (NSInteger)position ; // 保留小数后几位

- (instancetype) ccRoundingDecimalAfterPoint : (NSInteger) position
                               withRoundMode : (NSRoundingMode) mode  ;

- (NSString *) ccTransferToString ;

- (instancetype) ccMuti : (NSDecimalNumber *) decimalNumber ; // 乘

- (instancetype) ccDivide : (NSDecimalNumber *) decimalNumber ; // 除

@end
