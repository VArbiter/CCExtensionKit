//
//  MQExtensionConst.h
//  MQExtensionKit
//
//  Created by 冯明庆 on 2019/2/21.
//  Copyright © 2019 ElwinFrederick. All rights reserved.
//

//#import <Foundation/Foundation.h>

//NS_ASSUME_NONNULL_BEGIN
//@interface MQExtensionConst : NSObject
//@end
//NS_ASSUME_NONNULL_END

// used for deprecated method . // 弃用方法
#ifndef MQ_EXTENSION_DEPRECATED
    #define MQ_EXTENSION_DEPRECATED(_value_) __attribute__((deprecated(_value_)));
#endif

/// storage standard unit size . // 标准储存单元大小
#ifndef MQ_STANDARD_LENGTH_IN_IOS
    #define MQ_STANDARD_LENGTH_IN_IOS 1000
#endif
#ifndef MQ_STANDARD_LENGTH
    #define MQ_STANDARD_LENGTH 1024
#endif




