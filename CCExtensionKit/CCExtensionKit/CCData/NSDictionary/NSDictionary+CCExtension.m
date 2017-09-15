//
//  NSDictionary+CCExtension.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/20.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "NSDictionary+CCExtension.h"

@implementation NSDictionary (CCExtension)

+ (instancetype) ccJson : (NSString *) sJson {
    if (!sJson || !sJson.length) return @{};
    
    NSData *dataJson = [sJson dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *dicionary = [NSJSONSerialization JSONObjectWithData:dataJson
                                                              options:NSJSONReadingMutableContainers | NSJSONReadingAllowFragments
                                                                error:&error];
    return error ? @{} : dicionary;
}

@end

#pragma mark - -----
#import <objc/runtime.h>

static const char * _CC_NSMUTABLEDICTIONARY_OBSERVER_KEY_S_ = "CC_NSMUTABLEDICTIONARY_OBSERVER_KEY_S";
static const char * _CC_NSMUTABLEDICTIONARY_OBSERVER_KEY_T_ = "CC_NSMUTABLEDICTIONARY_OBSERVER_KEY_T";

@implementation NSMutableDictionary (CCExtension)

- (instancetype) ccSet : (id) key
                 value : (id) value {
    [self setValue:value forKey:key];
    return self;
}

- (instancetype) ccSetWithObserver : (id) key
                             value : (id) value {
    [self ccSet:key value:value];
    void (^s)(id , id) = objc_getAssociatedObject(self, _CC_NSMUTABLEDICTIONARY_OBSERVER_KEY_S_);
    if (s) s(key , value);
    void (^t)(id , id , NSArray * , NSArray *) = objc_getAssociatedObject(self, _CC_NSMUTABLEDICTIONARY_OBSERVER_KEY_T_);
    if (t) t(key , value , self.allKeys , self.allValues);
    return self;
}

- (instancetype) ccObserver : (void (^)(id key , id value)) action {
    if (action) objc_setAssociatedObject(self, _CC_NSMUTABLEDICTIONARY_OBSERVER_KEY_S_, action, OBJC_ASSOCIATION_COPY_NONATOMIC);
    return self;
}

- (instancetype) ccObserverT : (void (^)(void(^t)(id key , id value , NSArray * aAllKeys , NSArray * aAllValues))) action {
    if (action) objc_setAssociatedObject(self, _CC_NSMUTABLEDICTIONARY_OBSERVER_KEY_T_, action, OBJC_ASSOCIATION_COPY_NONATOMIC);
    return self;
}

@end
