//
//  CCProxyDealerMacro.h
//  CCLocalLibrary
//
//  Created by Elwinfrederick on 15/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#ifndef CCProxyDealerMacro_h
#define CCProxyDealerMacro_h

/// simply simulat the muti-inhert of objective-C
/// note : if you want that CCProxyDealer to simulate the muti-inhert values
///     all your methods must be instance and interface in a protocol
/// note : and be sure do "#import <objc/runtime.h>" in your implementation file
/// eg :
///
/// @@protocol CCTestProtocol : <NSObject>
/// - (void) testMethod ;
/// @end
///
/// @interface CCSomeClass : NSObject < CCTestProtocol >
/// @end
///
/// @implementation CCSomeClass
///
/// - (void) testMethod {/* do sth. */}
///
/// @end

#ifndef CC_PROXY_DEALER_PROTOCOL_HOLDER
    #define CC_PROXY_DEALER_PROTOCOL_HOLDER CCProxyHolderProtocol
    @protocol CC_PROXY_DEALER_PROTOCOL_HOLDER <NSObject>
    @end
#endif

#ifndef CC_PROXY_DEALER_INTERFACE
    /// name , protocols that want to be simulated // 名称 , 想被模仿的协议

    #define CC_PROXY_DEALER_INTERFACE(_name_ , ...) \
\
    @interface CCProxy_t_##_name_ : NSProxy < CC_PROXY_DEALER_PROTOCOL_HOLDER , ##__VA_ARGS__ > \
        + (instancetype) common ; \
        + (instancetype) common : (NSArray <id> *) arrayTarget ; \
        - (instancetype) ccRegistMethods : (NSArray <id> *) arrayTarget ; \
    @end
        
#endif

#ifndef CC_PROXY_DEALER_IMPLEMENTATION
    /// name , it should be the name that passing though CC_PROXY_DEALER_INTERFACE. // 名称 , 应该是 传入 CC_PROXY_DEALER_INTERFACE 的

    #define CC_PROXY_DEALER_IMPLEMENTATION(_name_) \
\
    @interface CCProxy_t_##_name_  () \
        @property (nonatomic , strong) NSMutableDictionary *dMapMethods ; \
    @end \
\
    @implementation CCProxy_t_##_name_ \
    + (instancetype) common { \
        return [[self alloc] init]; \
    } \
    + (instancetype) common : (NSArray <id> *) arrayTarget { \
        return [[self common] ccRegistMethods:arrayTarget]; \
    } \
\
    - (instancetype) cc_regist_methods : (NSArray <id> *) arrayTarget { \
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

#endif /* CCProxyDealerMacro_h */
