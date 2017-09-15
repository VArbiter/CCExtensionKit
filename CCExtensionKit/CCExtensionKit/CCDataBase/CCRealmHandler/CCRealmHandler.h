//
//  CCRealmHandler.h
//  CCAudioPlayer-Demo
//
//  Created by 冯明庆 on 06/07/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

@import Foundation;

#if __has_include(<Realm/Realm.h>)
@import Realm;

// dependency : pod 'Realm', '~> 2.10.0'

@interface CCRealmHandler : NSObject

// ----- open -----

+ (instancetype) shared ;
- (instancetype) ccDefault ; // equal : ccSpecific : nil
- (instancetype) ccSpecific : (NSString *) specific ; // open a specific realm
- (instancetype) ccOperate : (void(^)()) operate ; // do actions in transaction

// ----- insert -----

/// use a dictionary as intializer , a key must compare a value , but not neccessary to include all the keys
/// if dictioanry == nil , realm will continue to create an object
- (id) ccDictionary : (Class) cls
              value : (NSDictionary *) dictionary ;
// use an array as intializer , values must have the same order with keys , not much , not less
/// if array == nil , realm will continue to create an object
- (id) ccArray : (Class) cls
         value : (NSArray *) array ;
/// if object has a primary key , then insert or update , otherwise , insert only
- (instancetype) ccSave : (id) object ;

// ----- delete -----

/// delete an object according to object , might goes error
- (instancetype) ccDeleteT : (id) object ;
/// delete an object according to a primary key .
- (instancetype) ccDeleteS : (id) object ;
/// delete an array in realm
- (instancetype) ccDeleteA : (NSArray <__kindof RLMObject *>*) array ;
/// delete all the data in class
- (instancetype) ccDeleteC : (Class) cls ;
/// not it self , but the data in it
- (instancetype) ccDeleteAll ;
/// delete it self
- (instancetype) ccDestory : (NSString *) specific;

// ----- search -----

/// RLMResults
/// note : insert / delete will cause the change of this collection .
/// note : cause this collection was mirrored in local disk
- (RLMResults *) ccAll : (Class) cls ;

// ----- sort -----

/// class that need sorted , property , ascending or not (have to use this action after sorting)
- (RLMResults *) ccSorted : (Class) cls
                      key : (NSString *) sKey
                ascending : (BOOL) isAscending ;

// ----- migration -----

- (instancetype) ccMigration : (uint64_t) version
                      action : (void (^)(RLMRealmConfiguration *c , RLMMigration *m , uint64_t vOld)) action ;
- (instancetype) ccMigrationT : (RLMRealmConfiguration *(^)()) configuration
                       action : (void (^)(RLMMigration *m , uint64_t vOld)) action ;

// ----- status -----

// use them before every actions
- (instancetype) ccError : (void (^)(NSError *e)) error ;
- (instancetype) ccSucceed : (void (^)(BOOL b)) succeed ;

// ----- notification -----

- (instancetype) ccNotification : (void (^)(RLMNotification n, RLMRealm *r)) action ;

@end

#endif
