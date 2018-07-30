//
//  MQProxyDealer.h
//  MQExtensionKit
//
//  Created by Elwinfrederick on 15/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef _MQ_PROXY_DELER_PROTOCOL_TEST_EXAMPLE_
    #define _MQ_PROXY_DELER_PROTOCOL_TEST_EXAMPLE_
#endif

#ifdef _MQ_PROXY_DELER_PROTOCOL_TEST_EXAMPLE_

/// simply simulat the muti-inhert of objective-C // 在 OC 中模仿多继承
/// note : if you want that MQProxyDealer to simulate the muti-inhert values // 如果你想使用 MQProxyDealer 来模仿多继承
///     all your methods must be instance and interface in a protocol // 所有方法必须在 一个协议中声明
/// eg :
///
/// @@protocol MQTestProtocol : <NSObject>
/// - (void) testMethod ;
/// @end
///
/// @interface MQSomeClass : NSObject < MQTestProtocol >
/// @end
///
/// @implementation MQSomeClass
///
/// - (void) testMethod {/* do sth. */}
///
/// @end

@interface MQProxyDealer : NSProxy

/// it's not a singleton . // 不是单例
+ (instancetype) common ;
+ (instancetype) common : (NSArray <id> *) arrayTarget ;

/// regist targets , only instance methods allowed (MQProxyDealer is an instance) // 注册目标 , 只有对象被允许
- (instancetype) mq_regist_methods : (NSArray <id> *) arrayTarget ;

@end

#endif
