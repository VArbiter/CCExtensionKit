//
//  MQProxyDealerMacro.h
//  MQExtensionKit
//
//  Created by Elwinfrederick on 15/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#ifndef MQProxyDealerMacro_h
#define MQProxyDealerMacro_h

/// simply simulat the muti-inhert of objective-C
/// note : if you want that MQProxyDealer to simulate the muti-inhert values
///     all your methods must be instance and interface in a protocol
/// note : and be sure do "#import <objc/runtime.h>" in your implementation file
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

#ifndef MQ_PROXY_DEALER_PROTOCOL_HOLDER
    #define MQ_PROXY_DEALER_PROTOCOL_HOLDER MQProxyHolderProtocol
    @protocol MQ_PROXY_DEALER_PROTOCOL_HOLDER <NSObject>
    @end
#endif

#ifndef MQ_PROXY_DEALER_INTERFACE
    /// name , protocols that want to be simulated // 名称 , 想被模仿的协议

    #define MQ_PROXY_DEALER_INTERFACE(_name_ , ...) \
\
    @interface MQProxy_t_##_name_ : NSProxy < MQ_PROXY_DEALER_PROTOCOL_HOLDER , ##__VA_ARGS__ > \
        + (instancetype) common ; \
        + (instancetype) common : (NSArray <id> *) arrayTarget ; \
        - (instancetype) mq_regist_methods : (NSArray <id> *) arrayTarget ; \
    @end
        
#endif

#ifndef MQ_PROXY_DEALER_IMPLEMENTATION
    /// name , it should be the name that passing though MQ_PROXY_DEALER_INTERFACE. // 名称 , 应该是 传入 MQ_PROXY_DEALER_INTERFACE 的

    #define MQ_PROXY_DEALER_IMPLEMENTATION(_name_) \
\
    @interface MQProxy_t_##_name_  () \
        @property (nonatomic , strong) NSMutableDictionary *dMapMethods ; \
    @end \
\
    @implementation MQProxy_t_##_name_ \
    + (instancetype) common { \
        return [[self alloc] init]; \
    } \
    + (instancetype) common : (NSArray <id> *) arrayTarget { \
        return [[self common] mq_regist_methods:arrayTarget]; \
    } \
\
    - (instancetype) mq_regist_methods : (NSArray <id> *) arrayTarget { \
        for (id t in arrayTarget) { \
            unsigned int iMethods = 0; \
            Method *methodList = class_copyMethodList([t class], &iMethods); \
            for (int i = 0; i < iMethods; i ++) { \
                Method tMethod = methodList[i]; \
                SEL tSel = method_getName(tMethod); \
                const char *tMethodName = sel_getName(tSel); \
                [self.dMapMethods setObject:t \
                                     forKey:[NSString stringWithUTF8String:tMethodName]]; \
            } \
            free(methodList); \
        } \
        return self; \
    } \
\
    - (void)forwardInvocation:(NSInvocation *)invocation { \
        SEL sel = invocation.selector; \
        NSString *sMethodName = NSStringFromSelector(sel); \
        id target = self.dMapMethods[sMethodName]; \
        if (target && [target respondsToSelector:sel]) [invocation invokeWithTarget:target]; \
        else [super forwardInvocation:invocation]; \
    } \
\
    - (NSMethodSignature *)methodSignatureForSelector:(SEL)sel { \
        NSString *sMethodName = NSStringFromSelector(sel); \
        id target = self.dMapMethods[sMethodName]; \
        if (target && [target respondsToSelector:sel]) return [target methodSignatureForSelector:sel]; \
        else return [super methodSignatureForSelector:sel]; \
    } \
\
    - (NSMutableDictionary *)dMapMethods { \
        if (_dMapMethods) return _dMapMethods; \
        NSMutableDictionary *d = [NSMutableDictionary dictionary]; \
        _dMapMethods = d; \
        return _dMapMethods; \
    } \
\
    @end

#endif

#endif /* MQProxyDealerMacro_h */
