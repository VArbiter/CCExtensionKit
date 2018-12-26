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
/**
 if nil , then this node is the first path pattern . (expect scheme) .
 // 如果为空 , 这个节点就是第一个路径 . (除去 scheme)
 */
@property (nonatomic , copy , readonly) NSString * previous_key_s ;

/// current node . // 当前节点
@property (nonatomic , copy , readonly) NSString * key_s ;

/// node with full path . // 当前节点所在完整路径
@property (nonatomic , copy , readonly) NSString * original_path_s ;

/// decide node is the regist one (may not be the last node) . // 决定 路径是否是注册的那个 (可能不是最后的 节点 )
@property (nonatomic , assign , readonly) BOOL mark_as_start ;

/// decide if node is the last node of a subtree (mark_as_start == YES) . // 决定 节点 是否是子树 的最后一个节点 . (mark_as_start == YES)
@property (nonatomic , assign , readonly) BOOL is_reach_bottom ;

/**
 the sequence the path being registed . // 路径被注册的顺序
 all the path was filled the map as nodes . thus some nodes would have the same seq .
 // 因为 路径 最后都作为 节点填充到了 map 中 , 所以 存在几个节点 , 注册 sequence 都是相同的情况
 */
@property (nonatomic , assign , readonly) NSUInteger regist_sequence_i ;

/**
 the type that path being registed . return : @"action" || @"object"
 // 路径被注册的类型 , 返回 : @"action" || @"object"
 */
@property (nonatomic , copy , readonly) NSString * regist_type_s ;

@end

#pragma mark - ----- ###########################################################

@class MQRouter ;

@protocol MQRouterDelegate <NSObject>

@optional

/**
 the path did begin searching . // 路径开始搜索

 @param router router // 路由
 @param regist_key path // 路径
 @param pattern_info params that parse the path // 解析 路径 得到的参数
 */
- (void) mq_router : (MQRouter *) router
did_begin_searching : (MQRouterPath) regist_key
      pattern_info : (MQRouterPatternInfo) pattern_info ;

/**
 the path did begin excuting . // 路径开始执行

 @param router router // 路由
 @param regist_key path // 路径
 @param user_info developer defined params // 开发者定义的参数
 */
- (void) mq_router : (MQRouter *) router
did_begin_excuting : (MQRouterPath) regist_key
         user_info : (MQRouterPatternInfo) user_info ;

/**
 the path excuting complete . // 路径执行完毕

 @param router router // 路由
 @param regist_key path // 路径
 @param user_info developer defined params // 开发者定义的参数
 @param result result by excuting // 执行得到的结果
 */
- (void) mq_router : (MQRouter *) router
 excuting_complete : (MQRouterPath) regist_key
         user_info : (MQRouterPatternInfo) user_info
            result : (id) result;

/**
 the path excuting error . // 路径执行出现错误

 @param router router // 路由
 @param regist_key path // 路径
 @param user_info developer defined params // 开发者定义的参数
 @param error error info // 错误信息
 */
- (void) mq_router : (MQRouter *) router
     excuting_fail : (MQRouterPath) regist_key
         user_info : (MQRouterPatternInfo) user_info
             error : (MQRouterError) error ;

/**
 the scheme did being unregisted . // 被取消注册 的 scheme

 @param router router // 路由
 @param scheme scheme
 */
- (void) mq_router : (MQRouter *) router
did_unregist_scheme : (NSString *) scheme ;

/**
 the path did being unregisted . // 被取消注册 的 路径

 @param router router // 路由
 @param path path // 路径
 */
- (void) mq_router : (MQRouter *) router
 did_unregist_path : (MQRouterPath) path ;

/// unregist all paths in map . // 取消所有 在 map 已注册的路径
- (void) mq_router_unregist_all_complete : (MQRouter *) router ;

@end

FOUNDATION_EXPORT NSString * MQ_ROUTER_DEFAULT_SCHEME ;

@interface MQRouter : NSObject

/// absolute singleton . // 绝对单例
+ (instancetype) mq_shared ;

