//
//  CCBridgeWrapper.h
//  CCLocalLibrary
//
//  Created by Elwinfrederick on 14/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

#if __has_include(<MGJRouter/MGJRouter.h>)

typedef NSString *CCRouterOperateKey NS_EXTENSIBLE_STRING_ENUM;
typedef NSString *CCRouterRegistKey NS_EXTENSIBLE_STRING_ENUM;
typedef NSDictionary CCRouterPatternInfo;
typedef void (^CCRouterCompletionBlock)(id result);

#ifndef CC_ROUTER_W
    #define CC_ROUTER_W CCBridgeWrapper.shared
#endif

@import MGJRouter;

@interface CCBridgeWrapper : NSObject

/// note : what ever you use the 'alloc init' or some intial method ,
/// note : this Wrapper returns the same object ,
/// note : absolute singleton

+ (instancetype) new NS_UNAVAILABLE;
+ (instancetype) shared ;

// begin with scheme , like "loveCC://"
// note : only the first time have its effect (scheme can't be re-configured again) .
+ (instancetype) sharedWithScheme : (CCRouterRegistKey) sScheme ;

// regist
- (instancetype) ccRegistFallBack : (void (^)(CCRouterPatternInfo *dInfos)) fallBack ;
- (instancetype) ccRegistOperation : (CCRouterRegistKey) sURL
                            action : (void(^)(CCRouterPatternInfo *dInfos)) action ;
- (instancetype) ccRegistObject : (CCRouterRegistKey) sURL
                          value : (id(^)(id value)) value ;

// deregist
- (instancetype) ccDeregist : (CCRouterRegistKey) sURL ;

// open
- (BOOL) ccIsCanOpen : (CCRouterRegistKey) sURL ;
- (instancetype) ccCall : (CCRouterPatternInfo *) dPattern
               fallBack : (void(^)(CCRouterPatternInfo *dInfos)) fallback ;

- (id) ccGet : (CCRouterPatternInfo *) dPattern
    fallBack : (void(^)(CCRouterPatternInfo *)) fallback ;

FOUNDATION_EXPORT CCRouterOperateKey const _CC_ROUTER_PARAMS_URL_;
FOUNDATION_EXPORT CCRouterOperateKey const _CC_ROUTER_PARAMS_COMPLETION_;
FOUNDATION_EXPORT CCRouterOperateKey const _CC_ROUTER_PARAMS_USER_INFO_;
FOUNDATION_EXPORT CCRouterOperateKey _CC_ROUTER_FALL_BACK_URL_ ; // can be customed by user with 'sharedWithScheme:' methods

CCRouterPatternInfo * CC_URL_PATTERN_MAKE(CCRouterRegistKey sURL ,
                                          NSDictionary *dUserInfo) ;

/// note : completion block only works with regist methods
/// note : if uses in call method , completion will have no values .
CCRouterPatternInfo * CC_URL_PATTERN_COMPLETION_MAKE(CCRouterRegistKey sURL ,
                                                     NSDictionary *dUserInfo ,
                                                     CCRouterCompletionBlock) ;

@end

#endif
