//
//  MQBridgeWrapper.h
//  MQExtensionKit
//
//  Created by Elwinfrederick on 14/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

#if __has_include(<MGJRouter/MGJRouter.h>)

typedef NSString *MQRouterOperateKey NS_EXTENSIBLE_STRING_ENUM;
typedef NSString *MQRouterRegistKey NS_EXTENSIBLE_STRING_ENUM;
typedef NSDictionary MQRouterPatternInfo;
typedef void (^MQRouterCompletionBlock)(id result);

#ifndef MQ_ROUTER_W
    #define MQ_ROUTER_W MQBridgeWrapper.mq_shared
#endif

@import MGJRouter;

@interface MQBridgeWrapper : NSObject

/// note : what ever you use the 'alloc init' or some intial method , // 所有的 alloc init 或 任何初始化操作
/// note : this Wrapper returns the same object , // 包裹者 返回同一个对象
/// note : absolute singleton // 绝对单例

+ (instancetype) new NS_UNAVAILABLE;
+ (instancetype) mq_shared ;

// begin with scheme , like "scheme://do sth" // 用一个 scheme 来初始化 , 比如 "scheme://do sth"
// note : only the first time have its effect (scheme can't be re-configured again) . // 只第一次使用有效 , scheme 不能被重新设置
+ (instancetype) mq_shared_with_scheme : (MQRouterRegistKey) s_scheme ;

// regist // 注册
- (instancetype) mq_regist_fallback : (void (^)(MQRouterPatternInfo *dInfos)) fallback ;
- (instancetype) mq_regist_operation : (MQRouterRegistKey) s_url
                              action : (void(^)(MQRouterPatternInfo *dInfos)) action ;
- (instancetype) mq_regist_object : (MQRouterRegistKey) s_url
                            value : (id(^)(MQRouterPatternInfo *d_infos)) value ;

// deregist // 取消注册
- (instancetype) mq_deregist : (MQRouterRegistKey) s_url ;

// open // 打开
- (BOOL) mq_is_can_open : (MQRouterRegistKey) s_url ;
- (instancetype) mq_call : (MQRouterPatternInfo *) d_pattern
                fallback : (void(^)(MQRouterPatternInfo *d_infos)) fallback ;

- (id) mq_get : (MQRouterPatternInfo *) d_pattern
     fallback : (void(^)(MQRouterPatternInfo *)) fallback ;

FOUNDATION_EXPORT MQRouterOperateKey const mq_router_params_url ;
FOUNDATION_EXPORT MQRouterOperateKey const mq_router_params_completion;
FOUNDATION_EXPORT MQRouterOperateKey const mq_router_params_userinfo;
FOUNDATION_EXPORT MQRouterOperateKey mq_router_fallback_url ; // can be customed by user with 'mq_sharedWithScheme:' methods // 可以被开发者使用 'mq_sharedWithScheme:' 来设置

MQRouterPatternInfo * mq_router_url_make(MQRouterRegistKey s_url) ;
MQRouterPatternInfo * mq_router_url_pattern_make(MQRouterRegistKey s_url ,
                                                 NSDictionary *d_user_info) ;

/// note : completion block only works with regist methods // 完成 block 只在 注册过的方法中有效
/// note : if uses in call method , completion will have no values . // 如果在回调中使用 , block 没有值 .
MQRouterPatternInfo * mq_router_url_pattern_completion_make(MQRouterRegistKey s_url ,
                                                            NSDictionary *d_user_info ,
                                                            MQRouterCompletionBlock) ;

@end

#endif
