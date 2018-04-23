//
//  NSDictionary+CCExtension.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/20.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (CCExtension)

@property (nonatomic , readonly) NSString * toJson;
+ (instancetype) cc_json : (NSString *) sJson ;

@end

#pragma mark - -----

@interface NSMutableDictionary (CCExtension)

- (instancetype) cc_set : (id) key
                  value : (id) value ;

/// set key && value with observer // 使用 观察者 来添加 key 和 value
/// note : need to implementated the observers down blow first. // 需要首先实现下方的监听者
- (instancetype) cc_set_with_observer : (id) key
                                value : (id) value ;

- (instancetype) cc_observer : (void (^)(id key , id value)) action ;
- (instancetype) cc_observer_t : (void (^)(void(^t)(id key , id value , NSArray * aAllKeys , NSArray * aAllValues))) action ;

@end
