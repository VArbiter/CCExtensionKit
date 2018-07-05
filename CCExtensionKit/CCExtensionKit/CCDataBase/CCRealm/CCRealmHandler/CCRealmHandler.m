//
//  CCRealmHandler.m
//  CCAudioPlayer-Demo
//
//  Created by 冯明庆 on 06/07/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "CCRealmHandler.h"

#if __has_include(<Realm/Realm.h>)

#import <objc/runtime.h>

@interface CCRealmHandler () < NSCopying , NSMutableCopying >

- (instancetype) ccDefaultSettings : (void (^)(void)) action ;
@property (nonatomic , strong) RLMRealm *realm;
/// must decorate with strong , otherwise it will release before useing
@property (nonatomic , strong) RLMNotificationToken *token;

@end

static CCRealmHandler *__handler = nil;
static const char * _CC_RLM_ERROR_KEY_ = "_CC_RLM_ERROR_KEY_";
static const char * _CC_RLM_SUCCEED_KEY_ = "_CC_RLM_SUCCEED_KEY_";
static const char * _CC_RLM_NOTIFICATION_KEY_ = "_CC_RLM_NOTIFICATION_KEY_";

@implementation CCRealmHandler

+ (instancetype) shared {
    if (__handler) return __handler;
    __handler = [[CCRealmHandler alloc] init];
    return __handler;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    if (__handler) return __handler;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __handler = [super allocWithZone:zone];
    });
    return __handler;
}
- (id)copyWithZone:(NSZone *)zone {
    return __handler;
}
- (id)mutableCopyWithZone:(NSZone *)zone {
    return __handler;
}
- (instancetype)init {
    if ((self = [super init])) {
        [self ccDefaultSettings:^{
            
        }];
    }
    return self;
}

- (instancetype) ccDefault {
    return [self ccSpecific:nil];
}
- (instancetype) ccSpecific : (NSString *) specific {
    if (self.token) {
        [self.token stop];
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
        void (^b)(BOOL) = objc_getAssociatedObject(self, _CC_RLM_SUCCEED_KEY_);
        if (b) {b(error ? false : YES);}
        if (error) {
#if DEBUG
            @throw @"open database failed.";
#else
            void (^e)(NSError *) = objc_getAssociatedObject(self, _CC_RLM_ERROR_KEY_);
            if (e) {e(error);}
#endif
            return self;
        }
    }
    else self.realm = [RLMRealm defaultRealm];
    
    __weak typeof(self) pSelf = self;
    void (^t)(RLMNotification n, RLMRealm *r) = objc_getAssociatedObject(pSelf, _CC_RLM_NOTIFICATION_KEY_);
    if (t) {
        self.token = [pSelf.realm addNotificationBlock:^(RLMNotification  _Nonnull notification, RLMRealm * _Nonnull realm) {
            if (t) {
                t(notification , realm);
            }
        }];
    }
    
    return pSelf;
}
- (instancetype) ccOperate : (void(^)(void)) operate {
    NSError *error = nil;
    if ([self.realm inWriteTransaction]) {
#if DEBUG
        @throw @"Realm is already in transaction .";
#else
        void (^e)(NSError *) = objc_getAssociatedObject(self, _CC_RLM_ERROR_KEY_);
        if (e) {e([NSError errorWithDomain:@"ElwinFrederick.CCRealmHandler"
                                      code:-100001
                                  userInfo:@{NSLocalizedDescriptionKey : @"Realm is already in transaction ."}]);}
#endif
    } else {
        [self.realm transactionWithBlock:^{
            if (operate) operate();
        } error:&error];
    }
    void (^b)(BOOL) = objc_getAssociatedObject(self, _CC_RLM_SUCCEED_KEY_);
    if (b) {b(error ? false : YES);}
    if (error) {
        void (^e)(NSError *) = objc_getAssociatedObject(self, _CC_RLM_ERROR_KEY_);
        if (e) {e(error);}
    }
    return self;
}

