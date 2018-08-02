//
//  MQRealmHandler.m
//  MQAudioPlayer-Demo
//
//  Created by 冯明庆 on 06/07/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "MQRealmHandler.h"

#if __has_include(<Realm/Realm.h>)

#import <objc/runtime.h>

@interface MQRealmHandler ()

@property (nonatomic , strong) RLMRealm *realm;
/// must decorate with strong , otherwise it will release before useing
@property (nonatomic , strong) RLMNotificationToken *token;

@end

static const char * _MQ_RLM_ERROR_KEY_ = "_MQ_RLM_ERROR_KEY_";
static const char * _MQ_RLM_SUCCEED_KEY_ = "_MQ_RLM_SUCCEED_KEY_";
static const char * _MQ_RLM_NOTIFICATION_KEY_ = "_MQ_RLM_NOTIFICATION_KEY_";

@implementation MQRealmHandler

static MQRealmHandler *__handler = nil;
+ (instancetype) mq_shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __handler = [[MQRealmHandler alloc] init];
    });
    return __handler;
}

- (instancetype) mq_default {
    return [self mq_specific:nil];
}
- (instancetype) mq_specific : (NSString *) specific {
    if (self.token) {
        [self.token invalidate];
        self.token = nil;
    }
    
    if (specific.length > 0) {
        /// for now , using default folder and path .
        /// using user name to replace the default name .
        /// get configuration
        RLMRealmConfiguration *c = [RLMRealmConfiguration defaultConfiguration];
        c.fileURL = [[[c.fileURL URLByDeletingLastPathComponent]
                      URLByAppendingPathComponent:specific]
                     URLByAppendingPathExtension:@"realm"];
        NSError *error = nil;
        // this below , will change the default realm 's configuration .
        [RLMRealmConfiguration setDefaultConfiguration:c];
        // c.readOnly = YES; // read only or not
        self.realm = [RLMRealm realmWithConfiguration:c
                                                error:&error];
        void (^b)(BOOL) = objc_getAssociatedObject(self, _MQ_RLM_SUCCEED_KEY_);
        if (b) {b(error ? false : YES);}
        if (error) {
#if DEBUG
            @throw @"open database failed.";
#else
            void (^e)(NSError *) = objc_getAssociatedObject(self, _MQ_RLM_ERROR_KEY_);
            if (e) {e(error);}
#endif
            return self;
        }
    }
    else self.realm = [RLMRealm defaultRealm];
    
    __weak typeof(self) pSelf = self;
    void (^t)(RLMNotification n, RLMRealm *r) = objc_getAssociatedObject(pSelf, _MQ_RLM_NOTIFICATION_KEY_);
    if (t) {
        self.token = [pSelf.realm addNotificationBlock:^(RLMNotification  _Nonnull notification, RLMRealm * _Nonnull realm) {
            if (t) {
                t(notification , realm);
            }
        }];
    }
    
    return pSelf;
}
- (instancetype) mq_operate : (void(^)(void)) operate {
    NSError *error = nil;
    if ([self.realm inWriteTransaction]) {
#if DEBUG
        @throw @"Realm is already in transaction .";
#else
        void (^e)(NSError *) = objc_getAssociatedObject(self, _MQ_RLM_ERROR_KEY_);
        if (e) {e([NSError errorWithDomain:@"ElwinFrederick.MQRealmHandler"
                                      code:-100001
                                  userInfo:@{NSLocalizedDescriptionKey : @"Realm is already in transaction ."}]);}
#endif
    } else {
        [self.realm transactionWithBlock:^{
            if (operate) operate();
        } error:&error];
    }
    void (^b)(BOOL) = objc_getAssociatedObject(self, _MQ_RLM_SUCCEED_KEY_);
    if (b) {b(error ? false : YES);}
    if (error) {
        void (^e)(NSError *) = objc_getAssociatedObject(self, _MQ_RLM_ERROR_KEY_);
        if (e) {e(error);}
    }
    return self;
}

- (id) mq_dictionary : (Class) cls
               value : (NSDictionary *) dictionary {
    if ([cls isSubclassOfClass:[RLMObject class]]) {
        id v = nil;
        if (dictionary.allKeys.count > 0) {
            v = [[cls alloc] initWithValue:dictionary];
            // eqlals with above
//                [clazz createInRealm:pSelf.realm
//                           withValue:dictionary];
        }
        else v = [[cls alloc] init];
        return v;
    }
    return nil;
}
- (id) mq_array : (Class) cls
          value : (NSArray *) array {
    if ([cls isSubclassOfClass:[RLMObject class]]) {
        id v = nil;
        if (array.count > 0) {
            v = [[cls alloc] initWithValue:array];
        }
        else v = [[cls alloc] init];
        return v;
    };
    return nil;
}
- (instancetype) mq_save : (id) object {
    if (![[object class] isSubclassOfClass:[RLMObject class]]) return self;
    __weak typeof(self) pSelf = self;
    return [self mq_operate:^{
        void (^t)(void) = ^ {
            [pSelf.realm addObject:object]; // if not , insert only
        };
        if ([[object class] respondsToSelector:@selector(primaryKey)]) {
            id value = [[object class] performSelector:@selector(primaryKey)];
            if (value) [pSelf.realm addOrUpdateObject:object]; // if has a primaryKey , it will be insert or update
            else t();
        }
        else t();
    }];
}

