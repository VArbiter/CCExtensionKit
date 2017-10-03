//
//  CCRLMBaseModel.m
//  CCAudioPlayer-Demo
//
//  Created by 冯明庆 on 06/07/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "CCRLMBaseModel.h"

#if __has_include(<Realm/Realm.h>)

@interface CCRLMBaseModel ()

@property (nonatomic , copy) NSString * specificBase ;

@end

static RLMNotificationToken *__ccToken = nil;

@implementation CCRLMBaseModel

+ (NSArray<NSString *> *)ignoredProperties {
    return @[@"specificBase",@"ccToken"];
}

+ (instancetype) common {
    return [self commonD:nil];
}
+ (instancetype) commonD : (NSDictionary *) dictionary {
    return [CCRealmHandler.shared ccDictionary:self
                                         value:dictionary];
}
+ (instancetype) commonA : (NSArray *) array {
    return [CCRealmHandler.shared ccArray:self
                                    value:array];
}

- (instancetype) ccSpecific : (NSString *) specificDataBase {
    if (specificDataBase.length > 0) self.specificBase = specificDataBase;
    return self;
}
+ (CCRealmHandler *) ccOperate : (void (^)()) transaction {
    return [self ccOperate:nil
               transaction:transaction];
}
+ (CCRealmHandler *) ccOperate : (NSString *) specificDataBase
                   transaction : (void (^)()) transaction {
    return [[CCRealmHandler.shared ccSpecific:specificDataBase] ccOperate:^{
        if (transaction) transaction();
    }];
}
- (CCRealmHandler *) ccSave {
    return [[CCRealmHandler.shared ccSpecific:self.specificBase] ccSave:self];
}

- (CCRealmHandler *) ccDeleteT {
    return [[CCRealmHandler.shared ccSpecific:self.specificBase] ccDeleteT:self];
}
- (CCRealmHandler *) ccDeleteS {
    return [[CCRealmHandler.shared ccSpecific:self.specificBase] ccDeleteS:self];
}
+ (CCRealmHandler *) ccDeleteArray : (NSString *) specificDataBase
                             array : (NSArray <__kindof CCRLMBaseModel *> *) array {
    return [[CCRealmHandler.shared ccSpecific:specificDataBase] ccDeleteA:array];
}
+ (CCRealmHandler *) ccDeleteAll : (NSString *) specificDataBase {
    return [[CCRealmHandler.shared ccSpecific:specificDataBase] ccDeleteAll];
}

+ (RLMResults *) ccAll : (NSString *) specificDataBase {
    return [[CCRealmHandler.shared ccSpecific:specificDataBase] ccAll:self];
}
+ (CCRealmHandler *) ccNotification : (NSString *) specificDataBase
                             change : (void (^)(RLMResults * results,
                                                RLMCollectionChange * change,
                                                NSError * error)) changeN {
    if (__ccToken) {
        [__ccToken stop];
        __ccToken = nil;
    }
    __ccToken = [[self ccAll:specificDataBase] addNotificationBlock:^(RLMResults * _Nullable results, RLMCollectionChange * _Nullable change, NSError * _Nullable error) {
        if (changeN) {
            // change.insertions; // insert
            // change.deletions; // delete
            // change.modifications; // change
            changeN(results , change , error);
        }
    }];
    return CCRealmHandler.shared;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}
- (id)valueForUndefinedKey:(NSString *)key {
    return nil;
}

@end

#endif
