//
//  NSTimer+CCExtension.m
//  CCLocalLibrary
//
//  Created by Elwinfrederick on 06/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "NSTimer+CCExtension.h"

#import <objc/runtime.h>

static const char * _CC_NSTIMER_ASSOCIATE_TIMER_KEY_ = "CC_NSTIMER_ASSOCIATE_TIMER_KEY";
static const char * _CC_NSTIMER_ASSOCIATE_SCHEDULED_KEY_ = "CC_NSTIMER_ASSOCIATE_SCHEDULED_KEY";

@interface NSTimer (CCExtension_Assit)

+ (void) ccTimerAction : (NSTimer *) sender ;

@end

@implementation NSTimer (CCExtension_Assit)

+ (void) ccTimerAction : (NSTimer *) sender {
    void (^t)(NSTimer *) = objc_getAssociatedObject(sender, _CC_NSTIMER_ASSOCIATE_TIMER_KEY_);
    if (t) t(sender);
    void (^s)(NSTimer *) = objc_getAssociatedObject(sender, _CC_NSTIMER_ASSOCIATE_SCHEDULED_KEY_);
    if (s) s(sender);
}

@end

@implementation NSTimer (CCExtension)

/// timer
+ (instancetype) cc_timer : (NSTimeInterval) interval
                   action : (void (^)(NSTimer *sender)) action {
    return [self cc_timer:interval
                   repeat:YES
                   action:action];
}

+ (instancetype) cc_timer : (NSTimeInterval) interval
                   repeat : (BOOL) isRepeat
                   action : (void (^)(NSTimer *sender)) action {
    return [self cc_timer:interval
                 userInfo:nil
                   repeat:isRepeat
                   action:action];
}

+ (instancetype) cc_timer : (NSTimeInterval) interval
                 userInfo : (id) userInfo
                   repeat : (BOOL) isRepeat
                   action : (void (^)(NSTimer *sender)) action {
    NSTimer *tTimer = [NSTimer timerWithTimeInterval:interval
                                              target:self
                                            selector:@selector(ccTimerAction:)
                                            userInfo:userInfo
                                             repeats:isRepeat];
    objc_setAssociatedObject(tTimer, _CC_NSTIMER_ASSOCIATE_TIMER_KEY_, action, OBJC_ASSOCIATION_COPY_NONATOMIC);
    return tTimer;
}

/// scheduled
+ (instancetype) cc_scheduled : (NSTimeInterval) interval
                       action : (void (^)(NSTimer *sender)) action {
    return [self cc_scheduled:interval
                       repeat:YES
                       action:action];
}

+ (instancetype) cc_scheduled : (NSTimeInterval) interval
                       repeat : (BOOL) isRepeat
                       action : (void (^)(NSTimer *sender)) action {
    return [self cc_scheduled:interval
                     userInfo:nil
                       repeat:isRepeat
                       action:action];
}

+ (instancetype) cc_scheduled : (NSTimeInterval) interval
                     userInfo : (id) userInfo
                       repeat : (BOOL) isRepeat
                       action : (void (^)(NSTimer *sender)) action {
    NSTimer *tTimer = [NSTimer scheduledTimerWithTimeInterval:interval
                                                       target:self
                                                     selector:@selector(ccTimerAction:)
                                                     userInfo:userInfo
                                                      repeats:isRepeat];
    objc_setAssociatedObject(tTimer, _CC_NSTIMER_ASSOCIATE_SCHEDULED_KEY_, action, OBJC_ASSOCIATION_COPY_NONATOMIC);
    return tTimer;
}

/// invalidate && set entity to nil.
void CC_TIMER_DESTORY(NSTimer *timer) {
    [timer invalidate];
    timer = nil;
}

- (instancetype) cc_fire {
    if (self.isValid) {
        [self fire];
    }
    return self;
}
- (instancetype) cc_pause {
    if (self.isValid) {
        self.fireDate = NSDate.distantFuture;
    }
    return self;
}
- (instancetype) cc_resume {
    if (self.isValid) {
        self.fireDate = NSDate.date;
    }
    return self;
}
- (instancetype) cc_stop {
    [self invalidate];
    return self;
}

@end
