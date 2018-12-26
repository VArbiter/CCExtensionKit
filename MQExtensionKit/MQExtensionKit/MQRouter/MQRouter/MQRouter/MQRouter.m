//
//  MQRouter.m
//  MQExtension_Example
//
//  Created by ElwinFrederick on 2018/12/21.
//  Copyright © 2018 ElwinFrederick. All rights reserved.
//

#import "MQRouter.h"

@interface MQRouterNodeInfo ()

@property (nonatomic , copy , readwrite) NSString * previous_key_s ;
@property (nonatomic , copy , readwrite) NSString * key_s ;
@property (nonatomic , copy , readwrite) NSString * original_path_s ;
@property (nonatomic , assign , readwrite) BOOL mark_as_start ;
@property (nonatomic , assign , readwrite) BOOL is_reach_bottom ;
@property (nonatomic , copy , readwrite) NSString * regist_type_s ;
@property (nonatomic , assign , readwrite) NSUInteger regist_sequence_i ;

@property (nonatomic , strong) NSMutableDictionary *dict ;

- (instancetype) init_router_info ;

@property (nonatomic , class) BOOL is_need_detail ;

@end

@implementation MQRouterNodeInfo

- (instancetype)init_router_info {
    if ((self = [super init])) {
        self.dict = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)addEntriesFromDictionary:(NSDictionary *)otherDictionary {
    if ([otherDictionary isKindOfClass:[MQRouterNodeInfo class]]) {
        [self.dict addEntriesFromDictionary:((MQRouterNodeInfo *)otherDictionary).dict];
    }
    else if ([otherDictionary isKindOfClass:[NSMutableDictionary class]]) {
        [self.dict addEntriesFromDictionary:otherDictionary];
    }
#if DEBUG
    else {
        NSAssert(false, @"add entries get params with wrong format .");
    }
#endif
}

- (id)valueForKey:(NSString *)key {
    return [self.dict valueForKey:key];
}
- (id)valueForKeyPath:(NSString *)keyPath {
    return [self.dict valueForKeyPath:keyPath];
}

- (void)removeObjectForKey:(id)aKey {
    [self.dict removeObjectForKey:aKey];
}

- (NSUInteger)count {
    return self.dict.count;
}
- (NSArray *)allKeys {
    return self.dict.allKeys;
}
- (NSArray *)allValues {
    return self.dict.allValues;
}
- (id)mutableCopy {
    return [self.dict mutableCopy];
}
- (id)copy {
    return [self.dict mutableCopy]; // make sure its mutable .
}

static BOOL __mq_router_node_info_console_log_detail_enable = false;
+ (void)setIs_need_detail:(BOOL)is_need_detail {
    __mq_router_node_info_console_log_detail_enable = is_need_detail;
}
+ (BOOL)is_need_detail {
    return __mq_router_node_info_console_log_detail_enable;
}

- (NSString *)description {
    if (__mq_router_node_info_console_log_detail_enable) {
        return [self debugDescription];
    }
    else return [NSString stringWithFormat:@"\n previous_key : %@ \n key : %@ \n start_node: %d \n reach_bottom : %d \n" , self.previous_key_s , self.key_s , self.mark_as_start , self.is_reach_bottom];
}
- (NSString *)debugDescription {
    return [NSString stringWithFormat:@"\n previous_key : %@ \n key : %@ \n start_node: %d \n reach_bottom : %d \n original_path : %@ \n regist_type : %@ \n regist_seq : %lu \n %@" , self.previous_key_s , self.key_s , self.mark_as_start , self.is_reach_bottom , self.original_path_s , self.regist_type_s , ((unsigned long)self.regist_sequence_i) , self.dict];
}

@end

#pragma mark - ----- ###########################################################

@interface MQRouter (MQExtension_Assist)

+ (MQRouterRegistKey) mq_path_encoded : (MQRouterRegistKey) key ;
+ (MQRouterRegistKey) mq_path_decoded : (MQRouterRegistKey) key ;

+ (NSArray <NSString *> *) mq_path_components : (MQRouterPath) path ;

+ (BOOL) mq_is_array_valued : (__kindof NSArray *) array ;
+ (BOOL) mq_is_string_valued : (__kindof NSString *) string ;

+ (BOOL) mq_is_contain_special_character : (NSString *) s_path ;

+ (BOOL) mq_check_params : (NSDictionary <NSString * , id> *) dict_params
       contains_required : (NSArray <NSString *> *) array_params
                hint_sel : (SEL) selector
                    path : (MQRouterPath) path
               user_info : (id) user_info
                   error : (MQRouterErrorBlock) error_block ;

+ (NSArray <NSString *> *) mq_all_paths_for_scheme : (NSString *) scheme
                                        router_map : (NSDictionary *) router_map ;
+ (NSArray <MQRouterNodeInfo *> *) mq_nodes_for_scheme : (NSString *) scheme
                                            router_map : (NSDictionary *) router_map ;
+ (void) mq_deep_search : (NSMutableDictionary *) dict
          previous_node : (NSString *) s_key
              searching : (void (^)(MQRouterNodeInfo * node_info)) block_searching ;

@end

@implementation MQRouter (MQExtension_Assist)

+ (MQRouterRegistKey) mq_path_encoded : (MQRouterRegistKey) key {
    NSString *s_characters = @"#%^{}[]|\"<> ";
#ifdef __IPHONE_9_0
    NSCharacterSet *s_allowed_characters = [[NSCharacterSet characterSetWithCharactersInString:s_characters] invertedSet];
    return [key stringByAddingPercentEncodingWithAllowedCharacters:s_allowed_characters];
#else
    return (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)key,
                                                              NULL,
                                                              (CFStringRef)s_characters,
                                                              kCFStringEncodingUTF8));
