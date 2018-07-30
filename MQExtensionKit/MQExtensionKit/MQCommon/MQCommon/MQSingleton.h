//
//  MQSingleton.h
//  MQExtensionKit
//
//  Created by Elwinfrederick on 10/08/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#ifndef MQSingleton_h
    #define MQSingleton_h

    /// absolute singleton // 绝对单例

    // ARC
    #if __has_feature(objc_arc)
        #define mq_SingletonInterface(name)  +(instancetype)mq_shared##name
        #define mq_SingletonImplementation(name)  +(instancetype)mq_shared##name \
        { \
            id instance = [[self alloc] init]; \
            return instance; \
        } \
    \
        static id _instance = nil; \
    \
        + (instancetype)allocWithZone:(struct _NSZone *)zone { \
            static dispatch_once_t onceToken; \
            dispatch_once(&onceToken, ^{ \
                _instance = [[super allocWithZone:zone] init]; \
            }); \
            return _instance; \
        } \
    \
        - (id)copyWithZone:(NSZone *)zone { \
            return _instance; \
        } \
    \
        - (id)mutableCopyWithZone:(NSZone *)zone { \
            return _instance; \
        }
    #endif

#endif /* MQSingleton_h */
