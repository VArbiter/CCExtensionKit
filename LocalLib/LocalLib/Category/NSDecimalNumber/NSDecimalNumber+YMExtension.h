//
//  NSDecimalNumber+YMExtension.h
//  ym_sell_ios
//
//  Created by 冯明庆 on 2017/4/11.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

#define _YM_DECIMAL_POINT_POSITION_ 2 

@interface NSDecimalNumber (YMExtension)

- (NSString *) ymRounding ; // 保留小数后几位

- (NSString *) ymRoundingAfterPoint : (NSInteger)position ; // 保留小数后几位

- (NSString *) ymRoundingAfterPoint : (NSInteger) position
                      withRoundMode : (NSRoundingMode) mode ; // 是否向上取整 , 只入不舍

- (instancetype) ymRoundingDecimal ; // 保留小数后几位

- (instancetype) ymRoundingDecimalAfterPoint : (NSInteger)position ; // 保留小数后几位

- (instancetype) ymRoundingDecimalAfterPoint : (NSInteger) position
                               withRoundMode : (NSRoundingMode) mode  ;

- (NSString *) ymTransferToString ;

- (instancetype) ymMuti : (NSDecimalNumber *) decimalNumber ; // 乘

- (instancetype) ymDivide : (NSDecimalNumber *) decimalNumber ; // 除

- (BOOL) ymIsDecimalValued ;

@end
