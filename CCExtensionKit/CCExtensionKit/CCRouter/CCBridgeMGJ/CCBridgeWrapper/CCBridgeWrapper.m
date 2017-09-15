//
//  CCBridgeWrapper.m
//  CCLocalLibrary
//
//  Created by Elwinfrederick on 14/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "CCBridgeWrapper.h"

#if __has_include(<MGJRouter/MGJRouter.h>)

NSString * const _CC_ROUTER_PARAMS_URL_ = @"CC_ROUTER_PARAMS_URL";
NSString * const _CC_ROUTER_PARAMS_COMPLETION_ = @"CC_ROUTER_PARAMS_COMPLETION";
NSString * const _CC_ROUTER_PARAMS_USER_INFO_ = @"CC_ROUTER_PARAMS_USER_INFO";
NSString * const _CC_ROUTER_FALL_BACK_URL_ = @"loveCC://";

@interface CCBridgeWrapper () < NSCopying , NSMutableCopying >

@property (nonatomic , copy , readonly) NSString *(^format)(NSString *);
@property (nonatomic , copy , readonly) NSDictionary *(^transferMGJ)(NSDictionary *d) ;

@end

static CCBridgeWrapper *__router = nil;

@implementation CCBridgeWrapper

+ (instancetype) shared {
    if (__router) return __router;
    __router = [[CCBridgeWrapper alloc] init];
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

- (instancetype) ccFallBack : (void (^)()) fallBack {
    [MGJRouter registerURLPattern:_CC_ROUTER_FALL_BACK_URL_ toHandler:^(NSDictionary *routerParameters) {
        if (fallBack) fallBack();
    }];
    return self;
}
- (instancetype) ccRegist : (NSString *) sURL
                   action : (void(^)(NSDictionary *)) action {
    __weak typeof(self) pSelf = self;
    [MGJRouter registerURLPattern:pSelf.format(sURL) toHandler:^(NSDictionary *routerParameters) {
        if (action) action(pSelf.transferMGJ(routerParameters));
    }];
    return self;
}
- (instancetype) ccCall : (NSString *) sURL
               fallBack : (void(^)()) fallback {
    if ([MGJRouter canOpenURL:self.format(sURL)]) {
        [MGJRouter openURL:self.format(sURL)];
    } else if (fallback) fallback();
    return self;
}
- (instancetype) ccCall : (NSString *) sURL
               userInfo : (id) userInfo
               fallBack : (void(^)()) fallback {
    if (![MGJRouter canOpenURL:self.format(sURL)]) {
        if (fallback) fallback();
        return self;
    }
    
    [MGJRouter openURL:self.format(sURL) withUserInfo:userInfo completion:nil];
    return self;
}
- (instancetype) ccObject : (NSString *) sURL
                    value : (id(^)()) value {
    __weak typeof(self) pSelf = self;
    [MGJRouter registerURLPattern:self.format(sURL) toObjectHandler:^id(NSDictionary *routerParameters) {
        if (value) return value(pSelf.transferMGJ(routerParameters));
        return nil;
    }];
    return self;
}
- (id) ccGet : (NSString *) sURL
    fallBack : (void(^)()) fallback {
    return [self ccGet:sURL
              userInfo:nil
              fallBack:fallback];
}
- (id) ccGet : (NSString *) sURL
    userInfo : (id) userInfo
    fallBack : (void(^)()) fallback {
    id v = [MGJRouter objectForURL:self.format(sURL) withUserInfo:userInfo];
    if (v) return v;
    else if (fallback) fallback();
    return nil;
}

@end

#endif
