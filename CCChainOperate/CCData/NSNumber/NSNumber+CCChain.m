//
//  NSNumber+CCChain.m
//  CCLocalLibrary
//
//  Created by Elwinfrederick on 02/08/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "NSNumber+CCChain.h"

@implementation NSNumber (CCChain)

- (NSDecimalNumber *(^)())decimal {
    __weak typeof(self) pSelf = self;
    return ^NSDecimalNumber * {
        return [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",pSelf]];
    };
}

@end