#endif
}
+ (MQRouterRegistKey) mq_path_decoded : (MQRouterRegistKey) key {
#ifdef __IPHONE_7_0
    return [key stringByRemovingPercentEncoding];
#else
    return (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                 (__bridge CFStringRef)key,
                                                                                                 CFSTR(""),
                                                                                                 CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
#endif
}

+ (NSArray <NSString *> *) mq_path_components : (MQRouterPath) path {
    
    if (![MQRouter mq_is_string_valued:path]) return nil;
    
    NSMutableArray<NSString *> *array_results = [NSMutableArray array];
    if ([path rangeOfString:@"://"].location != NSNotFound) {
        NSArray<NSString *> *array_components = [path componentsSeparatedByString:@"://"];
        
        [array_results addObject:array_components.firstObject];
        path = array_components.lastObject;
        if (!path || !path.length) {
            [array_results addObject:mq_router_wildcard_character];
        }
    }
    
    for (NSString *temp_component in [[NSURL URLWithString:path] pathComponents]) {
        if ([temp_component isEqualToString:@"/"]) continue;
        if ([[temp_component substringToIndex:1] isEqualToString:@"?"]) break;
        [array_results addObject:temp_component];
    }
    
    return array_results ;
}

+ (BOOL) mq_is_array_valued : (__kindof NSArray *) array {
    if (array) {
        if ([array isKindOfClass:[NSArray class]]) {
            if (array.count) {
                return YES;
            }
        }
    }
    return false;
}
+ (BOOL) mq_is_string_valued : (__kindof NSString *) string {
    if (string) {
        if ([string isKindOfClass:[NSString class]]) {
            if (string.length
                && ![string isEqualToString:@"(null)"]
                && ![string isEqualToString:@"null"]
                && ![string isEqualToString:@"<null>"]
                && ![string isKindOfClass:NSNull.class]) {
                return YES;
            }
        }
    }
    return false;
}

+ (BOOL) mq_is_contain_special_character : (NSString *) s_path {
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:mq_router_special_character];
    return [s_path rangeOfCharacterFromSet:set].location != NSNotFound;
}

+ (BOOL) mq_check_params : (NSDictionary <NSString * , id> *) dict_params
       contains_required : (NSArray <NSString *> *) array_params
                hint_sel : (SEL) selector
                    path : (MQRouterPath) path
               user_info : (id) user_info
                   error : (MQRouterErrorBlock) error_block {
    
    if (!array_params || !array_params.count) return YES;
    
    NSArray <NSString *> * array_all_keys = [dict_params allKeys];
    
    NSSet *set = [NSSet setWithArray:array_all_keys];
    NSSet *set_sub = [NSSet setWithArray:array_params];
    
    if ([set_sub isSubsetOfSet:set]) {
        return YES;
    }
    
#if DEBUG
    NSString *s = [NSString stringWithFormat:@"\n%@ \n%@ \n%@",NSStringFromSelector(selector),path,@"need fullfill the required params."];
    NSAssert(false, s);
#endif
    
    if (error_block) error_block(path , user_info);
    return false;
}

+ (NSArray <NSString *> *) mq_all_paths_for_scheme : (NSString *) scheme
                                        router_map : (NSDictionary *) router_map {
    NSArray <MQRouterNodeInfo *> *array_nodes = [MQRouter mq_nodes_for_scheme:scheme
                                                                   router_map:router_map];
    if (!array_nodes || !array_nodes.count) return nil;
    
    NSMutableArray <NSString *> *array_schemes = nil;
    @autoreleasepool {
        array_schemes = [NSMutableArray array];
        [array_nodes enumerateObjectsUsingBlock:^(MQRouterNodeInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSString *s = [NSString stringWithFormat:@"( %@ ) %@" , obj.regist_type_s , obj.original_path_s];
            if (s) [array_schemes addObject:s];
        }];
    }
    
    return [array_schemes copy];
}

