//
//  CCTaskManager.h
//  MQExtensionKit
//
//  Created by ElwinFrederick on 2018/6/25.
//  Copyright © 2018 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CCTaskObject , CCTaskManager;

@protocol CCTaskManagerDelegate < NSObject >

@required

/**
 for excute tasks . // 执行任务用

 @param manager CCTaskManager
 @param mq_excute_block block excute // 执行块儿
 */
- (void) mq_task_manager : (CCTaskManager *) manager
     excute_current_task : (void (^)(BOOL is_error_occured , BOOL is_continue)) mq_excute_block ;

@end

@interface CCTaskManager : NSObject

- (instancetype) init_with_async_thread : (dispatch_queue_t) queue;
@property (nonatomic , assign) id < CCTaskManagerDelegate > delegate_t ;

@property (nonatomic , readonly) dispatch_queue_t queue_current ;

@property (nonatomic , strong , readonly) NSMutableArray <CCTaskObject *> *array_tasks ;

/// note : adding tasks will resume (if paused) the tasks .
- (void) mq_add_tasks : (NSArray < __kindof CCTaskObject *> *) objects
        remain_status : (BOOL) is_remain ;
- (void) mq_add_task : (__kindof CCTaskObject *) object
       remain_status : (BOOL) is_remain ;

- (void) mq_start;
- (void) mq_pause ;
- (void) mq_resume ;
- (void) mq_finish ;

@end

@interface CCTaskObject : NSObject

/// in a task queue , you must have a unique task id and object. // 你必须拥有一个 task id 和 object
/// otherwise , task object will generate failed . // 否则 task object 会生成失败
- (instancetype)init_id : (NSString *) s_task_id
               position : (NSUInteger) i_task_position
                 object : (id) object ;

/// a task's unique identifier (in one queue)
@property (nonatomic , copy) NSString *s_task_id ;
/// a task's excute postion (in one queue) 
@property (nonatomic , assign) NSUInteger i_task_position ;
/// an object for excute (NSURL , NSURLSessionDataTask , block , string ...... anyting has object feature)
/// 等待被执行 的 object (NSURL , NSURLSessionDataTask , block , string ...... 任何有 对象 特征的)
@property (nonatomic , strong) id object_t ;

@end
