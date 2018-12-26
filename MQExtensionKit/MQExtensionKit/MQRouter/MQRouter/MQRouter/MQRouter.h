//
//  MQRouter.h
//  MQExtension_Example
//
//  Created by ElwinFrederick on 2018/12/21.
//  Copyright © 2018 ElwinFrederick. All rights reserved.
//

#import "MQRouterDefine.h"
#import <pthread.h>

/*
 if you wanna all assert worked only under debug environment , // 如果你想所有的断言只在 debug 环境下起效 ,
 do as following : // 做如下操作 :
 
 targets -> build -> release -> gcc preprocessing :
    then adding kvc as : // 然后 添加 kvc 键值对 :
        Preprocessor Macros (for key) , NS_BLOCK_ASSERTIONS (for value)
 */

/*
    if you wanna control the loading sequence of registration .
    then use the "__attribute__((constructor(...)))" instead of "+ (void) load" .
    note :
        "__attribute__((constructor(...)))" : you must fill in with interger value and have to over 100 . (0 ~ 100 was taken by system) .
 
    // 如果你想控制 注册 的顺序 .
    // 使用 "__attribute__((constructor(...)))" 而不是 "+ (void) load" .
    // 注意 :
    //      "__attribute__((constructor(...)))" : 你必须使用整型 , 且 大于 100 . (0 ~ 100 被系统占据) .
 */

NS_ASSUME_NONNULL_BEGIN

@interface MQRouterNodeInfo : NSMutableDictionary

@property (nonatomic , copy , readonly) NSString * previous_key_s ;
@property (nonatomic , copy , readonly) NSString * key_s ;
@property (nonatomic , copy , readonly) NSString * original_path_s ;
@property (nonatomic , assign , readonly) BOOL mark_as_start ;
@property (nonatomic , assign , readonly) BOOL is_reach_bottom ;

/// 因为是路径注册 , 所以存在几个节点 , 注册 sequence 都是相同的情况
@property (nonatomic , assign , readonly) NSUInteger regist_sequence_i ;

/// return : @"action" || @"object"
@property (nonatomic , copy , readonly) NSString * regist_type_s ;

@end

#pragma mark - ----- ###########################################################

@class MQRouter ;

@protocol MQRouterDelegate <NSObject>

@optional
- (void) mq_router : (MQRouter *) router
did_begin_searching : (MQRouterRegistKey) regist_key
      pattern_info : (MQRouterPatternInfo) pattern_info ;

- (void) mq_router : (MQRouter *) router
did_begin_excuting : (MQRouterRegistKey) regist_key
         user_info : (MQRouterPatternInfo) user_info ;

- (void) mq_router : (MQRouter *) router
 excuting_complete : (MQRouterRegistKey) regist_key
         user_info : (MQRouterPatternInfo) user_info
            result : (id) result;

- (void) mq_router : (MQRouter *) router
     excuting_fail : (MQRouterRegistKey) regist_key
         user_info : (MQRouterPatternInfo) user_info
             error : (MQRouterError) error ;

- (void) mq_router : (MQRouter *) router
did_deregist_scheme : (NSString *) scheme ;

- (void) mq_router : (MQRouter *) router
 did_deregist_path : (MQRouterRegistKey) path ;

- (void) mq_router_deregist_all_complete : (MQRouter *) router ;

@end

FOUNDATION_EXPORT NSString * MQ_ROUTER_DEFAULT_SCHEME ;

@interface MQRouter : NSObject

+ (instancetype) mq_shared ;
+ (instancetype) mq_shared_by_default : (nullable NSString *) scheme ;

- (instancetype) init NS_UNAVAILABLE ;
+ (instancetype) new NS_UNAVAILABLE ;

+ (void) mq_add_delegate : (id <MQRouterDelegate>) delegate_t ;
+ (void) mq_remove_delegate : (id <MQRouterDelegate>) delegate_t ;

@property (nonatomic , class , readonly) NSString * default_scheme ;
@property (nonatomic , class , readonly) NSHashTable *ht_all_delegates ;
@property (nonatomic , class , readonly) NSMutableDictionary <NSString * , NSMutableDictionary *> *router_map ;

+ (BOOL) mq_can_open : (MQRouterPath) path ; // default match is YES .
+ (BOOL) mq_can_open : (MQRouterPath) path
               match : (BOOL) is_match ;

+ (void) mq_deregist_for_scheme : (NSString *) s_scheme ;
+ (void) mq_deregist : (MQRouterPath) path ;
+ (void) mq_deregist_all ;

+ (NSArray <NSString *> *) mq_registed_schemes ;
+ (NSArray <MQRouterPath> *) mq_registed_paths_for_scheme : (NSString *) scheme ;

- (void) mq_node_console_log_with_detail : (BOOL) is_need ;
+ (NSArray <MQRouterNodeInfo *> *) mq_registed_nodes_for_scheme : (NSString *) scheme ;

+ (void) mq_regist_action : (MQRouterPath) path
                  handler : (MQRouterRegistActionHandler) handler ;
+ (void) mq_regist_action : (MQRouterPath) path
                 required : (nullable NSArray <NSString *> *) required_params
                  handler : (MQRouterRegistActionHandler) handler ;
+ (void) mq_regist_object : (MQRouterPath) path
                  handler : (MQRouterRegistObjectHandler) handler ;
+ (void) mq_regist_object : (MQRouterPath) path
                 required : (nullable NSArray <NSString *> *) required_params
                  handler : (MQRouterRegistObjectHandler) handler ;

MQRouterPath mq_router_make(MQRouterPath path) ;
MQRouterPath mq_router_make_scheme( NSString * _Nullable scheme, MQRouterPath path) ;

+ (void) mq_call : (MQRouterPath) path ;
+ (void) mq_call : (MQRouterPath) path
       user_info : (nullable NSDictionary <NSString * , id> *) user_info
      completion : (nullable MQRouterCompletionBlock) completion ;
+ (void) mq_call : (MQRouterPath) path
       user_info : (nullable NSDictionary <NSString * , id> *) user_info
      completion : (nullable MQRouterCompletionBlock) completion
           error : (nullable MQRouterErrorBlock) error_block ;

+ (id) mq_fetch : (MQRouterPath) path ;
+ (id) mq_fetch : (MQRouterPath) path
      user_info : (nullable NSDictionary <NSString * , id> *) user_info
     completion : (nullable MQRouterCompletionBlock) completion ;
+ (id) mq_fetch : (MQRouterPath) path
      user_info : (nullable NSDictionary <NSString * , id> *) user_info
     completion : (nullable MQRouterCompletionBlock) completion
          error : (nullable MQRouterErrorBlock) error_block ;

@end

NS_ASSUME_NONNULL_END
