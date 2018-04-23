//
//  NSObject+CCExtension.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/20.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "NSObject+CCExtension.h"

@implementation NSObject (CCExtension)

+ (NSString *)s_self {
    return NSStringFromClass(self);
}
+ (Class)Self {
    return self;
}

- (NSString *)toString {
    return [NSString stringWithFormat:@"%@",self];
}

- (NSString *)getClass {
    return NSStringFromClass(self.class);
}

@end

BOOL CC_IS_STRING_VALUED(__kindof NSString * string) {
    if (string) {
        if ([string isKindOfClass:[NSString class]]) {
            if (string.length
                && ![string isEqualToString:@"(null)"]
                && ![string isEqualToString:@"<null>"]
                && ![string isKindOfClass:NSNull.class]) {
                return YES;
            }
        }
    }
    return false;
}
BOOL CC_IS_ARRAY_VALUED(__kindof NSArray * array) {
    if (array) {
        if ([array isKindOfClass:[NSArray class]]) {
            if (array.count) {
                return YES;
            }
        }
    }
    return false;
}
BOOL CC_IS_DICTIONARY_VALUED(__kindof NSDictionary * dictionary) {
    if (dictionary) {
        if ([dictionary isKindOfClass:[NSDictionary class]]) {
            if (dictionary && dictionary.allKeys.count && dictionary.allValues.count
                && (dictionary.allKeys.count == dictionary.allValues.count)) {
                return YES;
            }
        }
    }
    return false;
}
BOOL CC_IS_DECIMAL_VALUED(__kindof NSDecimalNumber * decimal) {
    if (decimal) {
        if ([decimal isKindOfClass:[NSDecimalNumber class]]) {
            if (![decimal isEqual:NSDecimalNumber.notANumber]) {
                return YES;
            }
        }
    }
    return false;
}
BOOL CC_IS_NULL(id object) {
    return (object && ![object isKindOfClass:[NSNull class]] && (object != NSNull.null));
}
