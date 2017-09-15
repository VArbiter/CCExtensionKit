//
//  NSArray+CCExtension.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/19.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "NSArray+CCExtension.h"

#import "NSObject+CCExtension.h"

@implementation NSArray (CCExtension)

- (id) ccValueAt : (NSInteger) index {
    if (index >= 0 && index < self.count) {
        return self.isArrayValued[index];
    }
    return nil;
}

@end

#pragma mark - -----
#import <objc/runtime.h>

@implementation NSMutableArray (CCExtension)

- (instancetype) ccType : (NSString *) cls {
    objc_setAssociatedObject(self, "_CC_ARRAY_CLAZZ_", cls, OBJC_ASSOCIATION_ASSIGN);
    return self;
}
- (instancetype) ccAppend : (id) value {
    BOOL isCan = YES;
    if (objc_getAssociatedObject(self, "_CC_ARRAY_CLAZZ_")) {
        Class clazz = NSClassFromString([NSString stringWithFormat:@"%@",objc_getAssociatedObject(self, "_CC_ARRAY_CLAZZ_")]);
        isCan = [value isKindOfClass:clazz];
    }
    CCArrayChangeInfo type ;
    type.type = CCArrayChangeTypeAppend;
    type.count = self.count;
    if (isCan) {
        [self addObject:value];
        type.count = self.count;
        void (^t)(id , CCArrayChangeInfo) = objc_getAssociatedObject(self, "_CC_ARRAY_CHANGE_");
        if (t) {
            t(value , type);
        }
    } else {
        type.type = CCArrayChangeTypeNone;
    }
    
    void (^r)(CCArrayChangeInfo t) = objc_getAssociatedObject(self, "_CC_ARRAY_COMPLETE_");
    if (r) {
        r(type);
    }
    return self;
}

- (instancetype) ccAppend : (id)value
                   expand : (BOOL) isExpand {
    if ([value isKindOfClass:NSArray.class]) {
        if (isExpand) {
            __weak typeof(self) pSelf = self;
            [(NSArray *)value enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [pSelf ccAppend:value];
            }];
        }
        else [self ccAppend:value];
    }
    else [self ccAppend:value];
    return self;
}
- (instancetype) ccRemove : (id) value {
    CCArrayChangeInfo type ;
    type.type = CCArrayChangeTypeRemoved;
    type.count = self.count;
    if ([self containsObject:value]) {
        [self removeObject:value];
        void (^t)(id , CCArrayChangeInfo) = objc_getAssociatedObject(self, "_CC_ARRAY_CHANGE_");
        if (t) {
            t(value , type);
        }
    } else {
        type.type = CCArrayChangeTypeNone;
    }
    void (^r)(CCArrayChangeInfo t) = objc_getAssociatedObject(self, "_CC_ARRAY_COMPLETE_");
    if (r) {
        r(type);
    }
    return self;
}
- (instancetype) ccRemoveAll : (BOOL (^)(BOOL isCompare , id obj)) action {
    NSString *stringClazz = [NSString stringWithFormat:@"%@",objc_getAssociatedObject(self, "_CC_ARRAY_CLAZZ_")];
    
    NSMutableArray *arrayRemove = [NSMutableArray array];
    __block CCArrayChangeInfo type ;
    type.type = CCArrayChangeTypeRemoved;
    
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BOOL isCan = YES;
        if (action) {
            isCan = action([obj isKindOfClass:NSClassFromString(stringClazz)] , obj);
        }
        if (isCan) {
            [arrayRemove addObject:obj];
            type.count = self.count;
            void (^t)(id , CCArrayChangeInfo) = objc_getAssociatedObject(self, "_CC_ARRAY_CHANGE_");
            if (t) {
                t(obj , type);
            }
        }
    }];
    [self removeObjectsInArray:arrayRemove];
    void (^r)(CCArrayChangeInfo t) = objc_getAssociatedObject(self, "_CC_ARRAY_COMPLETE_");
    if (r) {
        r(type);
    }
    
    return self;
}


- (instancetype) ccChange : (void (^)(id value , CCArrayChangeInfo type)) action {
    objc_setAssociatedObject(self, "_CC_ARRAY_CHANGE_", action, OBJC_ASSOCIATION_COPY_NONATOMIC);
    return self;
}
- (instancetype) ccComplete : (void (^)(CCArrayChangeInfo type)) action {
    objc_setAssociatedObject(self, "_CC_ARRAY_COMPLETE_", action, OBJC_ASSOCIATION_COPY_NONATOMIC);
    return self;
}

@end
