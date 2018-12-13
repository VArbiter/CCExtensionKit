//
//  SVProgressHUD+MQExtension.m
//  MQExtensionKit
//
//  Created by ElwinFrederick on 2018/8/1.
//  Copyright © 2018 ElwinFrederick. All rights reserved.
//

#import "SVProgressHUD+MQExtension.h"

@interface SVProgressHUD (MQExtension_Assist)

@property (nonatomic , class , readonly) NSMutableDictionary < NSString * , void(^)(NSNotification * , NSString * , id) > *dictionary_notification_block ;

+ (void) mq_add_notification ;
+ (void) mq_remove_notification ;
+ (void) mq_handle_notification : (NSNotification *) sender ;

#if TARGET_OS_IOS && __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
@property (nonatomic, readonly) UINotificationFeedbackGenerator *mq_haptic_generator NS_AVAILABLE_IOS(10_0);
#endif

@end

@implementation SVProgressHUD (MQExtension_Assist)

static NSMutableDictionary *__d_notification_block = nil;

+ (NSMutableDictionary<NSString *,void (^)(NSNotification *, NSString * , id)> *)dictionary_notification_block {
    if (__d_notification_block) return __d_notification_block;
    NSMutableDictionary *t = [NSMutableDictionary dictionary];
    __d_notification_block = t;
    return __d_notification_block;
}

+ (void) mq_add_notification {
    NSNotificationCenter *notification_center = [NSNotificationCenter defaultCenter];
    [notification_center addObserver:self
                            selector:@selector(mq_handle_notification:)
                                name:SVProgressHUDWillAppearNotification
                              object:nil];
    [notification_center addObserver:self
                            selector:@selector(mq_handle_notification:)
                                name:SVProgressHUDDidAppearNotification
                              object:nil];
    
    [notification_center addObserver:self
                            selector:@selector(mq_handle_notification:)
                                name:SVProgressHUDWillDisappearNotification
                              object:nil];
    [notification_center addObserver:self
                            selector:@selector(mq_handle_notification:)
                                name:SVProgressHUDDidDisappearNotification
                              object:nil];
    
    [notification_center addObserver:self
                            selector:@selector(mq_handle_notification:)
                                name:SVProgressHUDDidTouchDownInsideNotification
                              object:nil];
    [notification_center addObserver:self
                            selector:@selector(mq_handle_notification:)
                                name:SVProgressHUDDidReceiveTouchEventNotification
                              object:nil];
}

+ (void) mq_remove_notification {
    NSNotificationCenter *notification_center = [NSNotificationCenter defaultCenter];
    [notification_center removeObserver:self
                                   name:SVProgressHUDWillAppearNotification
                                 object:nil];
    [notification_center removeObserver:self
                                   name:SVProgressHUDDidAppearNotification
                                 object:nil];
    
    [notification_center removeObserver:self
                                   name:SVProgressHUDWillDisappearNotification
                                 object:nil];
    [notification_center removeObserver:self
                                   name:SVProgressHUDDidDisappearNotification
                                 object:nil];
    
    [notification_center removeObserver:self
                                   name:SVProgressHUDDidTouchDownInsideNotification
                                 object:nil];
    [notification_center removeObserver:self
                                   name:SVProgressHUDDidReceiveTouchEventNotification
                                 object:nil];
}

+ (void) mq_handle_notification : (NSNotification *) sender {
    [self.dictionary_notification_block.allValues enumerateObjectsUsingBlock:^(void (^ _Nonnull obj)(NSNotification *, NSString *, id), NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj) obj(sender , sender.name , sender.userInfo[SVProgressHUDStatusUserInfoKey]);
    }];
}

#if TARGET_OS_IOS && __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
- (UINotificationFeedbackGenerator *)mq_haptic_generator {
    UINotificationFeedbackGenerator *t = [self valueForKeyPath:@"hapticGenerator"];
    if (t && [t isKindOfClass:UINotificationFeedbackGenerator.class]) {
        return t;
    }
    return nil;
}
#endif

@end

#pragma mark - -----

@implementation SVProgressHUD (MQExtension)

static BOOL __SVProgressHUD_is_added_notification = false ;

+ (void) mq_notification : (void(^)(NSNotification *sender ,
                                    NSString * s_notification_name,
                                    id user_info)) mq_notification_block
                 for_key : (NSString *) s_key {
    
    if (!__SVProgressHUD_is_added_notification) {
        [self mq_add_notification];
        __SVProgressHUD_is_added_notification = YES;
    }
    
    if (mq_notification_block && s_key) {
        [self.dictionary_notification_block setValue:mq_notification_block
                                              forKey:s_key];
    }
    
}

