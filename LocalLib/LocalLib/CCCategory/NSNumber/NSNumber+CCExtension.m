//
//  NSNumber+CCExtension.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/20.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "NSNumber+CCExtension.h"

@implementation NSNumber (CCExtension)

- (NSDecimalNumber *) ccDecimalValue {
    return [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",self]];
}

@end