+ (NSArray <MQRouterNodeInfo *> *) mq_nodes_for_scheme : (NSString *) scheme
                                            router_map : (NSDictionary *) router_map {
    NSMutableDictionary <NSString * , id> * dict_root = [[router_map valueForKey:scheme] mutableCopy];
    if (!dict_root || !dict_root.allKeys.count) return nil;
    
    /*
     1. 实质为 多叉树 的遍历
     2. 在 MGJRouter && HHRouter 中 , 虽然为多叉树的构造 (字典模仿多叉树) ,
     但是并没有 回溯索引 , 即为指向上一个节点的 key || pointer 这一概念
     3. 以至于 , 获得索引时 , 需要 先序遍历 所有的 node , 然后构建 回溯索引 .
     4. 最后完成路径的重构造
     
     note : 不知道怎么用英语说这些 , 不翻译了 ...
     */
    
    NSMutableArray <MQRouterNodeInfo *> *array_nodes = nil;
    @autoreleasepool {
        array_nodes = [NSMutableArray array];
        // 构建 索引 , 存储 之前的 key , 也就是 previous node
        [MQRouter mq_deep_search:dict_root previous_node:nil searching:^(MQRouterNodeInfo *node_info) {
            [array_nodes addObject:node_info];
        }];
    }
    
    return [array_nodes copy];
}

+ (void) mq_deep_search : (NSMutableDictionary *) dict
          previous_node : (NSString *) s_key
              searching : (void (^)(MQRouterNodeInfo * node_info)) block_searching {
    MQRouterNodeInfo *(^filter_block)(NSMutableDictionary *) = ^MQRouterNodeInfo *(NSMutableDictionary *dict) {
        
        [dict removeObjectForKey:mq_router_operate_block_holder];
        [dict removeObjectForKey:mq_router_required_params_key];
        [dict removeObjectForKey:mq_router_operate_block_key];
        [dict removeObjectForKey:mq_router_operate_defined_type_key];
        [dict removeObjectForKey:mq_router_original_path_key];
        [dict removeObjectForKey:mq_router_regist_sequence_key];
        
        MQRouterNodeInfo *info = [[MQRouterNodeInfo alloc] init_router_info];
        [info addEntriesFromDictionary:dict];
        return info;
    };
    
    // if find the block stored with key of "_" // 如果 某个 node 存在 "_" 的 block ,
    // then it means its registed as a complete path .// 则 表示它是被单独注册上的 完整路径 .
    MQRouterNodeInfo *dict_temp = filter_block(dict);
    
    for (NSString * s_key_temp in dict_temp.allKeys) {

        BOOL is_final = false;
        
        id t_value = [dict_temp valueForKey:s_key_temp];
        BOOL is_regist_as_start = !![t_value valueForKey:mq_router_operate_block_holder] ;
        NSString * s_original_path = [t_value valueForKey:mq_router_original_path_key];
        NSInteger i_type = [[t_value valueForKey:mq_router_operate_defined_type_key] integerValue];
        NSUInteger i_seq = [[t_value valueForKey:mq_router_regist_sequence_key] unsignedIntegerValue];
        MQRouterNodeInfo *d_temp = filter_block([[dict_temp valueForKey:s_key_temp] mutableCopy]);
        d_temp.previous_key_s = s_key;
        d_temp.key_s = s_key_temp;
        d_temp.mark_as_start = is_regist_as_start;
        d_temp.original_path_s = s_original_path;
        d_temp.regist_sequence_i = i_seq;
        
        d_temp.regist_type_s = i_type == 0 ?
        mq_router_regist_type_action_key : mq_router_regist_type_object_key;
        
        if (d_temp && d_temp.allKeys.count) {
            [MQRouter mq_deep_search:((NSMutableDictionary *)d_temp)
                       previous_node:s_key_temp
                           searching:block_searching];
        }
        else is_final = YES;
        
        d_temp.is_reach_bottom = is_final;
        
        if (block_searching) block_searching(d_temp);
    }
}

@end

#pragma mark - ----- ###########################################################

#ifndef MQ_ROUTER
    #define MQ_ROUTER [MQRouter mq_shared]
#endif

#ifndef MQ_ROUTER_KEYWORDIFY
    #if DEBUG
        #define MQ_ROUTER_KEYWORDIFY @autoreleasepool {}
    #else
        #define MQ_ROUTER_KEYWORDIFY @try {} @catch (...) {}
    #endif
#endif

#ifndef MQ_ROUTER_ON_EXIT
    static inline void clean_up_block(__strong void(^*block)(void)) {
        (*block)();
    }
    #define MQ_ROUTER_ON_EXIT \
            MQ_ROUTER_KEYWORDIFY \
            __strong void(^block)(void) \
            __attribute__((cleanup(clean_up_block), unused)) = ^
#endif

#ifndef MQ_ROUTER_MUTEX_LOCK
    #define MQ_ROUTER_MUTEX_LOCK(_lock_) \
            pthread_mutex_lock(&(_lock_)); \
            MQ_ROUTER_ON_EXIT { pthread_mutex_unlock(&(_lock_)); };
#endif

