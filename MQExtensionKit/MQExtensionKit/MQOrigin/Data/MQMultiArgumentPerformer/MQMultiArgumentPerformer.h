//
//  MQMultiArgumentPerformer.h
//  MQExtensionKit
//
//  Created by ElwinFrederick on 2018/8/2.
//  Copyright © 2018 ElwinFrederick. All rights reserved.
//

#import <Foundation/Foundation.h>

/// this class is used for perform selector with multi arguments .
// 这个类是用来 使用 perform 方法 来携带多个参数的 .

@interface MQMultiArgumentPerformer : NSObject

/// instance method .// 实例方法
- (instancetype) init_object : (id) obj
                      method : (SEL) selector ;
/// class method . // 静态方法
- (instancetype) init_class : (Class) clz
                     method : (SEL) selector ;

/// array that holds all pointer . // 用来保存 所有 pointer 的数组
@property (nonatomic , strong , readonly) NSPointerArray *array_pointer ;

/// add a pointer argument . // 添加一个 pointer 参数
- (void) mq_add_argument : (void *) argument ;
@property (nonatomic , copy , readonly) MQMultiArgumentPerformer *(^mq_add)(void *);

/// clear NULLs .( cause NULL is also a positive value int pointer array) .
// 清除所有的 NULL (因为 NULL 在 pointer 数组中也是一个有效的值)
- (void) mq_clear_NULLs ;

/// excute . // 执行 .
- (void) mq_excute : (BOOL) is_need_nulls ;

@end
