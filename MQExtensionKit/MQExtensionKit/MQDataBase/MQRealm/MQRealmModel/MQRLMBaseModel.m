//
//  MQRLMBaseModel.m
//  MQAudioPlayer-Demo
//
//  Created by 冯明庆 on 06/07/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "MQRLMBaseModel.h"

#if __has_include(<Realm/Realm.h>)

@interface MQRLMBaseModel ()

@property (nonatomic , copy) NSString * specificBase ;

@end

static RLMNotificationToken *__ccToken = nil;

@implementation MQRLMBaseModel

+ (NSArray<NSString *> *)ignoredProperties {
    return @[@"specificBase",@"ccToken"];
}

+ (instancetype) common {
    return [self commonD:nil];
}
+ (instancetype) commonD : (NSDictionary *) dictionary {
    return [MQRealmHandler.shared ccDictionary:self
                                         value:dictionary];
}
+ (instancetype) commonA : (NSArray *) array {
    return [MQRealmHandler.shared ccArray:self
                                    value:array];
}

- (instancetype) ccSpecific : (NSString *) specificDataBase {
    if (specificDataBase.length > 0) self.specificBase = specificDataBase;
    return self;
}
+ (MQRealmHandler *) ccOperate : (void (^)(void)) transaction {
    return [self ccOperate:nil
               transaction:transaction];
}
+ (MQRealmHandler *) ccOperate : (NSString *) specificDataBase
                   transaction : (void (^)(void)) transaction {
    return [[MQRealmHandler.shared ccSpecific:specificDataBase] ccOperate:^{
        if (transaction) transaction();
    }];
}
- (MQRealmHandler *) ccSave {
    return [[MQRealmHandler.shared ccSpecific:self.specificBase] ccSave:self];
}

- (MQRealmHandler *) ccDeleteT {
    return [[MQRealmHandler.shared ccSpecific:self.specificBase] ccDeleteT:self];
}
- (MQRealmHandler *) ccDeleteS {
    return [[MQRealmHandler.shared ccSpecific:self.specificBase] ccDeleteS:self];
}
+ (MQRealmHandler *) ccDeleteArray : (NSString *) specificDataBase
                             array : (NSArray <__kindof MQRLMBaseModel *> *) array {
    return [[MQRealmHandler.shared ccSpecific:specificDataBase] ccDeleteA:array];
}
+ (MQRealmHandler *) ccDeleteAll : (NSString *) specificDataBase {
    return [[MQRealmHandler.shared ccSpecific:specificDataBase] ccDeleteAll];
}

+ (RLMResults *) ccAll : (NSString *) specificDataBase {
    return [[MQRealmHandler.shared ccSpecific:specificDataBase] ccAll:self];
}
+ (MQRealmHandler *) ccNotification : (NSString *) specificDataBase
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
    return MQRealmHandler.shared;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}
- (id)valueForUndefinedKey:(NSString *)key {
    return nil;
}

@end

#endif