/**
 absolute singleton . // 绝对单例

 @param scheme developer defined default scheme . // 开发者自定义的默认 scheme
 @return absolute singleton // 绝对单例
 */
+ (instancetype) mq_shared_by_default : (nullable NSString *) scheme ;

- (instancetype) init NS_UNAVAILABLE ;
+ (instancetype) new NS_UNAVAILABLE ;

/**
 can add multi delegate . and all available . // 添加多个代理 , 全部生效
 using [NSHashTable weakObjectsHashTable] as container of all delegates . // 使用 [NSHashTable weakObjectsHashTable] 作为所有代理的容器 .
 */
+ (void) mq_add_delegate : (id <MQRouterDelegate>) delegate_t ;
+ (void) mq_remove_delegate : (id <MQRouterDelegate>) delegate_t ;

/// default scheme . // 默认 scheme
@property (nonatomic , class , readonly) NSString * default_scheme ;
/// all delegates (change with objects changed) . // 所有代理 (随元素变化而变化)
@property (nonatomic , class , readonly) NSHashTable *ht_all_delegates ;
/// all registed infos . // 所有已注册的信息
@property (nonatomic , class , readonly) NSMutableDictionary <NSString * , NSMutableDictionary *> *router_map ;

/// search if a path is being registed . // 搜索 是否有路径被注册
+ (BOOL) mq_can_open : (MQRouterPath) path ; // default match is YES .
/**
 search if a path is being registed . // 搜索 是否有路径被注册

 @param path path // 路径
 @param is_match if YES . the path that will be found must be exactly the same with the given one . if NO , the path that will be found only have to be interested by given one . // 如果 YES , 这个 将要被查找的路径 必须完全 和 给出的一致 , 如果 NO , 将要被查找的路径 只需要对 给出的路径 感兴趣 (相似路由 , 一般存在于之前的节点中) 即可 .
 @return if find . // 是否找到
 */
+ (BOOL) mq_can_open : (MQRouterPath) path
               match : (BOOL) is_match ;

/// unregist a scheme . // 取消注册 一个 scheme
+ (void) mq_unregist_for_scheme : (NSString *) s_scheme ;
/// unregist a path . // 取消注册 一个 路径
+ (void) mq_unregist : (MQRouterPath) path ;
/// unregist all (make map re-generate as blank one) . // 取消注册所有 , 使得 map 新生成并置空
+ (void) mq_unregist_all ;

/// return all schemes that being registed . // 返回已经注册的所有 scheme .
+ (NSArray <NSString *> *) mq_registed_schemes ;
/// return all paths that being registed under a specific scheme . // 返回所有在 特定 scheme 下注册的路径
+ (NSArray <MQRouterPath> *) mq_registed_paths_for_scheme : (NSString *) scheme ;

/// make NSLog(node_info) show the detail or not . // 决定是否 NSLog(node_info) 时显示详细信息
- (void) mq_node_console_log_with_detail : (BOOL) is_need ;
/// return all node that generate under a specific scheme . // 返回为 特定的 scheme 生成的节点信息
+ (NSArray <MQRouterNodeInfo *> *) mq_registed_nodes_for_scheme : (NSString *) scheme ;

/**
 action registed method (has no return value) . // 动作 注册方法 . (无返回值)

 @param path path // 路径 . use "mq_router_make" or "mq_router_make_scheme" to make one
 @param handler action handler . // 动作
 */
+ (void) mq_regist_action : (MQRouterPath) path
                  handler : (MQRouterRegistActionHandler) handler ;

/**
 action registed method (has no return value) . // 动作 注册方法 . (无返回值)

 @param path path // 路径 . use "mq_router_make" or "mq_router_make_scheme" to make one
 @param required_params params that must have in path . // 路径中必须携带的参数
 @param handler action handler . // 动作
 */
+ (void) mq_regist_action : (MQRouterPath) path
                 required : (nullable NSArray <NSString *> *) required_params
                  handler : (MQRouterRegistActionHandler) handler ;