@interface MQRouter () < NSCopying , NSMutableCopying >

- (instancetype) init_by_mq NS_DESIGNATED_INITIALIZER ;

@property (nonatomic , strong) NSHashTable *hash_table ;
@property (nonatomic , copy) NSString * s_scheme ;

 /*
  structure like :
 {
     scheme : {
        sub_regist_pattern : {
            @"required" : [params] ,
            @"_" : handler_block ,
            @"defined_type" : type ,
            @"seq" : sequence ,
            @"path" : original_path ,
            
            sub_regist_pattern : {
                ...
            } ,
            sub_regist_pattern : {
                ...
            } ,
            sub_regist_pattern : {
                ...
            } ,
            ...
        } ,
     } ,
     ...
 }
  */

@property (nonatomic , strong) NSMutableDictionary <NSString * , NSMutableDictionary *> *router_map_d ;

- (NSString *) mq_path_scheme : (MQRouterPath) path ;

- (void) mq_delegate_response : (SEL) selector
           enumerate_delegate : (void (^)(id < MQRouterDelegate > delegate , BOOL is_response)) enumerate_block ;

- (NSMutableDictionary <NSString * , id> *) mq_extract_params_from_path : (MQRouterPath) path exactly_match : (BOOL) is_match ;

- (NSMutableDictionary *) mq_add_path_pattern : (NSString *) s_path ;

@end

@implementation MQRouter

/*
    1. about "pthread_mutex_trylock" || "pthread_mutex_lock" .
    2. due to everything need be done in proper order , using "pthread_mutex_lock" instead of "pthread_mutex_trylock" . ("pthread_mutex_lock" will jam the current thread until its' unlocked).
 
    1. 关于 "pthread_mutex_trylock" || "pthread_mutex_lock" .
    2. 因为 一切都需要有序完成 , 所以使用 "pthread_mutex_lock" 而不是 "pthread_mutex_trylock" . ("pthread_mutex_lock" 会阻塞当前线程 , 直到它解锁为止) .
 */

NSString * MQ_ROUTER_DEFAULT_SCHEME = @"elwinfrederick" ;
static NSUInteger __mq_router_regist_sequence = 0;

static pthread_mutex_t __lock;

static MQRouter *__router_shared = nil;
+ (instancetype)mq_shared {
    return [MQRouter mq_shared_by_default:nil];
}
+ (instancetype) mq_shared_by_default : (nullable NSString *) scheme {
    if (__router_shared) return __router_shared;
    __router_shared = [[MQRouter alloc] init_by_mq];
    __router_shared.s_scheme = scheme ? scheme : MQ_ROUTER_DEFAULT_SCHEME;
    return __router_shared ;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    if (__router_shared) return __router_shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __router_shared = [super allocWithZone:zone];
    });
    return __router_shared;
}
- (id)copyWithZone:(NSZone *)zone {
    return __router_shared;
}
- (id)mutableCopyWithZone:(NSZone *)zone {
    return __router_shared;
}

- (instancetype) init_by_mq {
    if ((self = [super init])) {
        pthread_mutexattr_t attr;
        pthread_mutexattr_init(&attr);
        pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_ERRORCHECK);
        
        if (pthread_mutex_init(&__lock, &attr) != 0) {
#if DEBUG
            NSAssert(false, @"pthread mutex lock init error .");
#endif
        }
    }
    return self;
}

- (void) dealloc {
    pthread_mutex_destroy(&__lock);
}

#pragma mark - ----- public

+ (void) mq_add_delegate : (id <MQRouterDelegate>) delegate_t {
    [MQ_ROUTER.hash_table addObject:delegate_t];
}
+ (void) mq_remove_delegate : (id <MQRouterDelegate>) delegate_t {
    if ([MQ_ROUTER.hash_table containsObject:delegate_t]) {
        [MQ_ROUTER.hash_table removeObject:delegate_t];
    }
}
+ (NSString *)default_scheme {
    return MQ_ROUTER.s_scheme;
}
+ (NSHashTable *)ht_all_delegates {
    return MQ_ROUTER.hash_table;
}
+ (NSMutableDictionary<NSString *,NSMutableDictionary *> *)router_map {
    return MQ_ROUTER.router_map_d;
}

+ (BOOL) mq_can_open : (MQRouterPath) path {
    return [self mq_can_open:path match:YES];
}
+ (BOOL) mq_can_open : (MQRouterPath) path
               match : (BOOL) is_match {
    id t = [MQ_ROUTER mq_extract_params_from_path:path exactly_match:is_match];
    
    [MQ_ROUTER mq_delegate_response:@selector(mq_router:did_begin_searching:pattern_info:) enumerate_delegate:^(id<MQRouterDelegate> delegate, BOOL is_response) {
        if (is_response) {
            [delegate mq_router:MQ_ROUTER
            did_begin_searching:path
                   pattern_info:t];
        }
    }];
    
    return !!t;
}

