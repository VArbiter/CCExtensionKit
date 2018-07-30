//
//  NSArray+MQExtension.h
//  MQExtensionKit
//
//  Created by 冯明庆 on 2017/4/19.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (MQExtension)

// only the object that inherit from NSObject (in Foundation framework) allowed . // 只有继承自 NSObject (Foundation 框架) 的被允许 .
@property (nonatomic , readonly) NSString * to_json;
@property (nonatomic , readonly) NSData * to_data;

- (id) mq_value_at : (NSInteger) index ;

@end

#pragma mark - -----

typedef NS_ENUM(NSInteger, MQArrayChangeType) {
    MQArrayChangeTypeNone = 0 ,
    MQArrayChangeTypeAppend ,
    MQArrayChangeTypeRemoved
};

struct MQArrayChangeInfo {
    MQArrayChangeType type ;
    long long count ;
};
typedef struct MQArrayChangeInfo MQArrayChangeInfo;

@interface NSMutableArray (MQExtension)

- (instancetype) mq_add : (id) value ;
- (instancetype) mq_add_array : (id) value ;
- (instancetype) mq_remove_t : (id) value ;
- (instancetype) mq_remove_all_t ;
- (instancetype) mq_remove_at : (NSUInteger) i_index ;

- (instancetype) mq_type : (NSString *) cls ;
- (instancetype) mq_append : (id) value ;
/// if value is an collection , decided to add objects from it or use collection as a complete object . // 如果 value 是集合 , 决定是否展开添加
/// note : only for value is an array kind . // 只是在 value 是数组的时候
- (instancetype) mq_append : (id)value
                    expand : (BOOL) isExpand ;
- (instancetype) mq_remove : (id) value ;
- (instancetype) mq_remove_all : (BOOL (^)(BOOL isCompare , id obj)) action ;

/// Observers , like all observers , need added before it used . // 监听者 , 就像所有的监听者那样 , 需要先实现 , 再使用 
- (instancetype) mq_change : (void (^)(id value , MQArrayChangeInfo type)) action ;
- (instancetype) mq_complete : (void (^)(MQArrayChangeInfo type)) action ;

@end
