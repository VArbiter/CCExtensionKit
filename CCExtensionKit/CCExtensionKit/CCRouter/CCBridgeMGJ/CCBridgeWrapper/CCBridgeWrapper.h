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
    #define CC_ROUTER_W CCBridgeWrapper.cc_shared
#endif

@import MGJRouter;

@interface CCBridgeWrapper : NSObject

/// note : what ever you use the 'alloc init' or some intial method , // 所有的 alloc init 或 任何初始化操作
/// note : this Wrapper returns the same object , // 包裹者 返回同一个对象
/// note : absolute singleton // 绝对单例

+ (instancetype) new NS_UNAVAILABLE;
+ (instancetype) cc_shared ;

// begin with scheme , like "scheme://do sth" // 用一个 scheme 来初始化 , 比如 "scheme://do sth"
// note : only the first time have its effect (scheme can't be re-configured again) . // 只第一次使用有效 , scheme 不能被重新设置
+ (instancetype) cc_shared_with_scheme : (CCRouterRegistKey) sScheme ;

// regist // 注册
- (instancetype) cc_regist_fallback : (void (^)(CCRouterPatternInfo *dInfos)) fallBack ;
- (instancetype) cc_regist_operation : (CCRouterRegistKey) sURL
                              action : (void(^)(CCRouterPatternInfo *dInfos)) action ;
- (instancetype) cc_regist_object : (CCRouterRegistKey) sURL
                            value : (id(^)(CCRouterPatternInfo *dInfos)) value ;

// deregist // 取消注册
- (instancetype) cc_deregist : (CCRouterRegistKey) sURL ;

// open // 打开
- (BOOL) cc_is_can_open : (CCRouterRegistKey) sURL ;
- (instancetype) cc_call : (CCRouterPatternInfo *) dPattern
                fallback : (void(^)(CCRouterPatternInfo *dInfos)) fallback ;

- (id) cc_get : (CCRouterPatternInfo *) dPattern
     fallback : (void(^)(CCRouterPatternInfo *)) fallback ;

FOUNDATION_EXPORT CCRouterOperateKey const _CC_ROUTER_PARAMS_URL_;
FOUNDATION_EXPORT CCRouterOperateKey const _CC_ROUTER_PARAMS_COMPLETION_;
FOUNDATION_EXPORT CCRouterOperateKey const _CC_ROUTER_PARAMS_USER_INFO_;
FOUNDATION_EXPORT CCRouterOperateKey _CC_ROUTER_FALL_BACK_URL_ ; // can be customed by user with 'cc_sharedWithScheme:' methods // 可以被开发者使用 'cc_sharedWithScheme:' 来设置

CCRouterPatternInfo * CC_URL_PATTERN_MAKE(CCRouterRegistKey sURL ,
                                          NSDictionary *dUserInfo) ;

/// note : completion block only works with regist methods // 完成 block 只在 注册过的方法中有效
/// note : if uses in call method , completion will have no values . // 如果在回调中使用 , block 没有值 .
CCRouterPatternInfo * CC_URL_PATTERN_COMPLETION_MAKE(CCRouterRegistKey sURL ,
                                                     NSDictionary *dUserInfo ,
                                                     CCRouterCompletionBlock) ;

@end

#endif