+ (void) mq_notification_remove_for_key : (NSString *) s_key {
    if (s_key && [self.dictionary_notification_block valueForKey:s_key]) {
        [self.dictionary_notification_block removeObjectForKey:s_key];
    }
}
+ (void) mq_notification_remove_all {
    [self.dictionary_notification_block removeAllObjects];
    [self mq_remove_notification];
    __SVProgressHUD_is_added_notification = false;
}

#pragma mark - -----

+ (instancetype) mq_instance {
    return [[self alloc] initWithFrame:[[[UIApplication sharedApplication] delegate] window].bounds];
}

- (instancetype) mq_show {
    return [self mq_show_with_status:nil];
}

- (instancetype) mq_show_with_status : (NSString *) status {
    return [self mq_show_progress:-1
                           status:status];
}

- (instancetype) mq_show_progress : (float) f_progress {
    return [self mq_show_progress:f_progress status:nil];
}
- (instancetype) mq_show_progress : (float) f_progress
                           status : (NSString *) status {
    SEL selector = NSSelectorFromString(@"showProgress:status:");
    if ([self respondsToSelector:selector]) {
        NSMethodSignature *singture = [[self class] instanceMethodSignatureForSelector:selector];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:singture];
        [invocation setTarget:self];
        [invocation setSelector:selector];
        [invocation setArgument:&f_progress atIndex:2];
        [invocation setArgument:&status atIndex:3];
        [invocation retainArguments];
        [invocation invoke];
    }
    return self;
}

- (instancetype) mq_set_status : (NSString *) status {
    if ([self respondsToSelector:@selector(setStatus:)]) {
        [self performSelector:@selector(setStatus:)
                   withObject:status];
    }
    return self;
}

- (instancetype) mq_show_info : (NSString *) status {
    [self mq_show_image:self.infoImage status:status];
    
#if TARGET_OS_IOS && __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
    if (@available(iOS 10.0, *)) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mq_haptic_generator notificationOccurred:UINotificationFeedbackTypeWarning];
        });
    }
#endif
    return self;
}
- (instancetype) mq_show_success : (NSString *) status {
    [self mq_show_image:self.successImage status:status];
    
#if TARGET_OS_IOS && __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
    if (@available(iOS 10.0, *)) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mq_haptic_generator notificationOccurred:UINotificationFeedbackTypeSuccess];
        });
    }
#endif
    return self;
}
- (instancetype) mq_show_error : (NSString *) status {
     [self mq_show_image:self.errorImage status:status];
#if TARGET_OS_IOS && __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
    if (@available(iOS 10.0, *)) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mq_haptic_generator notificationOccurred:UINotificationFeedbackTypeError];
        });
    }
#endif
    return self;
}

- (instancetype) mq_show_image : (UIImage *) image
                        status : (NSString *) status {
    NSTimeInterval interval_display = [SVProgressHUD displayDurationForString:status];
    SEL selector = NSSelectorFromString(@"showImage:status:duration:");
    if ([self respondsToSelector:selector]) {
        NSMethodSignature *singture = [[self class] instanceMethodSignatureForSelector:selector];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:singture];
        [invocation setTarget:self];
        [invocation setSelector:selector];
        [invocation setArgument:&image atIndex:2];
        [invocation setArgument:&status atIndex:3];
        [invocation setArgument:&interval_display atIndex:4];
        [invocation retainArguments];
        [invocation invoke];
    }
    return self;
}

- (instancetype) mq_dismiss {
    if ([self respondsToSelector:@selector(dismiss)]) {
        [self performSelector:@selector(dismiss)];
    }
    return self;
}
- (instancetype) mq_dismiss_delay : (NSTimeInterval) f_delay {
    return [self mq_dismiss_delay:f_delay completion:nil];
}
- (instancetype) mq_dismiss_completion : (SVProgressHUDDismissCompletion) completion {
    return [self mq_dismiss_delay:.0f completion:completion];
}
- (instancetype) mq_dismiss_delay : (NSTimeInterval) f_delay
                       completion : (SVProgressHUDDismissCompletion) completion {
    SEL selector = NSSelectorFromString(@"dismissWithDelay:completion:");
    if ([self respondsToSelector:selector]) {
        NSMethodSignature *singture = [[self class] instanceMethodSignatureForSelector:selector];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:singture];
        [invocation setTarget:self];
        [invocation setSelector:selector];
        [invocation setArgument:&f_delay atIndex:2];
        [invocation setArgument:&completion atIndex:3];
        [invocation retainArguments];
        [invocation invoke];
    }
    return self;
}

- (BOOL) mq_is_visible {
    UIView *v = [self valueForKeyPath:@"backgroundView"] ;
    if ([v isKindOfClass:UIView.class]) return v.alpha > 0.0f;
    return false;
}

@end
