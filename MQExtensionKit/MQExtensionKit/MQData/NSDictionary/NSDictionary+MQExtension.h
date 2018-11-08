//
//  NSDictionary+MQExtension.h
//  MQExtensionKit
//
//  Created by 冯明庆 on 2017/4/20.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (MQExtension)

// only the object that inherit from NSObject (in Foundation framework) allowed . // 只有继承自 NSObject (Foundation 框架) 的被允许 .
@property (nonatomic , readonly) NSString * to_json;
@property (nonatomic , readonly) NSData * to_data;
+ (instancetype) mq_json : (NSString *) s_json ;

@end

#pragma mark - -----

@interface NSMutableDictionary <KeyType , ObjectType> (MQExtension)

- (instancetype) mq_set : (KeyType) key
                  value : (ObjectType) value ;

/// set key && value with observer // 使用 观察者 来添加 key 和 value
/// note : need to implementated the observers down blow first. // 需要首先实现下方的监听者
- (instancetype) mq_set_with_observer : (KeyType) key
                                value : (ObjectType) value ;

- (instancetype) mq_observer : (void (^)(KeyType key , ObjectType value)) action ;
- (instancetype) mq_observer_t : (void (^)(void(^t)(KeyType key , ObjectType value , NSArray <KeyType> * all_keys , NSArray <ObjectType> * all_values))) action ;

@end
