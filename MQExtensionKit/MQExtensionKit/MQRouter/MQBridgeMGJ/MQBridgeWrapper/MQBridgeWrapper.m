//
//  MQBridgeWrapper.m
//  MQExtensionKit
//
//  Created by Elwinfrederick on 14/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "MQBridgeWrapper.h"

#if __has_include(<MGJRouter/MGJRouter.h>)

MQRouterOperateKey const _MQ_ROUTER_PARAMS_URL_ = @"MQ_ROUTER_PARAMS_URL";
MQRouterOperateKey const _MQ_ROUTER_PARAMS_COMPLETION_ = @"MQ_ROUTER_PARAMS_COMPLETION";
MQRouterOperateKey const _MQ_ROUTER_PARAMS_USER_INFO_ = @"MQ_ROUTER_PARAMS_USER_INFO";
MQRouterOperateKey _MQ_ROUTER_FALL_BACK_URL_ = @"elwinfrederick://";

@interface MQBridgeWrapper () < NSCopying , NSMutableCopying >

NSDictionary * MQ_TRANSFER_MGJ_PARAMETERS(NSDictionary *dParams);
NSString * MQ_APPEND_URL_SCHEME(MQRouterRegistKey sURL , BOOL isRegist);

@end

static MQBridgeWrapper *__router = nil;

@implementation MQBridgeWrapper

//+ (void)initialize {
//    [MQBridgeWrapper mq_shared];
//}

+ (instancetype) mq_shared {
    if (__router) return __router;
    __router = [[MQBridgeWrapper alloc] init];
    return __router;
}
+ (instancetype) mq_shared_with_scheme : (MQRouterRegistKey) sScheme {
    if (!__router) {
        _MQ_ROUTER_FALL_BACK_URL_ = sScheme;
        return self.mq_shared;
    }
    return __router;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    if (__router) return __router;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __router = [super allocWithZone:zone];
    });
    return __router;
}

- (id)copyWithZone:(NSZone *)zone {
    return __router;
}
- (id)mutableCopyWithZone:(NSZone *)zone {
    return __router;
}

#pragma mark -

// regist
- (instancetype) mq_regist_fallback : (void (^)(MQRouterPatternInfo *dInfos)) fallBack {
    [MGJRouter registerURLPattern:_MQ_ROUTER_FALL_BACK_URL_ toHandler:^(NSDictionary *routerParameters) {
        if (fallBack) fallBack(MQ_TRANSFER_MGJ_PARAMETERS(routerParameters));
    }];
    return self;
}
- (instancetype) mq_regist_operation : (MQRouterRegistKey) sURL
                              action : (void(^)(MQRouterPatternInfo *dInfos)) action {
    [MGJRouter registerURLPattern:MQ_APPEND_URL_SCHEME(sURL , YES) toHandler:^(NSDictionary *routerParameters) {
        if (action) action(MQ_TRANSFER_MGJ_PARAMETERS(routerParameters));
    }];
    return self;
}
- (instancetype) mq_regist_object : (MQRouterRegistKey) sURL
                            value : (id(^)(MQRouterPatternInfo *dInfos)) value {
    [MGJRouter registerURLPattern:MQ_APPEND_URL_SCHEME(sURL , YES) toObjectHandler:^id(NSDictionary *routerParameters) {
        if (value) return value(MQ_TRANSFER_MGJ_PARAMETERS(routerParameters));
        return nil;
    }];
    return self;
}

// deregist
- (instancetype) mq_deregist : (MQRouterRegistKey) sURL {
    [MGJRouter deregisterURLPattern:sURL];
    return self;
}

// open
- (BOOL) mq_is_can_open : (MQRouterRegistKey) sURL  {
    return [MGJRouter canOpenURL:MQ_APPEND_URL_SCHEME(sURL , false)];
}

- (instancetype) mq_call : (MQRouterPatternInfo *) dPattern
                fallback : (void(^)(MQRouterPatternInfo *dInfos)) fallback {
    if (![MGJRouter canOpenURL:MQ_APPEND_URL_SCHEME(dPattern[_MQ_ROUTER_PARAMS_URL_] , false)]) {
        if (fallback) fallback(dPattern);
        return self;
    }
    
    [MGJRouter openURL:MQ_APPEND_URL_SCHEME(dPattern[_MQ_ROUTER_PARAMS_URL_] , false)
          withUserInfo:dPattern[_MQ_ROUTER_PARAMS_USER_INFO_] completion:^(id result) {
              MQRouterCompletionBlock b = dPattern[_MQ_ROUTER_PARAMS_COMPLETION_];
              if (b) b(result);
          }];
    return self;
}

- (id) mq_get : (MQRouterPatternInfo *) dPattern
     fallback : (void(^)(MQRouterPatternInfo *)) fallback {
    id v = [MGJRouter objectForURL:MQ_APPEND_URL_SCHEME(dPattern[_MQ_ROUTER_PARAMS_URL_] , false)
                      withUserInfo:dPattern[_MQ_ROUTER_PARAMS_USER_INFO_]];
    if (v) return v;
    else if (fallback) fallback(dPattern);
    return nil;
}

MQRouterPatternInfo * MQ_URL_MAKE(MQRouterRegistKey sURL) {
    return MQ_URL_PATTERN_MAKE(sURL, nil);
}
MQRouterPatternInfo * MQ_URL_PATTERN_MAKE(MQRouterRegistKey sURL , NSDictionary *dUserInfo) {
    return MQ_URL_PATTERN_COMPLETION_MAKE(sURL, dUserInfo, nil);
}
MQRouterPatternInfo * MQ_URL_PATTERN_COMPLETION_MAKE(MQRouterRegistKey sURL ,
                                                     NSDictionary *dUserInfo ,
                                                     void (^completion)(id result)) {
    NSMutableDictionary *d= [NSMutableDictionary dictionary];
    [d setValue:sURL forKey:_MQ_ROUTER_PARAMS_URL_];
    [d setValue:dUserInfo forKey:_MQ_ROUTER_PARAMS_USER_INFO_];
    [d setValue:completion forKey:_MQ_ROUTER_PARAMS_COMPLETION_];
    return d.copy;
}

NSDictionary * MQ_TRANSFER_MGJ_PARAMETERS(NSDictionary *dParams) {
    NSMutableDictionary *d = [NSMutableDictionary dictionary];
    [d setValue:dParams[MGJRouterParameterURL] forKey:_MQ_ROUTER_PARAMS_URL_];
    [d setValue:dParams[MGJRouterParameterUserInfo] forKey:_MQ_ROUTER_PARAMS_USER_INFO_];
    [d setValue:dParams[MGJRouterParameterCompletion] forKey:_MQ_ROUTER_PARAMS_COMPLETION_];
    return d;
}
NSString * MQ_APPEND_URL_SCHEME(MQRouterRegistKey sURL , BOOL isRegist) {
    if (sURL && (sURL.length > 0)) {
        return [_MQ_ROUTER_FALL_BACK_URL_ stringByAppendingString:sURL];
    } else if (sURL) {
        NSLog(@" ----- regist url is equal to @\"\" , will fall back to root .");
    }
    else if (isRegist) {
        @throw @"regist url can't be nil";
    }
    return nil;
}

@end

#endif
