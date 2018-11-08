//
//  MQBridgeWrapper.m
//  MQExtensionKit
//
//  Created by Elwinfrederick on 14/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "MQBridgeWrapper.h"

#if __has_include(<MGJRouter/MGJRouter.h>)

MQRouterOperateKey const mq_router_params_url = @"MQ_ROUTER_PARAMS_URL";
MQRouterOperateKey const mq_router_params_completion = @"MQ_ROUTER_PARAMS_COMPLETION";
MQRouterOperateKey const mq_router_params_userinfo = @"MQ_ROUTER_PARAMS_USER_INFO";
MQRouterOperateKey mq_router_fallback_url = @"elwinfrederick://";

@interface MQBridgeWrapper () < NSCopying , NSMutableCopying >

NSDictionary * mq_transfer_MGJ_parameters(NSDictionary *dParams);
NSString * mq_append_url_scheme(MQRouterRegistKey sURL , BOOL isRegist);

@end

static MQBridgeWrapper *__router = nil;

@implementation MQBridgeWrapper

+ (instancetype) mq_shared {
    if (__router) return __router;
    __router = [[MQBridgeWrapper alloc] init];
    return __router;
}
+ (instancetype) mq_shared_with_scheme : (MQRouterRegistKey) sScheme {
    if (!__router) {
        mq_router_fallback_url = sScheme;
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
    [MGJRouter registerURLPattern:mq_router_fallback_url toHandler:^(NSDictionary *routerParameters) {
        if (fallBack) fallBack(mq_transfer_MGJ_parameters(routerParameters));
    }];
    return self;
}
- (instancetype) mq_regist_operation : (MQRouterRegistKey) sURL
                              action : (void(^)(MQRouterPatternInfo *dInfos)) action {
    [MGJRouter registerURLPattern:mq_append_url_scheme(sURL , YES) toHandler:^(NSDictionary *routerParameters) {
        if (action) action(mq_transfer_MGJ_parameters(routerParameters));
    }];
    return self;
}
- (instancetype) mq_regist_object : (MQRouterRegistKey) sURL
                            value : (id(^)(MQRouterPatternInfo *dInfos)) value {
    [MGJRouter registerURLPattern:mq_append_url_scheme(sURL , YES) toObjectHandler:^id(NSDictionary *routerParameters) {
        if (value) return value(mq_transfer_MGJ_parameters(routerParameters));
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
    return [MGJRouter canOpenURL:mq_append_url_scheme(sURL , false)];
}

- (instancetype) mq_call : (MQRouterPatternInfo *) dPattern
                fallback : (void(^)(MQRouterPatternInfo *dInfos)) fallback {
    if (![MGJRouter canOpenURL:mq_append_url_scheme(dPattern[mq_router_params_url] , false)]) {
        if (fallback) fallback(dPattern);
        return self;
    }
    
    [MGJRouter openURL:mq_append_url_scheme(dPattern[mq_router_params_url] , false)
          withUserInfo:dPattern[mq_router_params_userinfo] completion:^(id result) {
              MQRouterCompletionBlock b = dPattern[mq_router_params_completion];
              if (b) b(result);
          }];
    return self;
}

- (id) mq_get : (MQRouterPatternInfo *) dPattern
     fallback : (void(^)(MQRouterPatternInfo *)) fallback {
    id v = [MGJRouter objectForURL:mq_append_url_scheme(dPattern[mq_router_params_url] , false)
                      withUserInfo:dPattern[mq_router_params_userinfo]];
    if (v) return v;
    else if (fallback) fallback(dPattern);
    return nil;
}

MQRouterPatternInfo * mq_router_url_make(MQRouterRegistKey sURL) {
    return mq_router_url_pattern_make(sURL, nil);
}
MQRouterPatternInfo * mq_router_url_pattern_make(MQRouterRegistKey sURL , NSDictionary *dUserInfo) {
    return mq_router_url_pattern_completion_make(sURL, dUserInfo, nil);
}
MQRouterPatternInfo * mq_router_url_pattern_completion_make(MQRouterRegistKey sURL ,
                                                            NSDictionary *dUserInfo ,
                                                        void (^completion)(id result)) {
    NSMutableDictionary *d= [NSMutableDictionary dictionary];
    [d setValue:sURL forKey:mq_router_params_url];
    [d setValue:dUserInfo forKey:mq_router_params_userinfo];
    [d setValue:completion forKey:mq_router_params_completion];
    return d.copy;
}

NSDictionary * mq_transfer_MGJ_parameters(NSDictionary *dParams) {
    NSMutableDictionary *d = [NSMutableDictionary dictionary];
    [d setValue:dParams[MGJRouterParameterURL] forKey:mq_router_params_url];
    [d setValue:dParams[MGJRouterParameterUserInfo] forKey:mq_router_params_userinfo];
    [d setValue:dParams[MGJRouterParameterCompletion] forKey:mq_router_params_completion];
    return d;
}
NSString * mq_append_url_scheme(MQRouterRegistKey sURL , BOOL isRegist) {
    if (sURL && (sURL.length > 0)) {
        return [mq_router_fallback_url stringByAppendingString:sURL];
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
