//
//  NSObject+CCProtocol.m
//  RisSubModule
//
//  Created by Elwinfrederick on 16/08/2017.
//  Copyright © 2017 ElwinFrederick. All rights reserved.
//

#import "NSObject+CCProtocol.h"

@implementation NSObject (CCProtocol)

- (instancetype)cc {
    return self;
}

- (instancetype)cc:(id (^)(id))sameObject {
    if (self && sameObject) return sameObject(self);
    return self;
}

+ (instancetype)CC_NON_NULL:(void (^)(id))setting {
    id value = [[self alloc] init];
    if (setting && value) setting(value);
    return value;
}

id CC_NON_NULL(Class clazz , void (^setting)(id value)) {
    id value = [[clazz alloc] init];
    if (setting) setting(value);
    return value;
}

+ (void) cc_end {}
- (void) cc_end {}

@end
