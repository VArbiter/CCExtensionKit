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

static RLMNotificationToken *__mq_token = nil;

@implementation MQRLMBaseModel

+ (NSArray<NSString *> *)ignoredProperties {
    return @[@"specificBase",@"mqToken"];
}

+ (instancetype) mq_common {
    return [self mq_common_dictionary:nil];
}
+ (instancetype) mq_common_dictionary : (NSDictionary *) dictionary {
    return [MQRealmHandler.mq_shared mq_dictionary:self
                                             value:dictionary];
}
+ (instancetype) mq_common_array : (NSArray *) array {
    return [MQRealmHandler.mq_shared mq_array:self
                                        value:array];
}

- (instancetype) mq_specific : (NSString *) specific_database {
    if (specific_database.length > 0) self.specificBase = specific_database;
    return self;
}
+ (MQRealmHandler *) mq_operate : (void (^)(void)) transaction {
    return [self mq_operate:nil
                transaction:transaction];
}
+ (MQRealmHandler *) mq_operate : (NSString *) specific_database
                    transaction : (void (^)(void)) transaction {
    return [[MQRealmHandler.mq_shared mq_specific:specific_database] mq_operate:^{
        if (transaction) transaction();
    }];
}
- (MQRealmHandler *) mq_save {
    return [[MQRealmHandler.mq_shared mq_specific:self.specificBase] mq_save:self];
}

- (MQRealmHandler *) mq_delete {
    return [[MQRealmHandler.mq_shared mq_specific:self.specificBase] mq_delete:self];
}
- (MQRealmHandler *) mq_delete_according_to_primary_key {
    return [[MQRealmHandler.mq_shared mq_specific:self.specificBase] mq_delete_promary_key:self];
}
+ (MQRealmHandler *) mq_delete_array : (NSString *) specificDataBase
                               array : (NSArray <__kindof MQRLMBaseModel *> *) array {
    return [[MQRealmHandler.mq_shared mq_specific:specificDataBase] mq_delete_array:array];
}
+ (MQRealmHandler *) mq_delete_all : (NSString *) specificDataBase {
    return [[MQRealmHandler.mq_shared mq_specific:specificDataBase] mq_delete_all];
}

+ (RLMResults *) mq_all : (NSString *) specificDataBase {
    return [[MQRealmHandler.mq_shared mq_specific:specificDataBase] mq_all:self];
}
+ (MQRealmHandler *) mq_notification : (NSString *) specific_database
                              change : (void (^)(RLMResults * results,
                                                 RLMCollectionChange * change,
                                                 NSError * error)) changeN {
    if (__mq_token) {
        [__mq_token invalidate];
        __mq_token = nil;
    }
    __mq_token = [[self mq_all:specific_database] addNotificationBlock:^(RLMResults * _Nullable results, RLMCollectionChange * _Nullable change, NSError * _Nullable error) {
        if (changeN) {
            // change.insertions; // insert
            // change.deletions; // delete
            // change.modifications; // change
            changeN(results , change , error);
        }
    }];
    return MQRealmHandler.mq_shared;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}
- (id)valueForUndefinedKey:(NSString *)key {
    return nil;
}

@end

#endif
