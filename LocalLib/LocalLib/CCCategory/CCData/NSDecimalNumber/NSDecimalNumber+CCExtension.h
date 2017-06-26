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

@property (nonatomic , readonly) NSString * roundingToString ;
@property (nonatomic , readonly) NSDecimalNumber * rounding ;

- (NSString *) ccRoundingToString ; // 保留小数后几位

- (NSString *) ccRoundingToStringAfter : (NSInteger)position ; // 保留小数后几位

- (NSString *) ccRoundingToStringAfter : (NSInteger) position
                             roundMode : (NSRoundingMode) mode ; // 是否向上取整 , 只入不舍

- (instancetype) ccRounding ; // 保留小数后几位

- (instancetype) ccRoundingAfter : (NSInteger)position ; // 保留小数后几位

- (instancetype) ccRoundingAfter : (NSInteger) position
                       roundMode : (NSRoundingMode) mode  ;

- (instancetype) ccMuti : (NSDecimalNumber *) decimalNumber ; // 乘

- (instancetype) ccDivide : (NSDecimalNumber *) decimalNumber ; // 除

@end
