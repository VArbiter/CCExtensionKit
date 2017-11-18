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

@interface NSTimer (CCChain_Assit)

+ (void) ccTimerAction : (NSTimer *) sender ;

@end

@implementation NSTimer (CCChain_Assit)

+ (void) ccTimerAction : (NSTimer *) sender {
    void (^t)(NSTimer *) = objc_getAssociatedObject(sender, _CC_NSTIMER_ASSOCIATE_TIMER_KEY_);
    if (t) t(sender);
    void (^s)(NSTimer *) = objc_getAssociatedObject(sender, _CC_NSTIMER_ASSOCIATE_SCHEDULED_KEY_);
    if (s) s(sender);
}

@end

@implementation NSTimer (CCExtension)

/// timer
+ (instancetype) ccTimer : (NSTimeInterval) interval
                  action : (void (^)(NSTimer *sender)) action {
    return [self ccTimer:interval
                  repeat:YES
                  action:action];
}

+ (instancetype) ccTimer : (NSTimeInterval) interval
                  repeat : (BOOL) isRepeat
                  action : (void (^)(NSTimer *sender)) action {
    return [self ccTimer:interval
                userInfo:nil
                  repeat:isRepeat
                  action:action];
}

+ (instancetype) ccTimer : (NSTimeInterval) interval
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
+ (instancetype) ccScheduled : (NSTimeInterval) interval
                      action : (void (^)(NSTimer *sender)) action {
    return [self ccScheduled:interval
                      repeat:YES
                      action:action];
}

+ (instancetype) ccScheduled : (NSTimeInterval) interval
                      repeat : (BOOL) isRepeat
                      action : (void (^)(NSTimer *sender)) action {
    return [self ccScheduled:interval
                    userInfo:nil
                      repeat:isRepeat
                      action:action];
}

+ (instancetype) ccScheduled : (NSTimeInterval) interval
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

- (instancetype) ccFire {
    if (self.isValid) {
        [self fire];
    }
    return self;
}
- (instancetype) ccPause {
    if (self.isValid) {
        self.fireDate = NSDate.distantFuture;
    }
    return self;
}
- (instancetype) ccResume {
    if (self.isValid) {
        self.fireDate = NSDate.date;
    }
    return self;
}
- (instancetype) ccStop {
    [self invalidate];
    return self;
}

@end
