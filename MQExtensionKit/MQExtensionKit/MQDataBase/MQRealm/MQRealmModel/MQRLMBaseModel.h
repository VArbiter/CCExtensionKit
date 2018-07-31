//
//  MQRLMBaseModel.h
//  MQAudioPlayer-Demo
//
//  Created by 冯明庆 on 06/07/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "MQRealmHandler.h"

#if __has_include(<Realm/Realm.h>)

@interface MQRLMBaseModel : RLMObject

+ (instancetype) mq_common ;
+ (instancetype) mq_common_dictionary : (NSDictionary *) dictionary ;
+ (instancetype) mq_common_array : (NSArray *) array ;

/// default : defalut // 默认
- (instancetype) mq_specific : (NSString *) specific_database ;
/// in transaction // 事务中
+ (MQRealmHandler *) mq_operate : (void (^)(void)) transaction ;
/// specific database in transaction // 在事务中操作特定数据库
+ (MQRealmHandler *) mq_operate : (NSString *) specific_database
                    transaction : (void (^)(void)) transaction ;
- (MQRealmHandler *) mq_save ;

// when a delete complete , do sth more like reloading data (prevent crash) // 当删除完成后 , 做多一些操作 , 比如重载数据 (防止崩溃)

/// delete an object according to object // 根据 obj 来删除 obj
- (MQRealmHandler *) mq_delete ;
/// delete an object according to primarykey // 根据主键来删除对象
- (MQRealmHandler *) mq_delete_according_to_primary_key ;
+ (MQRealmHandler *) mq_delete_array : (NSString *) specific_database
                               array : (NSArray <__kindof MQRLMBaseModel *> *) array ;
/// delete all data in a class // 删除本类中所有的数据
+ (MQRealmHandler *) mq_delete_all : (NSString *) specific_database ;

/// all results // 所有数据
+ (RLMResults *) mq_all : (NSString *) specific_database ;
/// add a notification to all objects in this class // 针对这个类添加观察者
+ (MQRealmHandler *) mq_notification : (NSString *) specific_database
                              change : (void (^)(RLMResults * results,
                                                 RLMCollectionChange * change,
                                                 NSError * error)) changeN ;
@end

#endif