/**
 object registed method (has return value) . // 对象 注册方法 . (有返回值)

 @param path path // 路径 . use "mq_router_make" or "mq_router_make_scheme" to make one
 @param handler object handler . // 动作
 */
+ (void) mq_regist_object : (MQRouterPath) path
                  handler : (MQRouterRegistObjectHandler) handler ;

/**
 object registed method (has return value) . // 对象 注册方法 . (有返回值)

 @param path path // 路径 . use "mq_router_make" or "mq_router_make_scheme" to make one
 @param required_params params that must have in path . // 路径中必须携带的参数
 @param handler object handler . // 动作
 */
+ (void) mq_regist_object : (MQRouterPath) path
                 required : (nullable NSArray <NSString *> *) required_params
                  handler : (MQRouterRegistObjectHandler) handler ;


/**
  generate a path . // 生成 一个路径

 @param path path // 路径
 @return path that generated . // 生成的路径
 */
MQRouterPath mq_router_make(MQRouterPath path) ;

/**
 generate a path with a custom scheme . // 生成一个 自定义 scheme 的路径 ,

 @param scheme custom scheme . // 自定义路径
 @param path path // 路径
 @return path that generated . // 生成的路径
 */
MQRouterPath mq_router_make_scheme( NSString * _Nullable scheme, MQRouterPath path) ;

/// find and run a path . // 运行一个 路径
+ (void) mq_call : (MQRouterPath) path ;

/**
 find and run a path . // 运行一个 路径

 @param path path , if registed one have the required params , this path must have . // 路径 如果注册路径有必须传入的参数 , 那么这里必须带着
 @param user_info developer defined params , not the required one . // 开发者自定义参数 , 非要求 .
 @param completion recall when complete . // 执行完成后回调 .
 */
+ (void) mq_call : (MQRouterPath) path
       user_info : (nullable NSDictionary <NSString * , id> *) user_info
      completion : (nullable MQRouterCompletionBlock) completion ;

/**
 find and run a path . // 运行一个 路径
 
 @param path path , if registed one have the required params , this path must have . // 路径 如果注册路径有必须传入的参数 , 那么这里必须带着
 @param user_info developer defined params , not the required one . // 开发者自定义参数 , 非要求 .
 @param completion recall when complete . // 执行完成后回调 .
 @param error_block recall when sth goes wrong . // 错误出现的时候回调 .
 */
+ (void) mq_call : (MQRouterPath) path
       user_info : (nullable NSDictionary <NSString * , id> *) user_info
      completion : (nullable MQRouterCompletionBlock) completion
           error : (nullable MQRouterErrorBlock) error_block ;

/// find , run a path , and get the result . // 运行一个 路径 , 并获得结果
+ (id) mq_fetch : (MQRouterPath) path ;

/**
 find , run a path , and get the result . // 运行一个 路径 , 并获得结果

 @param path path , if registed one have the required params , this path must have . // 路径 如果注册路径有必须传入的参数 , 那么这里必须带着
 @param user_info developer defined params , not the required one . // 开发者自定义参数 , 非要求 .
 @param completion recall when complete . // 执行完成后回调 .
 @return the result . // 执行结果
 */
+ (id) mq_fetch : (MQRouterPath) path
      user_info : (nullable NSDictionary <NSString * , id> *) user_info
     completion : (nullable MQRouterCompletionBlock) completion ;

/**
 find , run a path , and get the result . // 运行一个 路径 , 并获得结果
 
 @param path path , if registed one have the required params , this path must have . // 路径 如果注册路径有必须传入的参数 , 那么这里必须带着
 @param user_info developer defined params , not the required one . // 开发者自定义参数 , 非要求 .
 @param completion recall when complete . // 执行完成后回调 .
 @param error_block recall when sth goes wrong . // 错误出现的时候回调 .
 @return the result . // 执行结果
 */
+ (id) mq_fetch : (MQRouterPath) path
      user_info : (nullable NSDictionary <NSString * , id> *) user_info
     completion : (nullable MQRouterCompletionBlock) completion
          error : (nullable MQRouterErrorBlock) error_block ;

@end

NS_ASSUME_NONNULL_END
