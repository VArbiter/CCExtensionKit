//
//  NSNumber+CCExtension.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/20.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (CCExtension)

@property (nonatomic , readonly) NSDecimalNumber * decimal ;

@end

#pragma mark - ------

@interface NSDecimalNumber (CCExtension)

/// default two after point . // 默认小数点后两位
@property (nonatomic , readonly) NSString * round ;
- (NSString *) ccRound : (short) point ;
- (NSString *) ccRound : (short) point
                  mode : (NSRoundingMode) mode ;

- (instancetype) roundDecimal ;
- (instancetype) ccRoundDecimal : (short) point ;
- (instancetype) ccRoundDecimal : (short) point
                           mode : (NSRoundingMode) mode ;

- (instancetype) ccMutiply : (NSDecimalNumber *) decimal ;
- (instancetype) ccDevide : (NSDecimalNumber *) decimal ;

@end
