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
        + (instancetype) common : (NSArray <id> *) array_targets ; \
        - (instancetype) mq_regist_methods : (NSArray <id> *) array_targets ; \
    @end
        
#endif

#ifndef MQ_PROXY_DEALER_IMPLEMENTATION
    /// name , it should be the name that passing though MQ_PROXY_DEALER_INTERFACE. // 名称 , 应该是 传入 MQ_PROXY_DEALER_INTERFACE 的

    #define MQ_PROXY_DEALER_IMPLEMENTATION(_name_) \
\
    @interface MQProxy_t_##_name_  () \
        @property (nonatomic , strong) NSMutableDictionary *dict_map_methods ; \
    @end \
\
    @implementation MQProxy_t_##_name_ \
\
    + (instancetype) common { \
        return [[self alloc] init]; \
    } \
    + (instancetype) common : (NSArray <id> *) array_targets { \
        return [[self common] mq_regist_methods:array_targets]; \
    } \
\
    - (instancetype) mq_regist_methods : (NSArray <id> *) array_targets { \
        for (id t in array_targets) { \
            unsigned int i_methods = 0; \
            Method *method_list = class_copyMethodList([t class], &i_methods); \
            for (int i = 0; i < i_methods; i ++) { \
                Method t_method = method_list[i]; \
                SEL t_sel = method_getName(t_method); \
                const char *t_method_name = sel_getName(t_sel); \
                [self.dict_map_methods setObject:t \
                                          forKey:[NSString stringWithUTF8String:t_method_name]]; \
            } \
            free(method_list); \
        } \
        return self; \
    } \
\
    - (void)forwardInvocation:(NSInvocation *)invocation { \
        SEL sel = invocation.selector; \
        NSString *s_method_name = NSStringFromSelector(sel); \
        id target = self.dict_map_methods[s_method_name]; \
        if (target && [target respondsToSelector:sel]) [invocation invokeWithTarget:target]; \
        else [super forwardInvocation:invocation]; \
    } \
\
    - (NSMethodSignature *)methodSignatureForSelector:(SEL)sel { \
        NSString *s_method_name = NSStringFromSelector(sel); \
        id target = self.dict_map_methods[s_method_name]; \
        if (target && [target respondsToSelector:sel]) \
            return [target methodSignatureForSelector:sel]; \
        else return [super methodSignatureForSelector:sel]; \
    } \
\
    - (NSMutableDictionary *)dict_map_methods { \
        if (_dict_map_methods) return _dict_map_methods; \
        NSMutableDictionary *d = [NSMutableDictionary dictionary]; \
        _dict_map_methods = d; \
        return _dict_map_methods; \
    } \
\
    @end

#endif

#endif /* MQProxyDealerMacro_h */
