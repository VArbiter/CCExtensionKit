//
//  MQProxyDealer.m
//  MQExtensionKit
//
//  Created by Elwinfrederick on 15/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "MQProxyDealer.h"

#ifdef MQ_PROXY_DELER_PROTOCOL_TEST_EXAMPLE
#import <objc/runtime.h>

@interface MQProxyDealer ()

@property (nonatomic , strong) NSMutableDictionary *dict_map_methods ;

@end

@implementation MQProxyDealer

+ (instancetype) common {
    return [[self alloc] init];
}
+ (instancetype) common : (NSArray <id> *) array_targets {
    return [[self common] mq_regist_methods:array_targets];
}

- (instancetype) mq_regist_methods : (NSArray <id> *) array_targets {
    for (id t in array_targets) {
        unsigned int i_methods = 0; // methods count
        // get target methods list
        Method *method_list = class_copyMethodList([t class], &i_methods);
        
        for (int i = 0; i < i_methods; i ++) {
            // get names of methods and stored in dictionary
            Method t_method = method_list[i];
            SEL t_sel = method_getName(t_method);
            const char *t_method_name = sel_getName(t_sel);
            [self.dict_map_methods setObject:t
                                  forKey:[NSString stringWithUTF8String:t_method_name]];
        }
        free(method_list);
    }
    return self;
}

#pragma mark - ----
// override NSProxy methods

- (void)forwardInvocation:(NSInvocation *)invocation {
    SEL sel = invocation.selector; // find current selector that selected
    NSString *s_method_name = NSStringFromSelector(sel); // get sel 's method name
    id target = self.dict_map_methods[s_method_name]; // find target in dictionary
    
    // check target
    if (target && [target respondsToSelector:sel]) [invocation invokeWithTarget:target];
    else [super forwardInvocation:invocation];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    NSString *s_method_name = NSStringFromSelector(sel);
    id target = self.dict_map_methods[s_method_name];
    
    if (target && [target respondsToSelector:sel]) return [target methodSignatureForSelector:sel];
    else return [super methodSignatureForSelector:sel];
}

- (NSMutableDictionary *)dict_map_methods {
    if (_dict_map_methods) return _dict_map_methods;
    NSMutableDictionary *d = [NSMutableDictionary dictionary];
    _dict_map_methods = d;
    return _dict_map_methods;
}

@end

#endif
