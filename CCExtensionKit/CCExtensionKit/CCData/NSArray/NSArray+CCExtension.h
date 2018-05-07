//
//  NSArray+CCExtension.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/19.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (CCExtension)

// only the object that inherit from NSObject (in Foundation framework) allowed . // 只有继承自 NSObject (Foundation 框架) 的被允许 .
@property (nonatomic , readonly) NSString * toJson;
@property (nonatomic , readonly) NSData * toData;

- (id) cc_value_at : (NSInteger) index ;

@end

#pragma mark - -----

typedef NS_ENUM(NSInteger, CCArrayChangeType) {
    CCArrayChangeTypeNone = 0 ,
    CCArrayChangeTypeAppend ,
    CCArrayChangeTypeRemoved
};

struct CCArrayChangeInfo {
    CCArrayChangeType type ;
    long long count ;
};
typedef struct CCArrayChangeInfo CCArrayChangeInfo;

@interface NSMutableArray (CCExtension)

- (instancetype) cc_add : (id) value ;
- (instancetype) cc_remove_t : (id) value ;
- (instancetype) cc_remove_all_t ;
- (instancetype) cc_remove_at : (NSUInteger) i_index ;

- (instancetype) cc_type : (NSString *) cls ;
- (instancetype) cc_append : (id) value ;
/// if value is an collection , decided to add objects from it or use collection as a complete object . // 如果 value 是集合 , 决定是否展开添加
/// note : only for value is an array kind . // 只是在 value 是数组的时候
- (instancetype) cc_append : (id)value
                    expand : (BOOL) isExpand ;
- (instancetype) cc_remove : (id) value ;
- (instancetype) cc_remove_all : (BOOL (^)(BOOL isCompare , id obj)) action ;

/// Observers , like all observers , need added before it used . // 监听者 , 就像所有的监听者那样 , 需要先实现 , 再使用 
- (instancetype) cc_change : (void (^)(id value , CCArrayChangeInfo type)) action ;
- (instancetype) cc_complete : (void (^)(CCArrayChangeInfo type)) action ;

@end
