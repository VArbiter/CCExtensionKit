//
//  CCAuthentication.m
//  CCExtensionKit
//
//  Created by ElwinFrederick on 24/04/2018.
//  Copyright © 2018 冯明庆. All rights reserved.
//

#import "CCAuthentication.h"

@import LocalAuthentication;
@import UIKit;

@interface CCAuthentication ()

@property (nonatomic , copy , readwrite) NSString * s_authentication_reason ;
@property (nonatomic , copy , readwrite) NSString * s_show ;
@property (nonatomic , strong , readwrite) LAContext *context ;

@end

@implementation CCAuthentication

- (instancetype) init_with_reason : (NSString *) s_authentication_reason
        show_password_if_bio_fail : (NSString *) s_show {
    if ((self = [super init])) {
        self.s_authentication_reason = s_authentication_reason;
        self.s_show = s_show;
    }
    return self;
}

- (instancetype) cc_start_authentication : (void(^)(void)) success_block
                                    fail : (void(^)(NSError * error)) fail_block {
    
    if (UIDevice.currentDevice.systemVersion.floatValue < 11.f) {
        NSError * error = nil;
        /**
         * LAPolicyDeviceOwnerAuthentication can input password
         * LAPolicyDeviceOwnerAuthenticationWithBiometrics only bio
         */
        BOOL is_can = [self.context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                                                error:&error];
        if (is_can) {
            [self cc_start_authentication_password:success_block fail:fail_block];
#if DEBUG
            NSLog(@"CCAuthentication ERROR :\n %@",error);
#endif
        }
        else [self cc_start_authentication_touch_id:success_block fail:fail_block];
        
    } else {
        if (@available(iOS 11.0, *)) {
            switch (self.context.biometryType) {
                case LABiometryTypeFaceID:{
                    [self cc_start_authentication_face_id:success_block fail:fail_block];
                }break;
                case LABiometryTypeTouchID:{
                    [self cc_start_authentication_touch_id:success_block fail:fail_block];
                }break;
                    
                default:{
                    [self cc_start_authentication_password:success_block fail:fail_block];
                }break;
            }
        }
    }
    return self;
}

- (instancetype) cc_start_authentication_face_id : (void (^)(void))success_block
                                            fail : (void (^)(NSError * error))fail_block {
    [self.context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:self.s_authentication_reason reply:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            if (success_block) success_block();
        }
        else if (fail_block) fail_block(error);
    }];
    return self;
}

- (instancetype) cc_start_authentication_touch_id : (void (^)(void))success_block
                                              fail:(void (^)(NSError * error))fail_block {
    [self.context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:self.s_authentication_reason reply:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            if (success_block) success_block();
        }
        else if (fail_block) fail_block(error);
    }];
    return self;
}

- (instancetype) cc_start_authentication_password : (void (^)(void))success_block
                                             fail : (void (^)(NSError * error))fail_block {
    
    LAPolicy policy = LAPolicyDeviceOwnerAuthentication;
    if (UIDevice.currentDevice.systemVersion.floatValue < 9.f) {
        policy = LAPolicyDeviceOwnerAuthenticationWithBiometrics;
    }
    
    [self.context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:self.s_authentication_reason reply:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            if (success_block) success_block();
        }
        else if (fail_block) fail_block(error);
    }];
    return self;
}

- (LAContext *)context {
    if (_context) return _context;
    LAContext *t = [[LAContext alloc] init];
    t.localizedFallbackTitle = self.s_show;
    _context = t;
    return _context;
}

@end
