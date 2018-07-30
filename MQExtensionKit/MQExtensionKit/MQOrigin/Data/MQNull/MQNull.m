//
//  CCNull.m
//  MQExtensionKit
//
//  Created by ElwinFrederick on 2018/7/5.
//  Copyright © 2018 冯明庆. All rights reserved.
//

#import "CCNull.h"
#import <objc/runtime.h>

static NSMutableArray * __unknow_message_post_as_objects = nil;

@interface CCForwardingUnknowMessage : NSObject

+ (void) mq_regist_class : (Class) clz ;

+ (NSArray *) mq_class_objects ;

@end

@implementation CCForwardingUnknowMessage

+ (void)initialize {
    if (self == [CCForwardingUnknowMessage class]) {
        NSMutableArray *t = [NSMutableArray array];
        [t addObject:NSString.class];
        [t addObject:NSNumber.class];
        [t addObject:NSArray.class];
        [t addObject:NSDictionary.class];
        [t addObject:NSSet.class];
        
        __unknow_message_post_as_objects = t;
    }
}

+ (void) mq_regist_class : (Class) clz {
    if (clz) {
        if (![__unknow_message_post_as_objects containsObject:clz]) {
            [__unknow_message_post_as_objects addObject:clz];
        }
    }
    else {
        [NSException raise:@"CCExtensionKit.CCForwardingUnknowMessage : InvalidArgumentException"
                    format:@"class can't be nil"];
    }
}

+ (NSArray *) mq_class_objects {
    return __unknow_message_post_as_objects;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wnonnull"
    
    [anInvocation invokeWithTarget:nil];
    
#pragma clang diagnostic pop
}

+ (id)objectRespondToSelector:(SEL)aSelector {
    NSArray *mq_default_classes = [self mq_class_objects];
    for (Class t_default_class in mq_default_classes) {
        if ([t_default_class instancesRespondToSelector:aSelector]) {
            return t_default_class;
        }
    }
    
    return nil;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    return [[self class] instanceMethodSignatureForSelector:aSelector];
}

+ (NSMethodSignature *)instanceMethodSignatureForSelector:(SEL)aSelector {
    return [[self objectRespondToSelector:aSelector] instanceMethodSignatureForSelector:aSelector];
}

@end

#pragma mark - -----

@interface CCNullValue : CCForwardingUnknowMessage < NSCopying , NSMutableCopying , NSCoding >

+ (id) mq_null_value ;

- (BOOL) mq_is_NSNull : (Class)aClass ;

@end

@implementation CCNullValue

static CCNullValue *__singleton_null_value = nil;

+ (id) mq_null_value {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __singleton_null_value = [[CCNullValue alloc] init];
    });
    
    return __singleton_null_value;
}

+ (Class)class {return [NSNull class];}

#pragma mark NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder {}

- (id)initWithCoder:(NSCoder *)aDecoder {
    return [[self class] mq_null_value];
}

#pragma mark NSCopying

- (id)copyWithZone:(NSZone *)zone {
    return __singleton_null_value;
}

- (BOOL)mq_is_NSNull : (Class)aClass {
    return aClass == [NSNull class];
}

- (BOOL)isKindOfClass:(Class)aClass {
    return [self mq_is_NSNull:aClass] || [super isKindOfClass:aClass];
}

- (BOOL)isMemberOfClass:(Class)aClass {
    return [self mq_is_NSNull:aClass];
}

- (id)mutableCopyWithZone:(nullable NSZone *)zone {
    return __singleton_null_value;
}

@end

#pragma mark - -----

@interface CCNull ()

@end

@implementation CCNull

__attribute__((constructor)) void createFakeNSNull() {
    Class child_clz = [NSNull class];
    Class parent_clz = [CCForwardingUnknowMessage class];
    NSInteger child_clz_size = class_getInstanceSize(child_clz);
    NSInteger parent_clz_size = class_getInstanceSize(parent_clz);
    if (child_clz_size - parent_clz_size >= 0) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        class_setSuperclass(child_clz, parent_clz);
#pragma clang diagnostic pop
    } else {
        Method method_null = class_getClassMethod([NSNull class], @selector(null));
        Method method_value_null = class_getClassMethod([CCNullValue class], @selector(mq_null_value));
        if (method_null != nil && method_value_null != nil) {
            method_setImplementation(method_null, method_getImplementation(method_value_null));
        }
    }
}

+ (void)mq_regist_class : (Class) clz {
    [CCForwardingUnknowMessage mq_regist_class:clz];
}

@end
