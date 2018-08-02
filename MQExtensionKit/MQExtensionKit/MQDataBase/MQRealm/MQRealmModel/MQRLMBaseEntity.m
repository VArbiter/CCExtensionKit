//
//  MQRLMBaseEntity.m
//  MQAudioPlayer-Demo
//
//  Created by 冯明庆 on 06/07/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "MQRLMBaseEntity.h"

#if __has_include(<Realm/Realm.h>)

@interface MQRLMBaseEntity ()

@end

static RLMNotificationToken *__mq_token = nil;
static NSString * __specific_database = nil;

@implementation MQRLMBaseEntity

+ (instancetype) mq_common { return [self mq_common_dictionary:nil]; }
+ (instancetype) mq_common_dictionary : (NSDictionary *) dictionary {
    return [MQRealmHandler.mq_shared mq_dictionary:self
                                             value:dictionary];
}
+ (instancetype) mq_common_array : (NSArray *) array {
    return [MQRealmHandler.mq_shared mq_array:self
                                        value:array];
}

+ (void) mq_operate : (void (^)(void)) transaction {
    [MQRealmHandler.mq_shared mq_operate:^{
        if (transaction) transaction();
    }];
}

- (instancetype) mq_save {
    [MQRealmHandler.mq_shared mq_save:self];
    return self;
}

- (void) mq_delete { [MQRealmHandler.mq_shared mq_delete:self]; }
- (void) mq_delete_according_to_primary_key { [MQRealmHandler.mq_shared mq_delete_promary_key:self]; }
+ (void) mq_delete_array : (NSArray <__kindof MQRLMBaseEntity *> *) array { [MQRealmHandler.mq_shared mq_delete_array:array]; }
+ (void) mq_delete_all { [MQRealmHandler.mq_shared mq_delete_array:[self mq_all_array]]; }

+ (RLMResults<MQRLMBaseEntity *> *)mq_all_results { return [MQRealmHandler.mq_shared mq_all:self]; }
+ (NSMutableArray<MQRLMBaseEntity *> *)mq_all_array {
    RLMResults<MQRLMBaseEntity *> * result = [self mq_all_results];
    NSMutableArray *t = [NSMutableArray array];
    for (id temp in result) { if (temp) [t addObject:temp]; }
    return t;
}

+ (void) mq_notification_change : (void (^)(RLMResults * results,
                                            RLMCollectionChange * change,
                                            NSError * error)) change_block {
    if (__mq_token) {
        [__mq_token invalidate];
        __mq_token = nil;
    }
    __mq_token = [[self mq_all_results] addNotificationBlock:^(RLMResults * _Nullable results, RLMCollectionChange * _Nullable change, NSError * _Nullable error) {
        if (change_block) {
            // change.insertions; // insert
            // change.deletions; // delete
            // change.modifications; // change
            change_block(results , change , error);
        }
    }];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}
- (id)valueForUndefinedKey:(NSString *)key { return nil; }

@end

#endif