+ (void) mq_unregist_for_scheme : (NSString *) s_scheme {
    
    int i = pthread_mutex_lock(&__lock);
#if DEBUG
    NSAssert(i == 0, @"pthread mutex lock error .");
#endif
    MQ_ROUTER_ON_EXIT {
        pthread_mutex_unlock(&__lock);
    };
    
    if ([MQ_ROUTER.router_map_d objectForKey:s_scheme]) {
        [MQ_ROUTER.router_map_d removeObjectForKey:s_scheme];
        
        [MQ_ROUTER mq_delegate_response:@selector(mq_router:did_unregist_scheme:) enumerate_delegate:^(id<MQRouterDelegate> delegate, BOOL is_response) {
            if (is_response) {
                [delegate mq_router:MQ_ROUTER did_unregist_scheme:s_scheme];
            }
        }];
    }
}
+ (void) mq_unregist : (MQRouterPath) path {
    NSMutableArray *array_path_components = [MQRouter mq_path_components:path].mutableCopy;
    
    /*
        borrowed from "MGJRouter ( http://github.com/mogujie/MGJRouter )"
     */
    
    // delete the last pattern of path
    // 只删除该 path 的最后一级
    
    if (array_path_components.count >= 1) {
        
        // if path is a/b/c , then components is @"a.b.c" , exactly the key of KVC coding .
        // 假如 path 为 a/b/c, components 就是 @"a.b.c" , 正好可以作为 KVC 的 key
        NSString *s_components = [array_path_components componentsJoinedByString:@"."];
        NSMutableDictionary *dict_route = [MQ_ROUTER.router_map_d valueForKeyPath:s_components];
        
        if (dict_route.count >= 1) {
            NSString *s_last = [array_path_components lastObject];
            [array_path_components removeLastObject];
            
            // might be the root key , it's "router_map" then .
            // 有可能是根 key，这样就是 self.routes 了
            dict_route = MQ_ROUTER.router_map_d;
            if (array_path_components.count) {
                NSString *s_component_without_last = [array_path_components componentsJoinedByString:@"."];
                dict_route = [MQ_ROUTER.router_map_d valueForKeyPath:s_component_without_last];
            }
            [dict_route removeObjectForKey:s_last];
            
            [MQ_ROUTER mq_delegate_response:@selector(mq_router:did_unregist_path:) enumerate_delegate:^(id<MQRouterDelegate> delegate, BOOL is_response) {
                if (is_response) {
                    [delegate mq_router:MQ_ROUTER did_unregist_path:path];
                }
            }];
        }
    }
}
+ (void) mq_unregist_all {
    int i = pthread_mutex_lock(&__lock);
#if DEBUG
    NSAssert(i == 0, @"pthread mutex lock error .");
#endif
    MQ_ROUTER_ON_EXIT {
        pthread_mutex_unlock(&__lock);
    };
    
    [MQ_ROUTER.router_map_d removeAllObjects];
    MQ_ROUTER.router_map_d = [NSMutableDictionary dictionary];
    
    [MQ_ROUTER mq_delegate_response:@selector(mq_router_unregist_all_complete:) enumerate_delegate:^(id<MQRouterDelegate> delegate, BOOL is_response) {
        if (is_response) {
            [delegate mq_router_unregist_all_complete:MQ_ROUTER];
        }
    }];
}

#pragma mark - -----
+ (NSArray <NSString *> *) mq_registed_schemes {
    return [MQ_ROUTER.router_map_d.allKeys copy];
}
+ (NSArray <MQRouterPath> *) mq_registed_paths_for_scheme : (NSString *) scheme {
    return [MQRouter mq_all_paths_for_scheme:scheme
                                  router_map:MQ_ROUTER.router_map_d];
}

- (void) mq_node_console_log_with_detail : (BOOL) is_need {
    MQRouterNodeInfo.is_need_detail = is_need;
}
+ (NSArray <MQRouterNodeInfo *> *) mq_registed_nodes_for_scheme : (NSString *) scheme {
    return [MQRouter mq_nodes_for_scheme:scheme
                              router_map:MQ_ROUTER.router_map_d];
}

