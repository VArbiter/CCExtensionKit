//
//  NSNumber+CCExtension.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/20.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (CCExtension)

@property (nonatomic , readonly) NSDecimalNumber * toDecimal ;

@end

#pragma mark - ------

@interface NSDecimalNumber (CCExtension)

/// default two after point . // 默认小数点后两位
@property (nonatomic , readonly) NSString * round ;
- (NSString *) cc_round : (short) point ;
- (NSString *) cc_round : (short) point
                   mode : (NSRoundingMode) mode ;

- (instancetype) cc_round_decimal ;
- (instancetype) cc_round_decimal : (short) point ;
- (instancetype) cc_round_decimal : (short) point
                             mode : (NSRoundingMode) mode ;

- (instancetype) cc_mutiply : (NSDecimalNumber *) decimal ;
- (instancetype) cc_devide : (NSDecimalNumber *) decimal ;

@end
