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
+ (instancetype) mq_shared_with_scheme : (MQRouterRegistKey) sScheme ;

// regist // 注册
- (instancetype) mq_regist_fallback : (void (^)(MQRouterPatternInfo *dInfos)) fallBack ;
- (instancetype) mq_regist_operation : (MQRouterRegistKey) sURL
                              action : (void(^)(MQRouterPatternInfo *dInfos)) action ;
- (instancetype) mq_regist_object : (MQRouterRegistKey) sURL
                            value : (id(^)(MQRouterPatternInfo *dInfos)) value ;

// deregist // 取消注册
- (instancetype) mq_deregist : (MQRouterRegistKey) sURL ;

// open // 打开
- (BOOL) mq_is_can_open : (MQRouterRegistKey) sURL ;
- (instancetype) mq_call : (MQRouterPatternInfo *) dPattern
                fallback : (void(^)(MQRouterPatternInfo *dInfos)) fallback ;

- (id) mq_get : (MQRouterPatternInfo *) dPattern
     fallback : (void(^)(MQRouterPatternInfo *)) fallback ;

FOUNDATION_EXPORT MQRouterOperateKey const _MQ_ROUTER_PARAMS_URL_;
FOUNDATION_EXPORT MQRouterOperateKey const _MQ_ROUTER_PARAMS_COMPLETION_;
FOUNDATION_EXPORT MQRouterOperateKey const _MQ_ROUTER_PARAMS_USER_INFO_;
FOUNDATION_EXPORT MQRouterOperateKey _MQ_ROUTER_FALL_BACK_URL_ ; // can be customed by user with 'mq_sharedWithScheme:' methods // 可以被开发者使用 'mq_sharedWithScheme:' 来设置

MQRouterPatternInfo * MQ_URL_MAKE(MQRouterRegistKey sURL) ;
MQRouterPatternInfo * MQ_URL_PATTERN_MAKE(MQRouterRegistKey sURL ,
                                          NSDictionary *dUserInfo) ;

/// note : completion block only works with regist methods // 完成 block 只在 注册过的方法中有效
/// note : if uses in call method , completion will have no values . // 如果在回调中使用 , block 没有值 .
MQRouterPatternInfo * MQ_URL_PATTERN_COMPLETION_MAKE(MQRouterRegistKey sURL ,
                                                     NSDictionary *dUserInfo ,
                                                     MQRouterCompletionBlock) ;

@end

#endif
