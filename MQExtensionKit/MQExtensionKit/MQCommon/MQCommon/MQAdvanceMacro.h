//
//  MQAdvanceMacro.h
//  MQExtensionKit
//
//  Created by 冯明庆 on 11/09/2017.
//  Copyright © 2017 ElwinFrederick. All rights reserved.
//

#ifndef MQAdvanceMacro_h
#define MQAdvanceMacro_h

/*
    see @weakify && @strongify in 'React Native' .
 */
#ifndef MQ_KEYWORDIFY
    #if DEBUG
        #define MQ_KEYWORDIFY @autoreleasepool {}
    #else
        #define MQ_KEYWORDIFY @try {} @catch (...) {}
    #endif
#endif

/// if implement this macro . // 如果引入了这个 宏
/// the actions in this block can be executed when an litetime is dying . // 这个 block 将会在一个生命周期结束的时候执行
/// note : this actions obey the stack in-out order . // 动作遵循栈的顺序
/// note : which is first in , last out. // 即为 , 先进后出
#ifndef MQ_ON_EXIT
    static inline void MQ_ON_EXIT_BLOCK(__strong void(^*block)(void)) {
        (*block)();
    }
    #define MQ_ON_EXIT \
    MQ_KEYWORDIFY __strong void(^MQ_ON_EXIT_BLOCK)(void) __attribute__((cleanup(MQ_ON_EXIT_BLOCK), unused)) = ^
#endif

/// add this to your method tail , // 在方法后添加这个
/// it will warn you when some return value that want-to be used . // 可以警告你这个你想使用的 value 没有使用
#ifndef MQ_WARN_UNUSED_RESULT
    #define MQ_WARN_UNUSED_RESULT __attribute__((warn_unused_result))
#endif

/// make c functions can be overloaded like the same function in java. // 允许 c 函数可以像 java 那样被重载
#ifndef MQ_OVERLOADABLE_FUNCTION
    #define MQ_OVERLOADABLE_FUNCTION __attribute__((overloadable))
#endif

/// used for c-type functions , only worked when params && return value type both are basic types . // 用于 c 函数 , 只针对参数和返回类型都是基本数据类型的
/// use it between return value type and function names : // 在返回值和函数名中间使用
/// eg : int MQ_CONST_FUNCTION add(int , int)
/// note : compliar will only and always return the first time calculate value . // 编译器仅仅且一直返回第一次它计算出的值
/// note : return value only depended on input params . // 返回值依赖输入的参数
/// note : this macro only fit with const functions and no side-effect functions . // 这个宏仅仅针对 常量 函数和没有 其它效果 的函数
/// note : and also , not-allowed of all params and return values . // 并且 , 不是所有的参数和返回值都被允许的
#ifndef MQ_CONST_FUNCTION
    #define MQ_CONST_FUNCTION __attribute__((const))
#endif

/// used to decorate the c-functions (c-functions only) // 用来修饰 C 函数
/// excute before main was intialized . // 在 main 函数前初始化
/// note : if specific '_priority_' , the functions will execute in the level you gave (and counted destructor). // 如果指定 '_priority_' , 这个函数将会在你指定的级别内执行 , 并且算入 销毁器中
/// note : '_priority_' must be int , and not less than 100 (1~100 was remained by system). // '_priority_' 必须是 int 类型 , 而且不小于 100 (1~100 为系统所保留)
/// note : the lesser '_priority_' is , the higher priority it has . // '_priority_' 的值越小 , 优先级越高
#ifndef MQ_AFTER_LOADING
    #define MQ_AFTER_LOADING __attribute__((constructor))
    #define MQ_AFTER_LOADING_PRIORITY(_priority_) __attribute__((constructor(##_priority_)))
#endif

/// used to decorate the c-functions (c-functions only) // 仅仅只能用来修饰 C 函数
/// excute after main was finished . // 在 main 函数执行完毕后执行
/// note : if specific '_priority_' , the functions will execute in the level you gave (and counted constructor). // 如果指定 '_priority_' , 这个函数将会在你指定的级别内执行 , 并且算入 销毁器中
#ifndef MQ_DEAD_LAST_END
    #define MQ_DEAD_LAST_END __attribute__((destructor))
    #define MQ_DEAD_LAST_END_PRIORITY(_priority_) __attribute__((destructor(##_priority_)))
#endif

/// for c-type functions that not required to have a return value . // 针对 C 函数不要求返回值的情况
#ifndef MQ_NO_RETURN
    #define MQ_NO_RETURN __attribute__((noreturn))
#endif

/// force compliar use its' maximum strength // 强制要求编译器使用最大长度进行字节对齐
/// to align with a specific size when vars (in struct) get an mem-address.
#ifndef MQ_STRUCT_ALIGNED
    #define MQ_STRUCT_ALIGNED __attribute__((aligned))
    #define MQ_STRUCT_ALIGNED_SIZE(_value_) __attribute__((aligned(##_value_)))
#endif

/// when used for stuct or union , it will make a memory constraint on each variable . // 如果是用结构体或共用体 , 它会是的内存紧贴变量
/// when used it for enum type , if indicates that should be used for the minimum size of a complete type . // 当真对枚举使用 , 他会推测一个最小使用限度
/// note : MQ_STRUCT_ALIGNED takes more spaces , MQ_STRUCT_PACKED take lesser space cpmpare to MQ_STRUCT_ALIGNED . // MQ_STRUCT_ALIGNED 会花费较多内存空间 . 相比下 MQ_STRUCT_PACKED 花费较少
#ifndef MQ_STRUCT_PACKED
    #define MQ_STRUCT_PACKED __attribute__((__packed__))
#endif

/// make sure that a class can't be subclassed // 使得一个类不能被继承
/// forbidden all inhert actions . // 禁止所有的继承行为
/// eg :
/// MQ_FINAL
/// @interface : FinalClass
/// @end
#ifndef MQ_FINAL
    #if defined(__has_attribute) && __has_attribute(objc_subclassing_restricted)
        # define MQ_FINAL __attribute__((objc_subclassing_restricted))
    #else
        # define MQ_FINAL
    #endif
#endif

/// make a new name for a class during runtime . // 动态为类更名
/// in some project , if using random strings for classes , it just simply help you to mixed codes . // 在一些工程中 , 如果使用动态随机字符串来进行命名 , 那么 , 这个宏可以帮你完成简单的代码混淆
/// note : prefix can be numbers . // 前缀可以是数字
/// note : '_name_' can be a C-function (runable && return value as UTF8 string) .
#ifndef MQ_RUNTIME_NAME
    #define MQ_RUNTIME_NAME(_name_) __attribute__((objc_runtime_name(_name_)))
#endif

#endif /* MQAdvanceMacro_h */