- (instancetype) mq_delete : (id) object {
    if (![[object class] isSubclassOfClass:[RLMObject class]]) return self;
    __weak typeof(self) pSelf = self;
    return [self mq_operate:^{
        [pSelf.realm deleteObject:object];
    }];
}
- (instancetype) mq_delete_promary_key : (id) object {
    if (![[object class] isSubclassOfClass:[RLMObject class]]) return self;
    __weak typeof(self) pSelf = self;
    if ([[object class] respondsToSelector:@selector(primaryKey)]) {
        NSString *pk = [[object class] performSelector:@selector(primaryKey)];
        RLMResults *r = [[object class] objectsWhere:[NSString stringWithFormat:@"%@ = %@" , pk , [object valueForKeyPath:pk]]];
        if (r.count > 0) {
            return [self mq_operate:^{
                [pSelf.realm deleteObjects:r];
            }];
        }
    }
    return self;
}
- (instancetype) mq_delete_array : (NSArray <__kindof RLMObject *>*) array {
    __weak typeof(self) pSelf = self;
    return [self mq_operate:^{
        [pSelf.realm deleteObjects:array];
    }];
}
- (instancetype) mq_delete_class : (Class) cls {
    if (![cls isKindOfClass:[RLMObject class]]) return self;
    __weak typeof(self) pSelf = self;
    return [self mq_operate:^{
        [pSelf.realm deleteObjects:[cls allObjects]];
    }];
}
- (instancetype) mq_delete_all {
    __weak typeof(self) pSelf = self;
    return [self mq_operate:^{
        [pSelf.realm deleteAllObjects];
    }];
}
- (void) mq_destory : (NSString *) specific {
    // still default configuration
    RLMRealmConfiguration *c = [RLMRealmConfiguration defaultConfiguration];
    c.fileURL = [[[c.fileURL URLByDeletingLastPathComponent]
                  URLByAppendingPathComponent:specific]
                 URLByAppendingPathExtension:@"realm"];
    // the org. gave out this path .
    // not entirely delete ...
    NSArray <NSURL *> *a = @[c.fileURL,
                             [c.fileURL URLByAppendingPathExtension:@"lock"],
                             [c.fileURL URLByAppendingPathExtension:@"log_a"],
                             [c.fileURL URLByAppendingPathExtension:@"log_b"],
                             [c.fileURL URLByAppendingPathExtension:@"note"]];
    NSFileManager *m = NSFileManager.defaultManager;
#if !DEBUG
    __weak typeof(self) pSelf = self;
#endif
    [a enumerateObjectsUsingBlock:^(NSURL * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSError *error = nil;
        if (![m removeItemAtURL:obj
                          error:&error]) {
#if DEBUG
            @throw @"delete Error .";
#else
            void (^b)(BOOL) = objc_getAssociatedObject(pSelf, _MQ_RLM_SUCCEED_KEY_);
            if (b) {b(error ? false : YES);}
            if (error) {
                void (^e)(NSError *) = objc_getAssociatedObject(pSelf, _MQ_RLM_ERROR_KEY_);
                if (e) {e(error);}
            }
#endif
        }
    }];
}

- (RLMResults *) mq_all : (Class) cls {
    if (![cls isSubclassOfClass:[RLMObject class]]) return nil;
    id value = [cls allObjectsInRealm:self.realm];
    return value;
}

- (RLMResults *) mq_sorted : (Class) cls
                       key : (NSString *) s_key
                 ascending : (BOOL) is_ascending {
    RLMResults *r = [self mq_all:cls];
    if ([r isKindOfClass:[RLMResults class]]) {
        RLMResults *t = [r sortedResultsUsingKeyPath:s_key
                                           ascending:is_ascending];
        return t;
    }
    return nil;
}

- (instancetype) mq_migration : (uint64_t) version
                       action : (void (^)(RLMRealmConfiguration *c , RLMMigration *m , uint64_t vOld)) action {
    if (!action) return self;
    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    // config.deleteRealmIfMigrationNeeded = YES; // if needed , delete realm , currently , not need .
    config.schemaVersion = version;
    __unsafe_unretained typeof(config) pConfig = config;
    config.migrationBlock = ^(RLMMigration * _Nonnull migration, uint64_t oldSchemaVersion) {
        /// Realm will automatic do the migration actions (including structure && data)
        action(pConfig , migration , oldSchemaVersion);
    };
    [RLMRealmConfiguration setDefaultConfiguration:config]; // change the default configuration , it will be effective on next access (for defaultRealm)
    
    /// migration will do actions on first access
    /// want it immediately , access the realm
    [RLMRealm defaultRealm];
    return self;
}
- (instancetype) mq_migration_config : (RLMRealmConfiguration *(^)(void)) configuration
                              action : (void (^)(RLMMigration *m , uint64_t vOld)) action {
    if (!configuration || !action) return self;
    void (^b)(BOOL) = objc_getAssociatedObject(self, _MQ_RLM_SUCCEED_KEY_);
    RLMRealmConfiguration *config = configuration();
    config.migrationBlock = ^(RLMMigration * _Nonnull migration, uint64_t oldSchemaVersion) {
        action(migration , oldSchemaVersion);
    };
    [RLMRealmConfiguration setDefaultConfiguration:config];
    [RLMRealm defaultRealm];
    if (b) b(YES);
    return self;
}

- (instancetype) mq_error : (void (^)(NSError *e)) error {
    if (error) {
        objc_setAssociatedObject(self, _MQ_RLM_ERROR_KEY_, error, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    return self;
}
- (instancetype) mq_succeed : (void (^)(BOOL b)) succeed {
    if (succeed) {
        objc_setAssociatedObject(self, _MQ_RLM_SUCCEED_KEY_, succeed, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    return self;
}

- (instancetype) mq_notification : (void (^)(RLMNotification n, RLMRealm *r)) action {
    if (action) {
        objc_setAssociatedObject(self, _MQ_RLM_NOTIFICATION_KEY_, action, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    return self;
}

@end

#endif
