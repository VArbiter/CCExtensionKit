//
//  NSMutableDictionary+CCExtension.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/17.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "NSMutableDictionary+CCExtension.h"

#import <objc/runtime.h>

@implementation NSMutableDictionary (CCExtension)

- (void) ccSetValue:(id)value forKey:(NSString *)key {
    [self setValue:value forKey:key];
    
    if (self.blockChange) {
        self.blockChange(key, value);
    }
    if (self.blockChangeAll) {
        self.blockChangeAll(key, value, self.allKeys, self.allValues);
    }
}

- (void)setBlockChange:(void (^)(id, id))blockChange {
    objc_setAssociatedObject(self, @selector(blockChange), blockChange, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(id, id))blockChange {
    return objc_getAssociatedObject(self, _cmd);
}

-(void)setBlockChangeAll:(void (^)(id, id, NSArray *, NSArray *))blockChangeAll {
    objc_setAssociatedObject(self, @selector(blockChangeAll), blockChangeAll, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(id, id, NSArray *, NSArray *))blockChangeAll {
    return objc_getAssociatedObject(self, _cmd);
}


@end
