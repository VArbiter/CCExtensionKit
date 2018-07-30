//
//  NSDictionary+MQExtension.h
//  MQExtensionKit
//
//  Created by 冯明庆 on 2017/4/20.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (MQExtension)

@property (nonatomic , readonly) NSString * to_json;
+ (instancetype) mq_json : (NSString *) s_json ;

@end

#pragma mark - -----

@interface NSMutableDictionary (MQExtension)

- (instancetype) mq_set : (id) key
                  value : (id) value ;

/// set key && value with observer // 使用 观察者 来添加 key 和 value
/// note : need to implementated the observers down blow first. // 需要首先实现下方的监听者
- (instancetype) mq_set_with_observer : (id) key
                                value : (id) value ;

- (instancetype) mq_observer : (void (^)(id key , id value)) action ;
- (instancetype) mq_observer_t : (void (^)(void(^t)(id key , id value , NSArray * a_all_keys , NSArray * a_all_values))) action ;

@end