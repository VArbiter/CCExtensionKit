//
//  MQRLMBaseEntity.h
//  MQExtensionKit
//
//  Created by 冯明庆 on 06/07/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "MQRealmHandler.h"

#if __has_include(<Realm/Realm.h>)

@interface MQRLMBaseEntity : RLMObject

+ (instancetype) mq_common ;
+ (instancetype) mq_common_dictionary : (NSDictionary *) dictionary ;
+ (instancetype) mq_common_array : (NSArray *) array ;

/// in transaction // 事务中
+ (void) mq_operate : (void (^)(void)) transaction ;

- (instancetype) mq_save ;

// when a delete complete , do sth more like reloading data (prevent crash) // 当删除完成后 , 做多一些操作 , 比如重载数据 (防止崩溃)

/// delete an object according to object // 根据 obj 来删除 obj
- (void) mq_delete ;
/// delete an object according to primarykey // 根据主键来删除对象
- (void) mq_delete_according_to_primary_key ;
+ (void) mq_delete_array : (NSArray <__kindof MQRLMBaseEntity *> *) array ;
/// delete all data in a class // 删除本类中所有的数据
+ (void) mq_delete_all ;

/// all results // 所有数据
+ (RLMResults < __kindof MQRLMBaseEntity *> *) mq_all_results ;
+ (NSMutableArray < __kindof MQRLMBaseEntity *> *) mq_all_array ;
/// add a notification to all objects in this class // 针对这个类添加观察者
+ (void) mq_notification_change : (void (^)(RLMResults * results,
                                            RLMCollectionChange * change,
                                            NSError * error)) change_block ;
@end

#endif