+ (void) mq_regist_action : (MQRouterPath) path
                  handler : (MQRouterRegistActionHandler) handler {
    [self mq_regist_action:path required:nil handler:handler];
}
+ (void) mq_regist_action : (MQRouterPath) path
                 required : (nullable NSArray <NSString *> *) required_params
                  handler : (MQRouterRegistActionHandler) handler {
    int i = pthread_mutex_lock(&__lock);
#if DEBUG
    NSAssert(i == 0, @"pthread mutex lock error .");
#endif
    MQ_ROUTER_ON_EXIT {
        pthread_mutex_unlock(&__lock);
    };
    
    NSMutableDictionary *t = [[self mq_shared] mq_add_path_pattern:path];
    if (t && handler) {
        [t setValue:required_params forKey:mq_router_required_params_key];
        [t setValue:handler forKey:mq_router_operate_block_holder];
        [t setValue:path forKey:mq_router_original_path_key];
        [t setValue:@(0) forKey:mq_router_operate_defined_type_key];
        [t setValue:@(__mq_router_regist_sequence ++)
             forKey:mq_router_regist_sequence_key];
    }
}
+ (void) mq_regist_object : (MQRouterPath) path
                  handler : (MQRouterRegistObjectHandler) handler {
    [self mq_regist_object:path required:nil handler:handler];
}
+ (void) mq_regist_object : (MQRouterPath) path
                 required : (nullable NSArray <NSString *> *) required_params
                  handler : (MQRouterRegistObjectHandler) handler {
    int i = pthread_mutex_lock(&__lock);
#if DEBUG
    NSAssert(i == 0, @"pthread mutex lock error .");
#endif
    MQ_ROUTER_ON_EXIT {
        pthread_mutex_unlock(&__lock);
    };
    
    NSMutableDictionary *t = [[self mq_shared] mq_add_path_pattern:path];
    if (t && handler) {
        [t setValue:required_params forKey:mq_router_required_params_key];
        [t setValue:handler forKey:mq_router_operate_block_holder];
        [t setValue:path forKey:mq_router_original_path_key];
        [t setValue:@(1) forKey:mq_router_operate_defined_type_key];
        [t setValue:@(__mq_router_regist_sequence ++)
             forKey:mq_router_regist_sequence_key];
    }
}

MQRouterPath mq_router_make(MQRouterPath path) {
    return mq_router_make_scheme(MQ_ROUTER.s_scheme, path);
}
MQRouterPath mq_router_make_scheme(NSString * _Nullable scheme, MQRouterPath path) {
    if ([path rangeOfString:@"://"].location != NSNotFound) {
        return path;
    }
    else if ([path hasPrefix:@"/"]) {
        path = [path substringFromIndex:1];
    }
    else if ([path hasPrefix:@"//"]) {
        path = [path substringFromIndex:2];
    }
    if ([scheme hasSuffix:@"://"]) {
        scheme = [scheme stringByReplacingOccurrencesOfString:@"://"
                                                   withString:@""];
    }
    
    return [[scheme stringByAppendingString:@"://"]
            stringByAppendingString:path];
}

#pragma mark - -----

+ (void) mq_call : (MQRouterPath) path {
    [self mq_call:path user_info:nil completion:nil];
}
+ (void) mq_call : (MQRouterPath) path
       user_info : (nullable NSDictionary <NSString * , id> *) user_info
      completion : (nullable MQRouterCompletionBlock) completion {
    [self mq_call:path user_info:nil completion:completion error:nil];
}
+ (void) mq_call : (MQRouterPath) path
       user_info : (nullable NSDictionary <NSString * , id> *) user_info
      completion : (nullable MQRouterCompletionBlock) completion
           error : (nullable MQRouterErrorBlock) error_block {
    
    MQRouterPath path_original = [path copy];
    [MQ_ROUTER
     mq_delegate_response:@selector(mq_router:did_begin_excuting:user_info:)
     enumerate_delegate:^(id<MQRouterDelegate> delegate, BOOL is_response) {
         if (is_response) {
             [delegate mq_router:MQ_ROUTER
              did_begin_excuting:path_original
                       user_info:user_info];
         }
     }];
    
    path = [MQRouter mq_path_encoded:path];
    NSMutableDictionary * dict_params = [[self mq_shared] mq_extract_params_from_path:path exactly_match:false];
    [dict_params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSString class]]) {
            [dict_params setValue:[MQRouter mq_path_decoded:obj] forKey:key];
        }
    }];
    
    void (^fall_error_block)(void) = ^{
        [MQ_ROUTER
         mq_delegate_response:@selector(mq_router:excuting_fail:user_info:error:)
         enumerate_delegate:^(id<MQRouterDelegate> delegate, BOOL is_response) {
             if (is_response) {
                 MQRouterError error = [NSError
                                        errorWithDomain:@"MQExtensionKit.MQRouter.Error"
                                        code:-1000
                                        userInfo:user_info];
                 [delegate mq_router:MQ_ROUTER
                       excuting_fail:path_original
                           user_info:user_info
                               error:error];
             }
         }];
        
        if (error_block) {
            error_block(path , user_info);
        }
    };
    
    if (dict_params) {
        NSArray *array_required_params = [dict_params valueForKey:mq_router_required_params_key];
        if (![MQRouter mq_check_params:dict_params
                     contains_required:array_required_params
                              hint_sel:_cmd
                                  path:path_original
                             user_info:user_info
                                 error:error_block]) {
            return ;
        }
        MQRouterRegistActionHandler handler = [dict_params valueForKey:mq_router_operate_block_key];
        if (completion) {
            [dict_params setValue:completion forKey:mq_router_params_completion];
        }
        if (user_info) {
            [dict_params setValue:user_info forKey:mq_router_params_userinfo];
        }
        if (handler) {
            [MQ_ROUTER
             mq_delegate_response:@selector(mq_router:excuting_complete:user_info:result:)
             enumerate_delegate:^(id<MQRouterDelegate> delegate, BOOL is_response) {
                 if (is_response) {
                     NSMutableDictionary *t = [NSMutableDictionary dictionary];
                     [t setValue:dict_params forKey:mq_router_get_params_key];
                     
                     [delegate mq_router:MQ_ROUTER
                       excuting_complete:path_original
                               user_info:user_info
                                  result:t];
                 }
             }];
            
            handler(dict_params);
            if (completion) completion(nil);
        }
        else if (fall_error_block) fall_error_block();
    }
    else if (fall_error_block) fall_error_block();
}

