//
//  CCCommon.m
//  MQExtensionKit
//
//  Created by Elwinfrederick on 06/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "CCCommon.h"
#import <pthread.h>

@implementation CCCommon

NSString * _CC_UUID_() {
    return UIDevice.currentDevice.identifierForVendor.UUIDString;
}

BOOL CC_Available_C(double version) {
    return UIDevice.currentDevice.systemVersion.floatValue >= version;
}

void CC_Available_S(double version , void(^s)(void) , void(^f)(void)) {
    if (CC_Available_C(version)) {
        if (s) s();
    }
    else if (f) f();
}

BOOL CC_IS_MAIN_QUEUE(void) {
    return pthread_main_np() != 0;
}

void CC_Main_Thread_Sync(void (^t)(void)) {
    if (CC_IS_MAIN_QUEUE()) {
        if (t) t();
    } else dispatch_sync(dispatch_get_main_queue(), t);
}

void CC_Main_Thread_Async(void (^t)(void)) {
    if (CC_IS_MAIN_QUEUE()) {
        if (t) t();
    } else dispatch_async(dispatch_get_main_queue(), t);
}

void CC_DEBUG(void (^debug)(void) , void (^release)(void)) {
    if (_CC_DEBUG_MODE_) {
        if (debug) debug();
    } else if (release) release();
}

/// -1 DEBUG , 0 auto , 1 release
void CC_DEBUG_M(int mark , void (^debug)(void) , void (^release)(void)) {
    if (mark == 0) {
        if (_CC_DEBUG_MODE_) {
            if (debug) debug();
        } else if (release) release();
    } else if (mark > 0) {
        if (release) release();
    } else if (debug) debug();
}

void CC_DETECT_SIMULATOR(void (^y)(void) , void (^n)(void)) {
    if (_CC_IS_SIMULATOR_) {
        if (y) y();
    } else if (n) n();
}

void CC_SAFED_CHAIN(id object , void (^safe)(id object)) {
    if (object && safe) safe(object);
}

NSString * CC_SIZE_FOR_LENGTH(NSUInteger i_length) {
    if (i_length > pow(CC_STANDARD_LENGTH, 2))
        return [NSString stringWithFormat:@"%.2fMB",i_length / pow(CC_STANDARD_LENGTH, 2)];
    else if (i_length > CC_STANDARD_LENGTH)
        return [NSString stringWithFormat:@"%.0fKB",i_length / CC_STANDARD_LENGTH];
    else return [NSString stringWithFormat:@"%@B",@(i_length)];
}

id CC_Default_Object(id object , id insure_object) {
    return object ? object : insure_object;
}

@end
