//
//  MQCommon.h
//  MQExtensionKit
//
//  Created by Elwinfrederick on 06/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

/// MQExtensionKit Version Number . // MQExtensionKit 版本号 .
#ifndef MQ_EXTENSION_KIT_RELEASE_VERSION_NUMBER
    #define MQ_EXTENSION_KIT_RELEASE_VERSION_NUMBER 4.0.0
#endif

/// storage standard unit size . // 标准储存单元大小
#ifndef MQ_STANDARD_LENGTH
    #define MQ_STANDARD_LENGTH 1024.f
#endif

/// formatStrings. // 格式化字符串
#ifndef MQ_STRING_FORMAT
    #define MQ_STRING_FORMAT(...) [NSString stringWithFormat:__VA_ARGS__]
#endif
#ifndef MQ_STRING
    #define MQ_STRING(_value_) [NSString stringWithFormat:@"%@",(_value_)]
#endif

/// console debug logging // 控制台 debug 输出
#ifndef MQLog
    #if DEBUG
        #define MQLog(fmt , ...) \
                NSLog((@"\n\nMQ_LOG\n\nMQ_FILE :  %s\nMQ_METHOND :  %s\nMQ_LINE :  %d\n" fmt),__FILE__,__func__,__LINE__,##__VA_ARGS__)
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
/// note : USE this macro MQ_NIL_DETECT(_value_) in methods impls // 在方法的实现中使用 MQ(_value_)
/// to ensure non blocks will used by nil . // 来保证 没有 nil 调用 block
#ifndef MQ_NIL_DETECT
    #if DEBUG
        #define MQ_NIL_DETECT(_flag_ , _value_) \
            if (_flag_) { \
                MQLog(@"MQ_NIL_TERMINATION : \n instance that used in MQExtension Kit can't be nil. \n"); \
                NSAssert(_value_ != nil , @"instance can't be nil"); \
            }
    #else
        #define MQ_NIL_DETECT(_flag_ , _value_) /* */
    #endif
#endif

#ifndef MQ_DETECT_DEALLOC
    #if DEBUG
        #define MQ_DETECT_DEALLOC \
            - (void)dealloc { \
                MQLog(@"\n MQ_%@_DEALLOC \n", NSStringFromClass([self class])); \
            }
    #else
        #define MQ_DETECT_DEALLOC /* */
    #endif
#endif

//@interface MQCommon : NSObject
//- (instancetype) init NS_UNAVAILABLE;
//@end

/// sometimes you have to fit muti versions of iOS system // 有时你不得不适应多个 iOS 的版本
/// eg : MQ_Available_C(10.0)
/// returns YES (and recall s) if system version was at least 10.0 // 如果系统版本最小为 10.0 返回 YES , (s 产生回调)
/// retunrns NO (and recall f) if not . // 如果不是 返回 NO , (f 产生回调)
BOOL mq_available(double version);
void mq_available_b(double version , void(^s)(void) , void(^f)(void));

/// operation for debug and release // 测试模式和生产模式的操作
void mq_debug(void (^debug)(void) , void (^release)(void));

/// operation for debug and release , also , can be controlled manually // 可手动操作的 测试模式和生产模式 ,
/// -1 DEBUG , 0 auto , 1 release // -1 测试 , 0 自动 , 1 生产模式
void mq_debug_b(int mark , void (^debug)(void) , void (^release)(void));

/// if is SIMULATOR // 是否是模拟器
BOOL mq_is_simulator(void);
/// recall y if is  , recall n if not . // y 是 , n 不是
void mq_detect_simulator(void (^y)(void) , void (^n)(void));

/// make sure that if a chain has started , // 保证链开始不是空的
/// non 'nil' return for next chain actions . (if does , system will crash immediately (with block)) . // 链中不允许 空存在 , 如果存在 , 会崩溃(在 block 中)
void mq_safe_chain(id object , void (^safe)(id object));

/// @return MB / KB / B . // 返回 MB , KB , B
NSString * mq_size_for_length(NSUInteger i_length);

/// if object == nil , make insure_object replace it .// 如果 object 为 nil , 用 insure_object 替换它.
id mq_default_object(id object , id insure_object);

/// detect if the obj1 is the obj2 on the memory address . // 在内存地址上检测 对象1 和 对象2 是否为同一个对象
BOOL mq_is_object_address_same(id obj_1 , id obj_2);
/// for the hashable objects , whether if the obj1 has the same with obj2. (can be different objects) . more specificlly , if you override the method "isEqual:" of given obj , this func will not be recommended to use . //  对于可哈希的对象 , 对象1 是否和 对象2 拥有相同的值. (可以是不同的对象) 如果你重写了 给出的 obj 的 "isEqual:" 方法 , 这个函数就不被推荐使用了 .
BOOL mq_is_object_hash_same(id obj_1 , id obj_2);

/// detect whether if an obj (can be a class) is subclass / subclass.object of a specific class . // 判定对象(可以是类对象)是否是一个类的 子类 / 子类的对象
BOOL mq_is_object_subclass_of(id obj , Class clz);

/// detect whether if an obj (can be a class) is same or subclass or subclass.object of a specific class . more specificlly , if you override the method "isEqual:" of given obj , this func will not be recommended to use .// 判定对象(可以是类对象)是否和指定的 类 相同 / 子类 / 子类的对象 . 如果你重写了 给出的 obj 的 "isEqual:" 方法 , 这个函数就不被推荐使用了 .
BOOL mq_is_object_kind_of_class(id obj , Class clz);
