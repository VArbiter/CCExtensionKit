//
//  NSDictionary+CCChain.m
//  CCLocalLibrary
//
//  Created by Elwinfrederick on 02/08/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "NSDictionary+CCChain.h"

#import <objc/runtime.h>

@implementation NSDictionary (CCChain)

@end

#pragma mark - -----

static const char * _CC_NSMUTABLEDICTIONARY_OBSERVER_KEY_S_ = "CC_NSMUTABLEDICTIONARY_OBSERVER_KEY_S";
static const char * _CC_NSMUTABLEDICTIONARY_OBSERVER_KEY_T_ = "CC_NSMUTABLEDICTIONARY_OBSERVER_KEY_T";

@implementation NSMutableDictionary (CCChain)

- (NSMutableDictionary *(^)(id, id))set {
    __weak typeof(self) pSelf = self;
    return ^NSMutableDictionary *(id k , id v) {
        [pSelf setValue:v forKey:k];
        return pSelf;
    };
}

- (NSMutableDictionary *(^)(id, id))setO {
    __weak typeof(self) pSelf = self;
    return ^NSMutableDictionary *(id k , id v) {
        pSelf.set(k, v);
        void (^s)(id , id) = objc_getAssociatedObject(pSelf, _CC_NSMUTABLEDICTIONARY_OBSERVER_KEY_S_);
        if (s) s(k , v);
        void (^t)(id , id , NSArray * , NSArray *) = objc_getAssociatedObject(pSelf, _CC_NSMUTABLEDICTIONARY_OBSERVER_KEY_T_);
        if (t) t(k , v , pSelf.allKeys , pSelf.allValues);
        return pSelf;
    };
}

- (NSMutableDictionary *(^)(void (^)(id, id)))observerS {
    __weak typeof(self) pSelf = self;
    return ^NSMutableDictionary *(void(^t)(id key , id value)) {
        if (t) objc_setAssociatedObject(pSelf, _CC_NSMUTABLEDICTIONARY_OBSERVER_KEY_S_, t, OBJC_ASSOCIATION_COPY_NONATOMIC);
        return pSelf;
    };
}

- (NSMutableDictionary *(^)(void (^)(id, id, NSArray *, NSArray *)))observerT {
    __weak typeof(self) pSelf = self;
    return ^NSMutableDictionary *(void (^t)(id k, id v, NSArray *ak, NSArray *av)) {
        if (t) objc_setAssociatedObject(pSelf, _CC_NSMUTABLEDICTIONARY_OBSERVER_KEY_T_, t, OBJC_ASSOCIATION_COPY_NONATOMIC);
        return pSelf;
    };
}

@end
