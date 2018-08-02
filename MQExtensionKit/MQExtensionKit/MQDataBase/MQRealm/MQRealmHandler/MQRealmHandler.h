//
//  MQRealmHandler.h
//  MQAudioPlayer-Demo
//
//  Created by 冯明庆 on 06/07/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

@import Foundation;

#if __has_include(<Realm/Realm.h>)
@import Realm;

// dependency : pod 'Realm', '~> 2.10.0'
// 依赖于 : pod 'Realm', '~> 2.10.0'

@interface MQRealmHandler : NSObject

// ----- open ----- // 打开

+ (instancetype) mq_shared ;
- (instancetype) mq_default ; // equal : mq_specific : nil // 等同于 mq_specific : nil
- (instancetype) mq_specific : (NSString *) specific ; // open a specific realm // 打开指定的数据库
- (instancetype) mq_operate : (void(^)(void)) operate ; // do actions in transaction // 在事务中才做

// ----- insert ----- // 插入

/// use a dictionary as intializer , a key must compare a value , but not neccessary to include all the keys
/// if dictioanry == nil , realm will continue to create an object

/// 使用字典来初始化 , key 必须要有一个值 , 但是不要求所有的key 都包含在其中
/// 如果 dictionary 为空 , realm 仍然会创建对象

- (id) mq_dictionary : (Class) cls
               value : (NSDictionary *) dictionary ;
/// use an array as intializer , values must have the same order with keys , not much , not less // 使用数组来初始化 , 顺序必须全部一致
/// if array == nil , realm will continue to create an object // 如果 dictionary 为空 , realm 仍然会创建对象
- (id) mq_array : (Class) cls
          value : (NSArray *) array ;
/// if object has a primary key , then insert or update , otherwise , insert only // 如果有主键 , 可以插入或者更新 , 否则 , 只插入
- (instancetype) mq_save : (id) object ;

// ----- delete ----- // 删除

/// delete an object according to object , might goes error // 根据对象来删除 , 可能出现错误
- (instancetype) mq_delete : (id) object ;
/// delete an object according to a primary key . // 根据主键来删除
- (instancetype) mq_delete_promary_key : (id) object ;
/// delete an array in realm // 从 realm 中删除 array 中的元素
- (instancetype) mq_delete_array : (NSArray <__kindof RLMObject *>*) array ;
/// delete all the data in class // 删除某个表中所有的数据
- (instancetype) mq_delete_class : (Class) cls ;
/// not it self , but the data in it // 删除不是本身 . 但是是所有的表
- (instancetype) mq_delete_all ;
/// delete it self // 删除本身 (摧毁数据库)
- (void) mq_destory : (NSString *) specific;

// ----- search ----- // 搜索

/// RLMResults
/// note : insert / delete will cause the change of this collection . // 插入/删除操作将导致这个集合产生变化
/// note : cause this collection was mirrored in local disk // 因为这个集合是磁盘的映射
- (RLMResults *) mq_all : (Class) cls ;

// ----- sort ----- // 排序

/// class that need sorted , property , ascending or not (have to use this action after sorting) // 类中需要排序的元素 ,
- (RLMResults *) mq_sorted : (Class) cls
                       key : (NSString *) s_key
                 ascending : (BOOL) is_ascending ;

// ----- migration ----- // 迁移

- (instancetype) mq_migration : (uint64_t) version
                       action : (void (^)(RLMRealmConfiguration *c , RLMMigration *m , uint64_t v_old)) action ;
- (instancetype) mq_migration_config : (RLMRealmConfiguration *(^)(void)) configuration
                              action : (void (^)(RLMMigration *m , uint64_t v_old)) action ;

// ----- status ----- // 状态

// use them before every actions // 在每次操作前使用
- (instancetype) mq_error : (void (^)(NSError *e)) error ;
- (instancetype) mq_succeed : (void (^)(BOOL b)) succeed ;

// ----- notification ----- // 通知

- (instancetype) mq_notification : (void (^)(RLMNotification n, RLMRealm *r)) action ;

@end

#endif
