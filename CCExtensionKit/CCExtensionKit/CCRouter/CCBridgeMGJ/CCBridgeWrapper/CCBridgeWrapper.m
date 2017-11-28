//
//  CCBridgeWrapper.m
//  CCLocalLibrary
//
//  Created by Elwinfrederick on 14/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "CCBridgeWrapper.h"

#if __has_include(<MGJRouter/MGJRouter.h>)

CCRouterOperateKey const _CC_ROUTER_PARAMS_URL_ = @"CC_ROUTER_PARAMS_URL";
CCRouterOperateKey const _CC_ROUTER_PARAMS_COMPLETION_ = @"CC_ROUTER_PARAMS_COMPLETION";
CCRouterOperateKey const _CC_ROUTER_PARAMS_USER_INFO_ = @"CC_ROUTER_PARAMS_USER_INFO";
CCRouterOperateKey _CC_ROUTER_FALL_BACK_URL_ = @"loveCC://";

@interface CCBridgeWrapper () < NSCopying , NSMutableCopying >

NSDictionary * CC_TRANSFER_MGJ_PARAMETERS(NSDictionary *dParams);
NSString * CC_APPEND_URL_SCHEME(CCRouterRegistKey sURL , BOOL isRegist);

@end

static CCBridgeWrapper *__router = nil;

@implementation CCBridgeWrapper

//+ (void)initialize {
//    [CCBridgeWrapper shared];
//}

+ (instancetype) shared {
    if (__router) return __router;
    __router = [[CCBridgeWrapper alloc] init]; 
    return __router;
}
+ (instancetype) sharedWithScheme : (CCRouterRegistKey) sScheme {
    if (!__router) {
        _CC_ROUTER_FALL_BACK_URL_ = sScheme;
        return self.shared;
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
- (instancetype) ccRegistFallBack : (void (^)(CCRouterPatternInfo *dInfos)) fallBack {
    [MGJRouter registerURLPattern:_CC_ROUTER_FALL_BACK_URL_ toHandler:^(NSDictionary *routerParameters) {
        if (fallBack) fallBack(CC_TRANSFER_MGJ_PARAMETERS(routerParameters));
    }];
    return self;
}
- (instancetype) ccRegistOperation : (CCRouterRegistKey) sURL
                            action : (void(^)(CCRouterPatternInfo *dInfos)) action {
    [MGJRouter registerURLPattern:CC_APPEND_URL_SCHEME(sURL , YES) toHandler:^(NSDictionary *routerParameters) {
        if (action) action(CC_TRANSFER_MGJ_PARAMETERS(routerParameters));
    }];
    return self;
}
- (instancetype) ccRegistObject : (CCRouterRegistKey) sURL
                          value : (id(^)(id value)) value {
    [MGJRouter registerURLPattern:CC_APPEND_URL_SCHEME(sURL , YES) toObjectHandler:^id(NSDictionary *routerParameters) {
        if (value) return value(CC_TRANSFER_MGJ_PARAMETERS(routerParameters));
        return nil;
    }];
    return self;
}

// deregist
- (instancetype) ccDeregist : (CCRouterRegistKey) sURL {
    [MGJRouter deregisterURLPattern:sURL];
    return self;
}

// open
- (BOOL) ccIsCanOpen : (CCRouterRegistKey) sURL  {
    return [MGJRouter canOpenURL:CC_APPEND_URL_SCHEME(sURL , false)];
}

- (instancetype) ccCall : (CCRouterPatternInfo *) dPattern
               fallBack : (void(^)(CCRouterPatternInfo *dInfos)) fallback {
    if (![MGJRouter canOpenURL:CC_APPEND_URL_SCHEME(dPattern[_CC_ROUTER_PARAMS_URL_] , false)]) {
        if (fallback) fallback(dPattern);
        return self;
    }
    
    [MGJRouter openURL:CC_APPEND_URL_SCHEME(dPattern[_CC_ROUTER_PARAMS_URL_] , false)
          withUserInfo:dPattern[_CC_ROUTER_PARAMS_USER_INFO_] completion:^(id result) {
              CCRouterCompletionBlock b = dPattern[_CC_ROUTER_PARAMS_COMPLETION_];
              if (b) b(result);
          }];
    return self;
}

- (id) ccGet : (CCRouterPatternInfo *) dPattern
    fallBack : (void(^)(CCRouterPatternInfo *)) fallback {
    id v = [MGJRouter objectForURL:CC_APPEND_URL_SCHEME(dPattern[_CC_ROUTER_PARAMS_URL_] , false)
                      withUserInfo:dPattern[_CC_ROUTER_PARAMS_USER_INFO_]];
    if (v) return v;
    else if (fallback) fallback(dPattern);
    return nil;
}

CCRouterPatternInfo * CC_URL_PATTERN_MAKE(CCRouterRegistKey sURL , NSDictionary *dUserInfo) {
    return CC_URL_PATTERN_COMPLETION_MAKE(sURL, dUserInfo, nil);
}
CCRouterPatternInfo * CC_URL_PATTERN_COMPLETION_MAKE(CCRouterRegistKey sURL ,
                                                     NSDictionary *dUserInfo ,
                                                     void (^completion)(id result)) {
    NSMutableDictionary *d= [NSMutableDictionary dictionary];
    [d setValue:sURL forKey:_CC_ROUTER_PARAMS_URL_];
    [d setValue:dUserInfo forKey:_CC_ROUTER_PARAMS_USER_INFO_];
    [d setValue:completion forKey:_CC_ROUTER_PARAMS_COMPLETION_];
    return d.copy;
}

NSDictionary * CC_TRANSFER_MGJ_PARAMETERS(NSDictionary *dParams) {
    NSMutableDictionary *d = [NSMutableDictionary dictionary];
    [d setValue:dParams[MGJRouterParameterURL] forKey:_CC_ROUTER_PARAMS_URL_];
    [d setValue:dParams[MGJRouterParameterUserInfo] forKey:_CC_ROUTER_PARAMS_USER_INFO_];
    [d setValue:dParams[MGJRouterParameterCompletion] forKey:_CC_ROUTER_PARAMS_COMPLETION_];
    return d;
}
NSString * CC_APPEND_URL_SCHEME(CCRouterRegistKey sURL , BOOL isRegist) {
    if (sURL && (sURL.length > 0)) {
        return [_CC_ROUTER_FALL_BACK_URL_ stringByAppendingString:sURL];
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