- (id) ccDictionary : (Class) cls
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
- (id) ccArray : (Class) cls
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
- (instancetype) ccSave : (id) object {
    if (![[object class] isSubclassOfClass:[RLMObject class]]) return self;
    __weak typeof(self) pSelf = self;
    return [self ccOperate:^{
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

- (instancetype) ccDeleteT : (id) object {
    if (![[object class] isSubclassOfClass:[RLMObject class]]) return self;
    __weak typeof(self) pSelf = self;
    return [self ccOperate:^{
        [pSelf.realm deleteObject:object];
    }];
}
- (instancetype) ccDeleteS : (id) object {
    if (![[object class] isSubclassOfClass:[RLMObject class]]) return self;
    __weak typeof(self) pSelf = self;
    if ([[object class] respondsToSelector:@selector(primaryKey)]) {
        NSString *pk = [[object class] performSelector:@selector(primaryKey)];
        RLMResults *r = [[object class] objectsWhere:[NSString stringWithFormat:@"%@ = %@" ,pk , [object valueForKeyPath:pk]]];
        if (r.count > 0) {
            return [self ccOperate:^{
                [pSelf.realm deleteObjects:r];
            }];
        }
    }
    return self;
}
- (instancetype) ccDeleteA : (NSArray <__kindof RLMObject *>*) array {
    __weak typeof(self) pSelf = self;
    return [self ccOperate:^{
        [pSelf.realm deleteObjects:array];
    }];
}
- (instancetype) ccDeleteC : (Class) cls {
    if (![cls isKindOfClass:[RLMObject class]]) return self;
    __weak typeof(self) pSelf = self;
    return [self ccOperate:^{
        [pSelf.realm deleteObjects:[cls allObjects]];
    }];
}
- (instancetype) ccDeleteAll {
    __weak typeof(self) pSelf = self;
    return [self ccOperate:^{
        [pSelf.realm deleteAllObjects];
    }];
}
- (instancetype) ccDestory : (NSString *) specific {
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
            void (^b)(BOOL) = objc_getAssociatedObject(pSelf, _CC_RLM_SUCCEED_KEY_);
            if (b) {b(error ? false : YES);}
            if (error) {
                void (^e)(NSError *) = objc_getAssociatedObject(pSelf, _CC_RLM_ERROR_KEY_);
                if (e) {e(error);}
            }
#endif
        }
    }];
    return CCRealmHandler.shared;
}

- (RLMResults *) ccAll : (Class) cls {
    if (![cls isSubclassOfClass:[RLMObject class]]) return nil;
    id value = [cls allObjectsInRealm:self.realm];
    return value;
}

- (RLMResults *) ccSorted : (Class) cls
                      key : (NSString *) sKey
                ascending : (BOOL) isAscending {
    RLMResults *r = [self ccAll:cls];
    if ([r isKindOfClass:[RLMResults class]]) {
        RLMResults *t = [r sortedResultsUsingKeyPath:sKey
                                           ascending:isAscending];
        return t;
    }
    return nil;
}

- (instancetype) ccMigration : (uint64_t) version
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
- (instancetype) ccMigrationT : (RLMRealmConfiguration *(^)(void)) configuration
                       action : (void (^)(RLMMigration *m , uint64_t vOld)) action {
    if (!configuration || !action) return self;
    void (^b)(BOOL) = objc_getAssociatedObject(self, _CC_RLM_SUCCEED_KEY_);
    RLMRealmConfiguration *config = configuration();
    config.migrationBlock = ^(RLMMigration * _Nonnull migration, uint64_t oldSchemaVersion) {
        action(migration , oldSchemaVersion);
    };
    [RLMRealmConfiguration setDefaultConfiguration:config];
    [RLMRealm defaultRealm];
    if (b) b(YES);
    return self;
}

- (instancetype) ccError : (void (^)(NSError *e)) error {
    if (error) {
        objc_setAssociatedObject(self, _CC_RLM_ERROR_KEY_, error, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    return self;
}
- (instancetype) ccSucceed : (void (^)(BOOL b)) succeed {
    if (succeed) {
        objc_setAssociatedObject(self, _CC_RLM_SUCCEED_KEY_, succeed, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    return self;
}

- (instancetype) ccNotification : (void (^)(RLMNotification n, RLMRealm *r)) action {
    if (action) {
        objc_setAssociatedObject(self, _CC_RLM_NOTIFICATION_KEY_, action, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    return self;
}

#pragma mark - Private

- (instancetype) ccDefaultSettings : (void (^)(void)) action {
    if (action) action();
    return self;
}

@end

#endif
