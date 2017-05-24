//
//  NSNumber+YMExtension.m
//  ym_sell_ios
//
//  Created by 冯明庆 on 2017/4/20.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "NSNumber+YMExtension.h"

@implementation NSNumber (YMExtension)

- (NSDecimalNumber *) ymDecimalValue {
    return [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",self]];
}

@end
