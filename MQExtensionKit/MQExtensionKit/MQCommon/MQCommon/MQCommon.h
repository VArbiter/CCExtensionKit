//
//  MQCommon.h
//  MQExtensionKit
//
//  Created by Elwinfrederick on 06/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

/// storage standard unit size . // 标准储存单元大小
#ifndef MQ_STANDARD_LENGTH
    #define MQ_STANDARD_LENGTH 1024.f
#endif

/// if is simulator . // 判定是否是模拟器
#ifndef _MQ_IS_SIMULATOR_
    #if TARGET_IPHONE_SIMULATOR
        #define _MQ_IS_SIMULATOR_ 1
    #else
        #define _MQ_IS_SIMULATOR_ 0
    #endif
#endif

/// formatStrings. // 格式化字符串
#ifndef MQ_STRING_FORMAT
    #define MQ_STRING_FORMAT(...) [NSString stringWithFormat:__VA_ARGS__]
#endif
#ifndef MQ_STRING
    #define MQ_STRING(_value_) [NSString stringWithFormat:@"%@",(_value_)]
#endif

/// manually control debug mode . // 手动控制 debug 模式
/// returns 1 if debug , 0 if release. // 1 是 debug , 0 是 release
#ifndef _MQ_DEBUG_MODE_
    #if DEBUG
        #define _MQ_DEBUG_MODE_ 1
    #else
        #define _MQ_DEBUG_MODE_ 0
    #endif
#endif

/// detect if an nil in chain has occur . // 检测链中是否有 nil 存在
/// set to 1 to enable  , 0 for mute . // 1 启用 , 0 禁用
/// default is 1 (in DEBUG MODE) (enable) . // 默认 1 在 debug 模式中启用
#ifndef _MQ_NIL_ASSERT_ENABLE_
    #if _MQ_DEBUG_MODE_
        #define _MQ_NIL_ASSERT_ENABLE_ 1
    #else
        #define _MQ_NIL_ASSERT_ENABLE_ 0
    #endif
#endif

/// console debug logging // 控制台 debug 输出
#ifndef MQLog
    #if _MQ_DEBUG_MODE_
        #define MQLog(fmt , ...) \
            NSLog((@"\n\n_MQ_LOG_\n\n_MQ_FILE_  %s\n_MQ_METHOND_  %s\n_MQ_LINE_  %d\n" fmt),__FILE__,__func__,__LINE__,##__VA_ARGS__)
    #else
        #define MQLog(fmt , ...) /* */
    #endif
#endif

/// returns another same value // 返回另一个相同的值
#ifndef MQ_SAME
    #define MQ_SAME(_value_) typeof(_value_) same_##_value_ = _value_
#endif

/// weak instance on arc // arc 下的弱引用
#ifndef MQ_WEAK_INSTANCE
    #define MQ_WEAK_INSTANCE(_value_) __unsafe_unretained typeof(_value_) weak_##_value_ = _value_
#endif

/// shortcut to weak self . // weak self 的便捷宏
#ifndef MQ_WEAK_SELF
    #define MQ_WEAK_SELF __weak typeof(&*self) weak_self = self
#endif

/// only applied for those named weak_self . // 只针对那些命名为 weak_self 的 self .
#ifndef MQ_STRONG_SELF
    #define MQ_STRONG_SELF __strong typeof(weak_self) strong_self = weak_self
#endif

/// transfer to a specific type by force. // 强制转换为一个特定类型 (不同类型会崩溃 , 这里多用于 id 转换为指定类型)
#ifndef MQ_TYPE
    #define MQ_TYPE(_type_ , _value_) ((_type_)_value_)
#endif

/// prevent if an nil occur and caused blocks crash // 防止 nil 导致 block 崩溃
/// note : if blocks was used by nil , app will went crash (EXC_BAD_ACCESS) // 如果 使用 nil 调用了 block , 应用程序会崩溃 (EXC_BAD_ACCESS)
/// note : USE this macro MQ(_value_) in methods impls // 在方法的实现中使用 MQ(_value_)
/// to ensure non blocks will used by nil . // 来保证 没有 nil 调用 block
#ifndef MQ
    #if _MQ_DEBUG_MODE_
        #define MQ(_value_) \
            if (_MQ_NIL_ASSERT_ENABLE_) { \
                MQLog(@"_MQ_NIL_TERMINATION_\n instance that used in MQExtension Kit can't be nil. \n"); \
                NSAssert(_value_ != nil , @"instance can't be nil"); \
            } \
            if (_value_ && [_value_ conformsToProtocol:@protocol(MQExtensionProtocol)]) ([_value_ mq])
    #else
        #define MQ(_value_) \
            if (_value_ && [_value_ conformsToProtocol:@protocol(MQExtensionProtocol)]) ([_value_ mq])
    #endif
#endif

#ifndef _MQ_DETECT_DEALLOC_
    #if _MQ_DEBUG_MODE_
        #define _MQ_DETECT_DEALLOC_ \
            - (void)dealloc { \
                MQLog(@"_MQ_%@_DEALLOC_", NSStringFromClass([self class])); \
            }
    #else
        #define _MQ_DETECT_DEALLOC_ /* */
    #endif
#endif

@interface MQCommon : NSObject

- (instancetype) init NS_UNAVAILABLE;

/// returns uuid // 返回 UUID
NSString * _MQ_UUID_(void);

/// notify you whether this operation was excuted on main thread . // 通知你这个操作是否是在主线程执行
/// returns if this operation was excuted on main thread . // 返回这个任务是否是在主线程执行
BOOL MQ_IS_MAIN_QUEUE(void);

/// sometimes you have to fit muti versions of iOS system // 有时你不得不适应多个 iOS 的版本
/// eg : MQ_Available_C(10.0)
/// returns YES (and recall s) if system version was at least 10.0 // 如果系统版本最小为 10.0 返回 YES , (s 产生回调)
/// retunrns NO (and recall f) if not . // 如果不是 返回 NO , (f 产生回调)
BOOL MQ_Available_C(double version);
void MQ_Available_S(double version , void(^s)(void) , void(^f)(void));

/// if not in the main thread, operation will sync to it. // 如果不在主线程 , 操作会同步到主线程
void MQ_Main_Thread_Sync(void (^)(void));
/// if not in the main thread, operation will async to it. // 如果不在主线程 , 操作会异步到主线程
void MQ_Main_Thread_Async(void (^)(void));

/// operation for debug and release // 测试模式和生产模式的操作
void MQ_DEBUG(void (^debug)(void) , void (^release)(void));

/// operation for debug and release , also , can be controlled manually // 可手动操作的 测试模式和生产模式 ,
/// -1 DEBUG , 0 auto , 1 release // -1 测试 , 0 自动 , 1 生产模式
void MQ_DEBUG_M(int mark , void (^debug)(void) , void (^release)(void));

/// if is SIMULATOR // 是否是模拟器
/// recall y if is  , recall n if not . // y 是 , n 不是
void MQ_DETECT_SIMULATOR(void (^y)(void) , void (^n)(void));

/// make sure that if a chain has started , // 保证链开始不是空的
/// non 'nil' return for next chain actions . (if does , system will crash immediately (with block)) . // 链中不允许 空存在 , 如果存在 , 会崩溃(在 block 中)
void MQ_SAFED_CHAIN(id object , void (^safe)(id object));

/// @return MB / KB / B . // 返回 MB , KB , B
NSString * MQ_SIZE_FOR_LENGTH(NSUInteger i_length);

/// if object == nil , make insure_object replace it .// 如果 object 为 nil , 用 insure_object 替换它.
id MQ_Default_Object(id object , id insure_object);

@end
