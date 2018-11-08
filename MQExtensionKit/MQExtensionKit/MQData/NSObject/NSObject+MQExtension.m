//
//  NSObject+MQExtension.m
//  MQExtensionKit
//
//  Created by 冯明庆 on 2017/4/20.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "NSObject+MQExtension.h"

@implementation NSObject (MQExtension)

+ (NSString *)s_self {
    return NSStringFromClass(self);
}
+ (Class)Self {
    return self;
}

- (NSString *)to_string {
    return [NSString stringWithFormat:@"%@",self];
}

@end

BOOL mq_is_string_valued(__kindof NSString * string) {
    if (string) {
        if ([string isKindOfClass:[NSString class]]) {
            if (string.length
                && ![string isEqualToString:@"(null)"]
                && ![string isEqualToString:@"null"]
                && ![string isEqualToString:@"<null>"]
                && ![string isKindOfClass:NSNull.class]) {
                return YES;
            }
        }
    }
    return false;
}
BOOL mq_is_array_valued(__kindof NSArray * array) {
    if (array) {
        if ([array isKindOfClass:[NSArray class]]) {
            if (array.count) {
                return YES;
            }
        }
    }
    return false;
}
BOOL mq_is_set_valued(__kindof NSSet * set) {
    if (set) {
        if ([set isKindOfClass:[NSSet class]]) {
            if (set.count) {
                return YES;
            }
        }
    }
    return false;
}
BOOL mq_is_dictionary_valued(__kindof NSDictionary * dictionary) {
    if (dictionary) {
        if ([dictionary isKindOfClass:[NSDictionary class]]) {
            if (dictionary && dictionary.allKeys.count && dictionary.allValues.count
                && (dictionary.allKeys.count == dictionary.allValues.count)) {
                return YES;
            }
        }
    }
    return false;
}
BOOL mq_is_decimal_valued(__kindof NSDecimalNumber * decimal) {
    if (decimal) {
        if ([decimal isKindOfClass:[NSDecimalNumber class]]) {
            if (![decimal isEqual:NSDecimalNumber.notANumber]) {
                return YES;
            }
        }
    }
    return false;
}
BOOL mq_is_null(id object) {
    return (object && ![object isKindOfClass:[NSNull class]] && (object != NSNull.null));
}

NSString * mq_log_object(id object) {
    if (!object) return nil;
    if (![object respondsToSelector:@selector(description)]) return nil;
    
    NSString *s_temp1 = [[object description] stringByReplacingOccurrencesOfString:@"\\u"
                                                                        withString:@"\\U"];
    NSString *s_temp2 = [s_temp1 stringByReplacingOccurrencesOfString:@"\""
                                                           withString:@"\\\""];
    NSString *s_temp3 = [[@"\"" stringByAppendingString:s_temp2] stringByAppendingString:@"\""];
    NSData *t_data = [s_temp3 dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *s = nil;
    NSError *error = nil;
    s = [NSPropertyListSerialization propertyListWithData:t_data
                                                  options:NSPropertyListImmutable
                                                   format:NULL
                                                    error:&error];
    
    if (s && !error) {
        return s;
    }
    
#if DEBUG
    NSLog(@" CCExtension: %s \n ERROR : %@",__func__, error.localizedDescription);
#endif
    
    return nil;
}

#pragma mark - -----

#import <objc/runtime.h>

static NSString * MQ_EXTENSION_KVO_ALL_KEY_PATHS_KEY = @"MQ_EXTENSION_KVO_ALL_KEY_PATHS_KEY";

@interface NSObject (MQExtension_KVO_Assist)

@property (nonatomic , strong , readonly) NSMutableDictionary <NSString * ,id > *d_all_key_paths ;

- (void) mq_destory_all_blocks_targets ;

@end

@implementation NSObject (MQExtension_KVO_Assist)

- (NSMutableDictionary<NSString *,id> *)d_all_key_paths {
    id t = objc_getAssociatedObject(self, MQ_EXTENSION_KVO_ALL_KEY_PATHS_KEY.UTF8String);
    if (t) return t;
    else {
        NSMutableDictionary *d = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self,
                                 MQ_EXTENSION_KVO_ALL_KEY_PATHS_KEY.UTF8String,
                                 d,
                                 OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return d;
    }
}

- (void) mq_destory_all_blocks_targets {
    __weak typeof(self) weak_self = self;
    [self.d_all_key_paths enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [weak_self removeObserver:weak_self forKeyPath:key];
    }];
    [self.d_all_key_paths removeAllObjects];
}

@end

@implementation NSObject (MQExtension_KVO)

+ (instancetype) mq_common {
    return [[self alloc] init];
}
- (instancetype) mq_add_observer_for : (NSString *) s_key_path
                            observer : (void (^)(NSString * s_key_path , id object , NSDictionary * change , void * context)) block_observer {
    return [self mq_add_observer_for:s_key_path
                             options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                            observer:block_observer];
}

- (instancetype) mq_add_observer_for : (NSString *) s_key_path
                             options : (NSKeyValueObservingOptions) options
                            observer : (void (^)(NSString * s_key_path , id object , NSDictionary * change , void * context)) block_observer {
    return [self mq_add_observer_for:s_key_path
                             options:options
                             context:NULL
                            observer:block_observer];
}
- (instancetype) mq_add_observer_for : (NSString *) s_key_path
                             options : (NSKeyValueObservingOptions) options
                             context : (void *) context
                            observer : (void (^)(NSString * s_key_path , id object , NSDictionary * change , void * context)) block_observer {
    if (!s_key_path || s_key_path.length <= 0 || !block_observer) return self;
    
    [self.d_all_key_paths setValue:block_observer forKey:s_key_path];
    
    [self addObserver:self
           forKeyPath:s_key_path
              options:options
              context:context];
    
    return self;
}

- (void) mq_remove_observer_for : (NSString *) s_key_path {
    if (!s_key_path || s_key_path.length <= 0) return ;
    [self removeObserver:self forKeyPath:s_key_path];
    [self.d_all_key_paths removeObjectForKey:s_key_path];
}

- (void) mq_remove_all_observers_and_destory {
    [self mq_destory_all_blocks_targets];
}

#pragma mark - -----

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    void (^mq_observer_block)(NSString * s_key_path , id object , NSDictionary * change , void * context) = [self.d_all_key_paths valueForKey:keyPath];
    
    if (!mq_observer_block) return ;
    if (mq_observer_block) mq_observer_block(keyPath , object , change , context);
}

@end
