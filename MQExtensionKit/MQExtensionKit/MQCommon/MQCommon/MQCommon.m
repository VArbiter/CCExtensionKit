//
//  MQCommon.m
//  MQExtensionKit
//
//  Created by Elwinfrederick on 06/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "MQCommon.h"

//@implementation MQCommon
//@end

CGFloat mq_ceil(CGFloat f_value) {
    if (CGFLOAT_IS_DOUBLE) {
        return ceil(f_value);
    }
    return ceilf(f_value);
}
CGFloat mq_floor(CGFloat f_value) {
    if (CGFLOAT_IS_DOUBLE) {
        return floor(f_value);
    }
    return floorf(f_value);
}

BOOL mq_available(double version) {
    return UIDevice.currentDevice.systemVersion.floatValue >= version;
}

void mq_available_b(double version , void(^s)(void) , void(^f)(void)) {
    if (mq_available(version)) {
        if (s) s();
    }
    else if (f) f();
}

void mq_debug(void (^debug)(void) , void (^release)(void)) {
#if DEBUG
    if (debug) debug();
#else
    if (release) release();
#endif
}

/// -1 DEBUG , 0 auto , 1 release
void mq_debug_b(int mark , void (^debug)(void) , void (^release)(void)) {
    if (mark == 0) {
        mq_debug(debug, release);
    } else if (mark > 0) {
        if (release) release();
    } else if (debug) debug();
}

BOOL mq_is_simulator(void) {
#if TARGET_IPHONE_SIMULATOR
    return YES;
#else
    return false;
#endif
}
void mq_detect_simulator(void (^y)(void) , void (^n)(void)) {
    if (mq_is_simulator()) {
        if (y) y();
    } else if (n) n();
}

void mq_safe_chain(id object , void (^safe)(id object)) {
    if (object && safe) safe(object);
}

NSString * mq_size_for_length(NSUInteger i_length , BOOL standard) {
    NSUInteger i = standard ? MQ_STANDARD_LENGTH : MQ_STANDARD_LENGTH_IN_IOS;
    if (i_length > pow(i, 2))
        return [NSString stringWithFormat:@"%.2fMB",i_length / pow(i, 2)];
    else if (i_length > i) {
#if __LP64__ || 0 || NS_BUILD_32_LIKE_64
        return [NSString stringWithFormat:@"%.0luKB",i_length / i];
#else
        return [NSString stringWithFormat:@"%.0uKB",i_length / i];
#endif
    }
    else return [NSString stringWithFormat:@"%@B",@(i_length)];
}

id mq_default_object(id object , id insure_object) {
    return object ? object : insure_object;
}

BOOL mq_is_object_address_same(id obj_1 , id obj_2){
    return (obj_1 == obj_2);
}
BOOL mq_is_object_hash_same(id obj_1 , id obj_2) {
    if ([obj_1 respondsToSelector:@selector(isEqual:)]
        && [obj_2 respondsToSelector:@selector(isEqual:)]) {
        return [obj_1 isEqual:obj_2];
    }
    return mq_is_object_address_same(obj_1, obj_2);
}

BOOL mq_is_object_subclass_of(id obj , Class clz) {
    if ([obj respondsToSelector:@selector(isSubclassOfClass:)]) {
        return [obj isSubclassOfClass:clz];
    }
    else if ([obj respondsToSelector:@selector(class)]) {
        return [[obj class] isSubclassOfClass:clz];
    }
    return false;
}

BOOL mq_is_object_kind_of_class(id obj , Class clz) {
    if ([obj respondsToSelector:@selector(initialize)]) {
        return [obj isEqual:clz];
    }
    else if ([obj respondsToSelector:@selector(isKindOfClass:)]) {
        return [obj isKindOfClass:clz];
    }
    return false;
}
