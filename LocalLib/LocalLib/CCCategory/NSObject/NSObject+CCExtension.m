//
//  NSObject+CCExtension.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/20.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "NSObject+CCExtension.h"

@implementation NSObject (CCExtension)

+ (NSString *)stringClass {
    return NSStringFromClass([self class]);
}

- (NSString *) ccStringValue {
    return [NSString stringWithFormat:@"%@",self];
}


- (BOOL) ccIsStringValued {
    if (self) {
        if ([self isKindOfClass:[NSString class]]) {
            NSString *string = (NSString *) self;
            if (string.length && ![string isEqualToString:@"(null)"]) {
                return YES;
            }
        }
    }
    return false;
}

- (BOOL) ccIsArrayValued {
    if (self) {
        if ([self isKindOfClass:[NSArray class]]) {
            NSArray *array = (NSArray *) self;
            if (array.count) {
                return YES;
            }
        }
    }
    return false;
}

- (BOOL) ccIsDecimalValued {
    if (self) {
        if ([self isKindOfClass:[NSDecimalNumber class]]) {
            if (![self isEqual:NSDecimalNumber.notANumber]) {
                return YES;
            }
        }
    }
    return false;
}

- (BOOL) ccIsDictionaryValued {
    if ([self isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dcitionary = (NSDictionary *) self;
        if (dcitionary && dcitionary.allKeys.count && dcitionary.allValues.count) {
            return YES;
        }
    }
    return false;
}

- (BOOL) ccIsNull {
    return (self && ![self isKindOfClass:[NSNull class]]);
}

@end
