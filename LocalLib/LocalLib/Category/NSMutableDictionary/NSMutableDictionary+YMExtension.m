//
//  NSMutableDictionary+YMExtension.m
//  ym_sell_ios
//
//  Created by 冯明庆 on 2017/4/17.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "NSMutableDictionary+YMExtension.h"

#import <objc/runtime.h>

const char * _YM_NSDICTIONARY_OBSERVER_ALL_ ;
const char * _YM_NSDICTIONARY_OBSERVER_ ;

@implementation NSMutableDictionary (YMExtension)

- (void) ymSetValue:(id)value forKey:(NSString *)key {
    [self setValue:value forKey:key];
    
    if (self.blockChange) {
        self.blockChange(key, value);
    }
    if (self.blockChangeAll) {
        self.blockChangeAll(key, value, self.allKeys, self.allValues);
    }
}

- (void)setBlockChange:(void (^)(id, id))blockChange {
    objc_setAssociatedObject(self, &_YM_NSDICTIONARY_OBSERVER_, blockChange, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(id, id))blockChange {
    return objc_getAssociatedObject(self, &_YM_NSDICTIONARY_OBSERVER_);
}

-(void)setBlockChangeAll:(void (^)(id, id, NSArray *, NSArray *))blockChangeAll {
    objc_setAssociatedObject(self, &_YM_NSDICTIONARY_OBSERVER_ALL_, blockChangeAll, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(id, id, NSArray *, NSArray *))blockChangeAll {
    return objc_getAssociatedObject(self, &_YM_NSDICTIONARY_OBSERVER_ALL_);
}


@end
