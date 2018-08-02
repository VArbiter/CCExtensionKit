//
//  NSObject+MQProtocol.m
//  MQExtensionKit
//
//  Created by Elwinfrederick on 16/08/2017.
//  Copyright © 2017 ElwinFrederick. All rights reserved.
//

#import "NSObject+MQProtocol.h"

@implementation NSObject (MQProtocol)

- (instancetype)mq {
    return self;
}

- (instancetype)mq:(id (^)(id))sameObject {
    if (self && sameObject) return sameObject(self);
    return self;
}

+ (instancetype)MQ_NON_NULL:(void (^)(id))setting {
    id value = [[self alloc] init];
    if (setting && value) setting(value);
    return value;
}

id MQ_NON_NULL(Class clazz , void (^setting)(id value)) {
    id value = [[clazz alloc] init];
    if (setting) setting(value);
    return value;
}

+ (void) mq_end {}
- (void) mq_end {}

@end
