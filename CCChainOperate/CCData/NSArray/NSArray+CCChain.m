//
//  NSArray+CCChain.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 01/07/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "NSArray+CCChain.h"
#import "NSObject+CCChain.h"

#import <objc/runtime.h>

@implementation NSArray (CCChain)

- (id (^)(NSInteger))value {
    __weak typeof(self) pSelf = self;
    return ^id (NSInteger index) {
        if (index >= 0 && index < pSelf.count) {
            return pSelf.isArrayValued[index];
        }
        return nil;
    };
}

@end

#pragma mark - -----------------------------------------------------------------

@implementation NSMutableArray (CCChain)

- (NSMutableArray *(^)(NSString *))type {
    __weak typeof(self) pSelf = self;
    return ^NSMutableArray *(NSString * clazz) {
        objc_setAssociatedObject(pSelf, "_CC_ARRAY_CLAZZ_", clazz, OBJC_ASSOCIATION_ASSIGN);
        return pSelf;
    };
}

- (NSMutableArray *(^)(id))append {
    __weak typeof(self) pSelf = self;
    return ^NSMutableArray *(id value) {
        BOOL isCan = YES;
        if (objc_getAssociatedObject(pSelf, "_CC_ARRAY_CLAZZ_")) {
            Class clazz = NSClassFromString([NSString stringWithFormat:@"%@",objc_getAssociatedObject(pSelf, "_CC_ARRAY_CLAZZ_")]);
            isCan = [value isKindOfClass:clazz];
        }
        CCArrayChangeInfo type ;
        type.type = CCArrayChangeTypeAppend;
        type.count = pSelf.count;
        if (isCan) {
            [pSelf addObject:value];
            type.count = pSelf.count;
            void (^t)(id , CCArrayChangeInfo) = objc_getAssociatedObject(pSelf, "_CC_ARRAY_CHANGE_");
            if (t) {
                t(value , type);
            }
        } else {
            type.type = CCArrayChangeTypeNone;
        }
        
        void (^r)(CCArrayChangeInfo t) = objc_getAssociatedObject(pSelf, "_CC_ARRAY_COMPLETE_");
        if (r) {
            r(type);
        }
        return pSelf;
    };
}

- (NSMutableArray *(^)(id, BOOL))appendE {
    __weak typeof(self) pSelf = self;
    return ^NSMutableArray *(id value , BOOL isExpand) {
        if ([value isKindOfClass:NSArray.class]) {
            if (isExpand) {
                [(NSArray *)value enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    pSelf.append(obj);
                }];
            }
            else pSelf.append(value);
        }
        else pSelf.append(value);
        return pSelf;
    };
}

- (NSMutableArray *(^)(id))remove {
    __weak typeof(self) pSelf = self;
    return ^NSMutableArray *(id value) {
        CCArrayChangeInfo type ;
        type.type = CCArrayChangeTypeRemoved;
        type.count = pSelf.count;
        if ([pSelf containsObject:value]) {
            [pSelf removeObject:value];
            void (^t)(id , CCArrayChangeInfo) = objc_getAssociatedObject(pSelf, "_CC_ARRAY_CHANGE_");
            if (t) {
                t(value , type);
            }
        } else {
            type.type = CCArrayChangeTypeNone;
        }
        void (^r)(CCArrayChangeInfo t) = objc_getAssociatedObject(pSelf, "_CC_ARRAY_COMPLETE_");
        if (r) {
            r(type);
        }
        return pSelf;
    };
}

- (NSMutableArray *(^)(BOOL (^)(BOOL, id)))removeAll {
    __weak typeof(self) pSelf = self;
    return ^NSMutableArray *(BOOL (^t)(BOOL isCompare, id obj)) {
        NSString *stringClazz = [NSString stringWithFormat:@"%@",objc_getAssociatedObject(pSelf, "_CC_ARRAY_CLAZZ_")];
        
        NSMutableArray *arrayRemove = [NSMutableArray array];
        __block CCArrayChangeInfo type ;
        type.type = CCArrayChangeTypeRemoved;
        
        [pSelf enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            BOOL isCan = YES;
            if (t) {
                isCan = t([obj isKindOfClass:NSClassFromString(stringClazz)] , obj);
            }
            if (isCan) {
                [arrayRemove addObject:obj];
                type.count = pSelf.count;
                void (^t)(id , CCArrayChangeInfo) = objc_getAssociatedObject(pSelf, "_CC_ARRAY_CHANGE_");
                if (t) {
                    t(obj , type);
                }
            }
        }];
        [pSelf removeObjectsInArray:arrayRemove];
        void (^r)(CCArrayChangeInfo t) = objc_getAssociatedObject(pSelf, "_CC_ARRAY_COMPLETE_");
        if (r) {
            r(type);
        }
        
        return pSelf;
    };
}

- (NSMutableArray *(^)(void (^)(id, CCArrayChangeInfo)))change{
    __weak typeof(self) pSelf = self;
    return ^NSMutableArray *(void (^t)(id value , CCArrayChangeInfo info)) {
        objc_setAssociatedObject(pSelf, "_CC_ARRAY_CHANGE_", t, OBJC_ASSOCIATION_COPY_NONATOMIC);
        return pSelf;
    };
}

- (NSMutableArray *(^)(void (^)(CCArrayChangeInfo)))complete {
    __weak typeof(self) pSelf = self;
    return ^NSMutableArray *(void (^r)(CCArrayChangeInfo t)) {
        objc_setAssociatedObject(pSelf, "_CC_ARRAY_COMPLETE_", r, OBJC_ASSOCIATION_COPY_NONATOMIC);
        return pSelf;
    };
}

@end
