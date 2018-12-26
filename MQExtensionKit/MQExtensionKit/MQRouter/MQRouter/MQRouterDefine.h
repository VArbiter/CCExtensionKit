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
typedef void (^MQRouterRegistActionHandler)(NSDictionary *action_info);
typedef id (^MQRouterRegistObjectHandler)(NSDictionary *object_info);
typedef void (^MQRouterCompletionBlock)(id result);
typedef void (^MQRouterErrorBlock)(MQRouterRegistKey key , MQRouterPatternInfo user_info);

FOUNDATION_EXPORT MQRouterOperateKey const mq_router_params_url ;
FOUNDATION_EXPORT MQRouterOperateKey const mq_router_params_completion;
FOUNDATION_EXPORT MQRouterOperateKey const mq_router_params_userinfo;
FOUNDATION_EXPORT MQRouterOperateKey const mq_router_wildcard_character;
FOUNDATION_EXPORT MQRouterOperateKey const mq_router_special_character;

FOUNDATION_EXPORT MQRouterOperateKey const mq_router_get_result_key;
FOUNDATION_EXPORT MQRouterOperateKey const mq_router_get_params_key;
FOUNDATION_EXPORT MQRouterOperateKey const mq_router_operate_block_holder;
FOUNDATION_EXPORT MQRouterOperateKey const mq_router_operate_block_key;
FOUNDATION_EXPORT MQRouterOperateKey const mq_router_operate_defined_type_key;
FOUNDATION_EXPORT MQRouterOperateKey const mq_router_required_params_key;
FOUNDATION_EXPORT MQRouterOperateKey const mq_router_original_path_key;

FOUNDATION_EXPORT MQRouterOperateKey const mq_router_regist_type_action_key;
FOUNDATION_EXPORT MQRouterOperateKey const mq_router_regist_type_object_key;
FOUNDATION_EXPORT MQRouterOperateKey const mq_router_regist_sequence_key;

//NS_ASSUME_NONNULL_BEGIN

//@interface MQRouterDefine : NSObject

//@end

//NS_ASSUME_NONNULL_END
