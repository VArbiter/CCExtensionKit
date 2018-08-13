//
//  MQCommon.m
//  MQExtensionKit
//
//  Created by Elwinfrederick on 06/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "MQCommon.h"
//#import <pthread.h>

@implementation MQCommon

NSString * _MQ_UUID_() {
    return UIDevice.currentDevice.identifierForVendor.UUIDString;
}

BOOL MQ_Available_C(double version) {
    return UIDevice.currentDevice.systemVersion.floatValue >= version;
}

void MQ_Available_S(double version , void(^s)(void) , void(^f)(void)) {
    if (MQ_Available_C(version)) {
        if (s) s();
    }
    else if (f) f();
}

BOOL MQ_IS_MAIN_QUEUE(void) {
//    return pthread_main_np() != 0;
    return NSThread.isMainThread;
}

void MQ_Main_Thread_Sync(void (^t)(void)) {
    if (MQ_IS_MAIN_QUEUE()) {
        if (t) t();
    } else dispatch_sync(dispatch_get_main_queue(), t);
}

void MQ_Main_Thread_Async(void (^t)(void)) {
    if (MQ_IS_MAIN_QUEUE()) {
        if (t) t();
    } else dispatch_async(dispatch_get_main_queue(), t);
}

void MQ_DEBUG(void (^debug)(void) , void (^release)(void)) {
    if (_MQ_DEBUG_MODE_) {
        if (debug) debug();
    } else if (release) release();
}

/// -1 DEBUG , 0 auto , 1 release
void MQ_DEBUG_M(int mark , void (^debug)(void) , void (^release)(void)) {
    if (mark == 0) {
        if (_MQ_DEBUG_MODE_) {
            if (debug) debug();
        } else if (release) release();
    } else if (mark > 0) {
        if (release) release();
    } else if (debug) debug();
}

void MQ_DETECT_SIMULATOR(void (^y)(void) , void (^n)(void)) {
    if (_MQ_IS_SIMULATOR_) {
        if (y) y();
    } else if (n) n();
}

void MQ_SAFED_CHAIN(id object , void (^safe)(id object)) {
    if (object && safe) safe(object);
}

NSString * MQ_SIZE_FOR_LENGTH(NSUInteger i_length) {
    if (i_length > pow(MQ_STANDARD_LENGTH, 2))
        return [NSString stringWithFormat:@"%.2fMB",i_length / pow(MQ_STANDARD_LENGTH, 2)];
    else if (i_length > MQ_STANDARD_LENGTH)
        return [NSString stringWithFormat:@"%.0fKB",i_length / MQ_STANDARD_LENGTH];
    else return [NSString stringWithFormat:@"%@B",@(i_length)];
}

id MQ_Default_Object(id object , id insure_object) {
    return object ? object : insure_object;
}

@end
