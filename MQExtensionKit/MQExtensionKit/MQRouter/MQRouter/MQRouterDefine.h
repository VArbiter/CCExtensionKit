//
//  MQRouterDefine.h
//  MQExtension_Example
//
//  Created by ElwinFrederick on 2018/12/21.
//  Copyright © 2018 ElwinFrederick. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSString *MQRouterOperateKey NS_EXTENSIBLE_STRING_ENUM;
typedef NSString *MQRouterRegistKey NS_EXTENSIBLE_STRING_ENUM;
typedef NSString *MQRouterPath NS_EXTENSIBLE_STRING_ENUM;
typedef NSDictionary *MQRouterPatternInfo NS_EXTENSIBLE_STRING_ENUM;
typedef NSError *MQRouterError NS_EXTENSIBLE_STRING_ENUM;
typedef void (^MQRouterRegistActionHandler)(NSDictionary *user_info);
typedef id (^MQRouterRegistObjectHandler)(NSDictionary *user_info);
typedef void (^MQRouterCompletionBlock)(id result);
typedef void (^MQRouterErrorBlock)(NSString * scheme , MQRouterRegistKey key , MQRouterPatternInfo user_info);

FOUNDATION_EXPORT MQRouterOperateKey const mq_router_params_url ;
FOUNDATION_EXPORT MQRouterOperateKey const mq_router_params_completion;
FOUNDATION_EXPORT MQRouterOperateKey const mq_router_params_userinfo;

//NS_ASSUME_NONNULL_BEGIN

//@interface MQRouterDefine : NSObject

//@end

//NS_ASSUME_NONNULL_END
