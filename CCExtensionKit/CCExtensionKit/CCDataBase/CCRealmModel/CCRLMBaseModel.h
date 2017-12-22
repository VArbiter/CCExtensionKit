//
//  CCRLMBaseModel.h
//  CCAudioPlayer-Demo
//
//  Created by 冯明庆 on 06/07/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "CCRealmHandler.h"

#if __has_include(<Realm/Realm.h>)

@interface CCRLMBaseModel : RLMObject

+ (instancetype) common ;
+ (instancetype) commonD : (NSDictionary *) dictionary ;
+ (instancetype) commonA : (NSArray *) array ;

/// default : defalut // 默认
- (instancetype) ccSpecific : (NSString *) specificDataBase ;
/// in transaction // 事务中
+ (CCRealmHandler *) ccOperate : (void (^)(void)) transaction ;
/// specific database in transaction // 在事务中操作特定数据库
+ (CCRealmHandler *) ccOperate : (NSString *) specificDataBase
                   transaction : (void (^)(void)) transaction ;
- (CCRealmHandler *) ccSave ;

// when a delete complete , do sth more like reloading data (prevent crash) // 当删除完成后 , 做多一些操作 , 比如重载数据 (防止崩溃)

/// delete an object according to object // 根据 obj 来珊瑚 obj
- (CCRealmHandler *) ccDeleteT ;
/// delete an object according to primarykey // 根据主键来删除对象
- (CCRealmHandler *) ccDeleteS ;
+ (CCRealmHandler *) ccDeleteArray : (NSString *) specificDataBase
                             array : (NSArray <__kindof CCRLMBaseModel *> *) array ;
/// delete all data in a class // 删除本类中所有的数据
+ (CCRealmHandler *) ccDeleteAll : (NSString *) specificDataBase ;

/// all results // 所有数据
+ (RLMResults *) ccAll : (NSString *) specificDataBase ;
/// add a notification to all objects in this class // 针对这个类添加观察者
+ (CCRealmHandler *) ccNotification : (NSString *) specificDataBase
                             change : (void (^)(RLMResults * results,
                                                RLMCollectionChange * change,
                                                NSError * error)) changeN ;
@end

#endif