+ (id) mq_fetch : (MQRouterPath) path {
    return [self mq_fetch:path user_info:nil completion:nil];
}
+ (id) mq_fetch : (MQRouterPath) path
      user_info : (nullable NSDictionary <NSString * , id> *) user_info
     completion : (nullable MQRouterCompletionBlock) completion {
    return [self mq_fetch:path user_info:nil completion:completion error:nil];
}
+ (id) mq_fetch : (MQRouterPath) path
      user_info : (nullable NSDictionary <NSString * , id> *) user_info
     completion : (nullable MQRouterCompletionBlock) completion
          error : (nullable MQRouterErrorBlock) error_block {
    
    MQRouterPath path_original = [path copy];
    [MQ_ROUTER
     mq_delegate_response:@selector(mq_router:did_begin_excuting:user_info:)
     enumerate_delegate:^(id<MQRouterDelegate> delegate, BOOL is_response) {
         if (is_response) {
             [delegate mq_router:MQ_ROUTER
              did_begin_excuting:path_original
                       user_info:user_info];
         }
     }];
    
    path = [MQRouter mq_path_encoded:path];
    NSMutableDictionary * dict_params = [[self mq_shared] mq_extract_params_from_path:path exactly_match:false];
    [dict_params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSString class]]) {
            [dict_params setValue:[MQRouter mq_path_decoded:obj] forKey:key];
        }
    }];
    
    void (^fall_error_block)(void) = ^{
        [MQ_ROUTER
         mq_delegate_response:@selector(mq_router:excuting_fail:user_info:error:)
         enumerate_delegate:^(id<MQRouterDelegate> delegate, BOOL is_response) {
             if (is_response) {
                 MQRouterError error = [NSError
                                        errorWithDomain:@"MQExtensionKit.MQRouter.Error"
                                        code:-1000
                                        userInfo:user_info];
                 [delegate mq_router:MQ_ROUTER
                       excuting_fail:path_original
                           user_info:user_info
                               error:error];
             }
         }];
        
        if (error_block) {
            error_block(path , user_info);
        }
    };
    
    if (dict_params) {
        NSArray *array_required_params = [dict_params valueForKey:mq_router_required_params_key];
        if (![MQRouter mq_check_params:dict_params
                     contains_required:array_required_params
                              hint_sel:_cmd
                                  path:path_original
                             user_info:user_info
                                 error:error_block]) {
            return nil;
        }
        
        MQRouterRegistObjectHandler handler = [dict_params valueForKey:mq_router_operate_block_key];
        id result = nil;
        if (handler) {
            if (completion) {
                [dict_params setValue:completion forKey:mq_router_params_completion];
            }
            if (user_info) {
                [dict_params setValue:user_info forKey:mq_router_params_userinfo];
            }
            result = handler(dict_params);
            
            [MQ_ROUTER
             mq_delegate_response:@selector(mq_router:excuting_complete:user_info:result:)
             enumerate_delegate:^(id<MQRouterDelegate> delegate, BOOL is_response) {
                 if (is_response) {
                     
                     NSMutableDictionary *t = [NSMutableDictionary dictionary];
                     [t setValue:dict_params forKey:mq_router_get_params_key];
                     [t setValue:result forKey:mq_router_get_result_key];
                     
                     [delegate mq_router:MQ_ROUTER
                       excuting_complete:path_original
                               user_info:user_info
                                  result:t];
                 }
             }];
            if (completion) completion(result);
            
            return result;
        }
        else if (fall_error_block) fall_error_block();
    }
    else if (fall_error_block) fall_error_block();
    return nil;
}

#pragma mark - ----- private
- (NSString *) mq_path_scheme : (MQRouterPath) path {
    NSArray<NSString *> *t = [path componentsSeparatedByString:@"://"];
    if (!t || !t.count
        || !t.firstObject || !t.firstObject.length) {
        return nil;
    }
    return t.firstObject;
}

- (void) mq_delegate_response : (SEL) selector
           enumerate_delegate : (void (^)(id < MQRouterDelegate > delegate , BOOL is_response)) enumerate_block {
    for (id temp in self.hash_table) {
        if ([temp respondsToSelector:selector]) {
            if (enumerate_block) {
                enumerate_block(temp , YES);
            }
        }
        else if (enumerate_block) {
            enumerate_block(temp , false);
        }
    }
}

