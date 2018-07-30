//
//  NSNumber+MQExtension.h
//  MQExtensionKit
//
//  Created by 冯明庆 on 2017/4/20.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (MQExtension)

@property (nonatomic , readonly) NSDecimalNumber * to_decimal ;

@end

#pragma mark - ------

@interface NSDecimalNumber (MQExtension)

/// default two after point . // 默认小数点后两位
@property (nonatomic , readonly) NSString * round ;
- (NSString *) mq_round : (short) point ;
- (NSString *) mq_round : (short) point
                   mode : (NSRoundingMode) mode ;

- (instancetype) mq_round_decimal ;
- (instancetype) mq_round_decimal : (short) point ;
- (instancetype) mq_round_decimal : (short) point
                             mode : (NSRoundingMode) mode ;

- (instancetype) mq_mutiply : (NSDecimalNumber *) decimal ;
- (instancetype) mq_devide : (NSDecimalNumber *) decimal ;

@end
