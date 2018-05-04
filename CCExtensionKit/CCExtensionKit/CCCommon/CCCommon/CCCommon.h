//
//  CCCommon.h
//  CCLocalLibrary
//
//  Created by Elwinfrederick on 06/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

/// if is simulator . // 判定是否是模拟器
#ifndef _CC_IS_SIMULATOR_
    #if TARGET_IPHONE_SIMULATOR
        #define _CC_IS_SIMULATOR_ 1
    #else
        #define _CC_IS_SIMULATOR_ 0
    #endif
#endif

/// formatStrings. // 格式化字符串
#ifndef ccStringFormat
    #define ccStringFormat(...) [NSString stringWithFormat:__VA_ARGS__]
#endif
#ifndef ccString
    #define ccString(_value_) [NSString stringWithFormat:@"%@",(_value_)]
#endif

/// manually control debug mode . // 手动控制 debug 模式
/// returns 1 if debug , 0 if release. // 1 是 debug , 0 是 release
#ifndef _CC_DEBUG_MODE_
    #if DEBUG
        #define _CC_DEBUG_MODE_ 1
    #else
        #define _CC_DEBUG_MODE_ 0
    #endif
#endif

/// detect if an nil in chain has occur . // 检测链中是否有 nil 存在
/// set to 1 to enable  , 0 for mute . // 1 启用 , 0 禁用
/// default is 1 (in DEBUG MODE) (enable) . // 默认 1 在 debug 模式中启用
#ifndef _CC_NIL_ASSERT_ENABLE_
    #if _CC_DEBUG_MODE_
        #define _CC_NIL_ASSERT_ENABLE_ 1
    #else
        #define _CC_NIL_ASSERT_ENABLE_ 0
    #endif
#endif

/// console debug logging // 控制台 debug 输出
#ifndef CCLog
    #if _CC_DEBUG_MODE_
        #define CCLog(fmt , ...) \
            NSLog((@"\n\n_CC_LOG_\n\n_CC_FILE_  %s\n_CC_METHOND_  %s\n_CC_LINE_  %d\n" fmt),__FILE__,__func__,__LINE__,##__VA_ARGS__)
    #else
        #define CCLog(fmt , ...) /* */
    #endif
#endif

/// returns another same value // 返回另一个相同的值
#ifndef CC_SAME
    #define CC_SAME(_value_) typeof(_value_) same_##_value_ = _value_
#endif

/// weak instance on arc // arc 下的弱引用
#ifndef CC_WEAK_INSTANCE
    #define CC_WEAK_INSTANCE(_value_) __unsafe_unretained typeof(_value_) weak_##_value_ = _value_
#endif

/// shortcut to weak self . // weak self 的便捷宏
#ifndef CC_WEAK_SELF
    #define CC_WEAK_SELF __weak typeof(&*self) weak_self = self
#endif

/// transfer to a specific type by force. // 强制转换为一个特定类型 (不同类型会崩溃 , 这里多用于 id 转换为指定类型)
#ifndef CC_TYPE
    #define CC_TYPE(_type_ , _value_) ((_type_)_value_)
#endif

/// prevent if an nil occur and caused blocks crash // 防止 nil 导致 block 崩溃
/// note : if blocks was used by nil , app will went crash (EXC_BAD_ACCESS) // 如果 使用 nil 调用了 block , 应用程序会崩溃 (EXC_BAD_ACCESS)
/// note : USE this macro CC(_value_) in methods impls // 在方法的实现中使用 CC(_value_)
/// to ensure non blocks will used by nil . // 来保证 没有 nil 调用 block
#ifndef CC
    #if _CC_DEBUG_MODE_
        #define CC(_value_) \
            if (_CC_NIL_ASSERT_ENABLE_) { \
                CCLog(@"_CC_NIL_TERMINATION_\n instance that used in CCExtension Kit can't be nil. \n"); \
                NSAssert(_value_ != nil , @"instance can't be nil"); \
            } \
            if (_value_ && [_value_ conformsToProtocol:@protocol(CCExtensionProtocol)]) ([_value_ cc])
    #else
        #define CC(_value_) \
            if (_value_ && [_value_ conformsToProtocol:@protocol(CCExtensionProtocol)]) ([_value_ cc])
    #endif
#endif

#ifndef _CC_DETECT_DEALLOC_
    #if _CC_DEBUG_MODE_
        #define _CC_DETECT_DEALLOC_ \
            - (void)dealloc { \
                CCLog(@"_CC_%@_DEALLOC_", NSStringFromClass([self class])); \
            }
    #else
        #define _CC_DETECT_DEALLOC_ /* */
    #endif
#endif

@interface CCCommon : NSObject

- (instancetype) init NS_UNAVAILABLE;

/// returns uuid // 返回 UUID
NSString * _CC_UUID_(void);

/// notify you whether this operation was excuted on main thread . // 通知你这个操作是否是在主线程执行
/// returns if this operation was excuted on main thread . // 返回这个任务是否是在主线程执行
BOOL CC_IS_MAIN_QUEUE(void);

/// sometimes you have to fit muti versions of iOS system // 有时你不得不适应多个 iOS 的版本
/// eg : CC_Available_C(10.0)
/// returns YES (and recall s) if system version was at least 10.0 // 如果系统版本最小为 10.0 返回 YES , (s 产生回调)
/// retunrns NO (and recall f) if not . // 如果不是 返回 NO , (f 产生回调)
BOOL CC_Available_C(double version);
void CC_Available_S(double version , void(^s)(void) , void(^f)(void));

/// if not in the main thread, operation will sync to it. // 如果不在主线程 , 操作会同步到主线程
void CC_Main_Thread_Sync(void (^)(void));
/// if not in the main thread, operation will async to it. // 如果不在主线程 , 操作会异步到主线程
void CC_Main_Thread_Async(void (^)(void));

/// operation for debug and release // 测试模式和生产模式的操作
void CC_DEBUG(void (^debug)(void) , void (^release)(void));

/// operation for debug and release , also , can be controlled manually // 可手动操作的 测试模式和生产模式 ,
/// -1 DEBUG , 0 auto , 1 release // -1 测试 , 0 自动 , 1 生产模式
void CC_DEBUG_M(int mark , void (^debug)(void) , void (^release)(void));

/// if is SIMULATOR // 是否是模拟器
/// recall y if is  , recall n if not . // y 是 , n 不是
void CC_DETECT_SIMULATOR(void (^y)(void) , void (^n)(void));

/// make sure that if a chain has started , // 保证链开始不是空的
/// non 'nil' return for next chain actions . (if does , system will crash immediately (with block)) . // 链中不允许 空存在 , 如果存在 , 会崩溃(在 block 中)
void CC_SAFED_CHAIN(id object , void (^safe)(id object));

@end