- (NSMutableDictionary <NSString * , id> *) mq_extract_params_from_path : (MQRouterPath) path exactly_match : (BOOL) is_match {
    NSMutableDictionary * d_params = [NSMutableDictionary dictionary];
    [d_params setValue:path forKey:mq_router_params_url];
    
    NSMutableDictionary * d_sub_routes = self.router_map_d;
    NSArray * array_path_components = [MQRouter mq_path_components:path];
    
    /*
        borrowed from "HHRouter( https://github.com/Huohua/HHRouter )"
     && "MGJRouter ( http://github.com/mogujie/MGJRouter )"
     */
    BOOL is_found = NO;
    for (NSString * temp_component in array_path_components) {
        
        // sorted to keys , put '~' to the end .
        // 对 key 进行排序 , 把 ~ 放到最后
        NSArray *array_sub_route_keys =[d_sub_routes.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
            return [obj1 compare:obj2];
        }];
        
        for (NSString * key in array_sub_route_keys) {
            if ([key isEqualToString:temp_component]
                || [key isEqualToString:mq_router_wildcard_character]) {
                is_found = YES;
                d_sub_routes = [d_sub_routes valueForKey:key];
                break;
            } else if ([key hasPrefix:@":"]) {
                is_found = YES;
                d_sub_routes = [d_sub_routes valueForKey:key];
                NSString *s_key_new = [key substringFromIndex:1];
                NSString *s_path_component_new = temp_component;
                
                // strip the text , eg : :id.html -> :id
                // 再做一下特殊处理，比如 :id.html -> :id
                if ([MQRouter mq_is_contain_special_character:key]) {
                    NSCharacterSet *set_special_character = [NSCharacterSet characterSetWithCharactersInString:mq_router_special_character];
                    NSRange range = [key rangeOfCharacterFromSet:set_special_character];
                    if (range.location != NSNotFound) {
                        // 把 pathComponent 后面的部分也去掉
                        s_key_new = [s_key_new substringToIndex:range.location - 1];
                        NSString *s_suffix_to_strip = [key substringFromIndex:range.location];
                        s_path_component_new = [s_path_component_new stringByReplacingOccurrencesOfString:s_suffix_to_strip withString:@""];
                    }
                }
                [d_params setValue:s_path_component_new forKey:s_key_new];
                break;
            } else if (is_match) {
                is_found = NO;
            }
        }
        
        // if not find the "handler" that match the "path_component" , make the previous handler as fallback .
        // 如果没有找到该 path_component 对应的 handler，则以上一层的 handler 作为 fallback
        if (!is_found && ![d_sub_routes valueForKey:mq_router_operate_block_holder]) {
            return nil;
        }
    }
    
    // 展开 query 中的参数 .
    // extract params from query.
    NSArray < NSURLQueryItem * > *array_query_items = [[NSURLComponents alloc] initWithURL:[[NSURL alloc] initWithString:path] resolvingAgainstBaseURL:false].queryItems;
    
    for (NSURLQueryItem *item in array_query_items) {
        [d_params setValue:item.value forKey:item.name];
    }
    
    if ([d_sub_routes valueForKey:mq_router_operate_block_holder]) {
        [d_params setValue:[[d_sub_routes valueForKey:mq_router_operate_block_holder] copy]
                    forKey:mq_router_operate_block_key];
    }
    if ([d_sub_routes valueForKey:mq_router_required_params_key]) {
        [d_params setValue:[[d_sub_routes valueForKey:mq_router_required_params_key] copy]
                    forKey:mq_router_required_params_key];
    }
    
    return d_params;
}

- (NSMutableDictionary *) mq_add_path_pattern : (NSString *) s_path {
    NSArray <NSString *> * t_component = [MQRouter mq_path_components:s_path];
    
    NSMutableDictionary * d_sub_route = self.router_map_d;
    
    // 这里可以看做一个循环往复的向下路径搜索查找 .
    // 并且可以创建不存在的路径 .
    for (NSString * temp_path in t_component) {
        if (![d_sub_route objectForKey:temp_path]) {
            [d_sub_route setValue:[NSMutableDictionary dictionary]
                           forKey:temp_path];
        }
        d_sub_route = [d_sub_route valueForKey:temp_path];
    }
    return d_sub_route;
}

- (NSHashTable *)hash_table {
    if (_hash_table) return _hash_table;
    NSHashTable *t = [NSHashTable weakObjectsHashTable];
    _hash_table = t;
    return _hash_table;
}

- (NSMutableDictionary <NSString * , NSMutableDictionary *> *) router_map_d {
    if (_router_map_d) return _router_map_d;
    NSMutableDictionary *t = [NSMutableDictionary dictionary];
    _router_map_d = t;
    return _router_map_d;
}

@end

