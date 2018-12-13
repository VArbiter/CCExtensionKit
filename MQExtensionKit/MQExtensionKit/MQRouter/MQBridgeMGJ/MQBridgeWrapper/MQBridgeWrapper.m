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

NSDictionary * mq_transfer_MGJ_parameters(NSDictionary *d_params);
NSString * mq_append_url_scheme(MQRouterRegistKey s_url , BOOL is_regist);

@end

static MQBridgeWrapper *__router = nil;

@implementation MQBridgeWrapper

+ (instancetype) mq_shared {
    if (__router) return __router;
    __router = [[MQBridgeWrapper alloc] init];
    return __router;
}
+ (instancetype) mq_shared_with_scheme : (MQRouterRegistKey) s_scheme {
    if (!__router) {
        mq_router_fallback_url = s_scheme;
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
- (instancetype) mq_regist_fallback : (void (^)(MQRouterPatternInfo *d_infos)) fallBack {
    [MGJRouter registerURLPattern:mq_router_fallback_url toHandler:^(NSDictionary *routerParameters) {
        if (fallBack) fallBack(mq_transfer_MGJ_parameters(routerParameters));
    }];
    return self;
}
- (instancetype) mq_regist_operation : (MQRouterRegistKey) s_url
                              action : (void(^)(MQRouterPatternInfo *d_infos)) action {
    [MGJRouter registerURLPattern:mq_append_url_scheme(s_url , YES) toHandler:^(NSDictionary *routerParameters) {
        if (action) action(mq_transfer_MGJ_parameters(routerParameters));
    }];
    return self;
}
- (instancetype) mq_regist_object : (MQRouterRegistKey) s_url
                            value : (id(^)(MQRouterPatternInfo *d_infos)) value {
    [MGJRouter registerURLPattern:mq_append_url_scheme(s_url , YES) toObjectHandler:^id(NSDictionary *routerParameters) {
        if (value) return value(mq_transfer_MGJ_parameters(routerParameters));
        return nil;
    }];
    return self;
}

// deregist
- (instancetype) mq_deregist : (MQRouterRegistKey) s_url {
    [MGJRouter deregisterURLPattern:s_url];
    return self;
}

// open
- (BOOL) mq_is_can_open : (MQRouterRegistKey) s_url  {
    return [MGJRouter canOpenURL:mq_append_url_scheme(s_url , false)];
}

- (instancetype) mq_call : (MQRouterPatternInfo *) d_pattern
                fallback : (void(^)(MQRouterPatternInfo *d_infos)) fallback {
    if (![MGJRouter canOpenURL:mq_append_url_scheme(d_pattern[mq_router_params_url] , false)]) {
        if (fallback) fallback(d_pattern);
        return self;
    }
    
    [MGJRouter openURL:mq_append_url_scheme(d_pattern[mq_router_params_url] , false)
          withUserInfo:d_pattern[mq_router_params_userinfo] completion:^(id result) {
              MQRouterCompletionBlock b = d_pattern[mq_router_params_completion];
              if (b) b(result);
          }];
    return self;
}

- (id) mq_get : (MQRouterPatternInfo *) d_pattern
     fallback : (void(^)(MQRouterPatternInfo *)) fallback {
    id v = [MGJRouter objectForURL:mq_append_url_scheme(d_pattern[mq_router_params_url] , false)
                      withUserInfo:d_pattern[mq_router_params_userinfo]];
    if (v) return v;
    else if (fallback) fallback(d_pattern);
    return nil;
}

MQRouterPatternInfo * mq_router_url_make(MQRouterRegistKey s_url) {
    return mq_router_url_pattern_make(s_url, nil);
}
MQRouterPatternInfo * mq_router_url_pattern_make(MQRouterRegistKey s_url , NSDictionary *d_user_info) {
    return mq_router_url_pattern_completion_make(s_url, d_user_info, nil);
}
MQRouterPatternInfo * mq_router_url_pattern_completion_make(MQRouterRegistKey s_url ,
                                                            NSDictionary *d_user_info ,
                                                        void (^completion)(id result)) {
    NSMutableDictionary *d= [NSMutableDictionary dictionary];
    [d setValue:s_url forKey:mq_router_params_url];
    [d setValue:d_user_info forKey:mq_router_params_userinfo];
    [d setValue:completion forKey:mq_router_params_completion];
    return d.copy;
}

NSDictionary * mq_transfer_MGJ_parameters(NSDictionary *d_params) {
    NSMutableDictionary *d = [NSMutableDictionary dictionary];
    [d setValue:d_params[MGJRouterParameterURL] forKey:mq_router_params_url];
    [d setValue:d_params[MGJRouterParameterUserInfo] forKey:mq_router_params_userinfo];
    [d setValue:d_params[MGJRouterParameterCompletion] forKey:mq_router_params_completion];
    return d;
}
NSString * mq_append_url_scheme(MQRouterRegistKey s_url , BOOL is_regist) {
    if (s_url && (s_url.length > 0)) {
        return [mq_router_fallback_url stringByAppendingString:s_url];
    } else if (s_url) {
        NSLog(@" ----- regist url is equal to @\"\" , will fall back to root .");
    }
    else if (is_regist) {
        @throw @"regist url can't be nil";
    }
    return nil;
}

@end

#endif
