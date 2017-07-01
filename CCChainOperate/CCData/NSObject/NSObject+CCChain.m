//
//  NSObject+CCChain.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 01/07/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "NSObject+CCChain.h"

#import <objc/runtime.h>

@implementation NSObject (CCChain)

- (NSString *)toString {
    return [NSString stringWithFormat:@"%@",self];
}

- (NSString *)getClass {
    return NSStringFromClass(self.class);
}

- (NSString *)isStringValued {
    if (self) {
        if ([self isKindOfClass:[NSString class]]) {
            NSString *string = (NSString *) self;
            if (string.length && ![string isEqualToString:@"(null)"]) {
                return (NSString *)self;
            }
        }
    }
    return nil;
}

- (NSArray *)isArrayValued {
    if (self) {
        if ([self isKindOfClass:[NSArray class]]) {
            NSArray *array = (NSArray *) self;
            if (array.count) {
                return (NSArray *)self;
            }
        }
    }
    return nil;
}

- (NSDictionary *)isDictionaryValued {
    if ([self isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dictionary = (NSDictionary *) self;
        if (dictionary && dictionary.allKeys.count && dictionary.allValues.count
            && (dictionary.allKeys.count == dictionary.allValues.count)) {
            return (NSDictionary *) self;
        }
    }
    return nil;
}

- (NSDecimalNumber *)isDecimalValued {
    if (self) {
        if ([self isKindOfClass:[NSDecimalNumber class]]) {
            if (![self isEqual:NSDecimalNumber.notANumber]) {
                return (NSDecimalNumber *) self;
            }
        }
    }
    return nil;
}

- (BOOL)isNull {
    return (self && ![self isKindOfClass:[NSNull class]] && (self != NSNull.null));
}

@end

@implementation NSObject (CCChainBridge)

- (void)setBridge:(id (^)())bridge {
    objc_setAssociatedObject(self, @selector(bridge), bridge, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (id (^)())bridge {
    return objc_getAssociatedObject(self, _cmd);
}

@end
