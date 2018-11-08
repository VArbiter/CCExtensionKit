//
//  NSArray+MQExtension.m
//  MQExtensionKit
//
//  Created by 冯明庆 on 2017/4/19.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "NSArray+MQExtension.h"

#import "NSObject+MQExtension.h"

@implementation NSArray (MQExtension)

- (NSString *)to_json {
    NSError *error;
    NSData *t_data = [NSJSONSerialization dataWithJSONObject:self
                                                     options:NSJSONWritingPrettyPrinted
                                                       error:&error];
    
    NSString *s_json = nil;
    
    if (!t_data) return nil;
    else s_json = [[NSString alloc]initWithData:t_data encoding:NSUTF8StringEncoding];
    
    NSMutableString *s_mutable = [NSMutableString stringWithString:s_json];

    NSRange range = {0,s_json.length};
    [s_mutable replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,s_mutable.length};
    [s_mutable replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return s_mutable;
}

- (NSData *)to_data {
    NSError *error;
    NSData *t_data = [NSJSONSerialization dataWithJSONObject:self
                                                     options:NSJSONWritingPrettyPrinted
                                                       error:&error];
    if (error) return nil;
    else return t_data;
}

- (id) mq_value_at : (NSInteger) index {
    if (!mq_is_array_valued(self)) return nil;
    if (index >= 0 && index < self.count) {
        return self[index];
    }
    return nil;
}

@end

#pragma mark - -----
#import <objc/runtime.h>

@implementation NSMutableArray (MQExtension)

- (instancetype) mq_add : (id) value {
    if (value) [self addObject:value];
    return self;
}
- (instancetype) mq_add_array : (id) value {
    if ([value isKindOfClass:[NSArray class]]) {
        if (((NSArray *)value).count) {
            [self addObjectsFromArray:((NSArray *)value)];
        }
    }
    else if ([value isKindOfClass:[NSSet class]]) {
        __weak typeof(self) weak_self = self;
        [((NSSet *)value) enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
            [weak_self addObject:obj];
        }];
    }
    return self;
}
- (instancetype) mq_remove_t : (id) value {
    if (value && [self containsObject:value]) [self removeObject:value];
    return self;
}
- (instancetype) mq_remove_all_t {
    if (self.count > 0) [self removeAllObjects];
    return self;
}
- (instancetype) mq_remove_at : (NSUInteger) i_index {
    id t = [self mq_value_at:i_index];
    if (t) [self removeObjectAtIndex:i_index];
    return self;
}

- (instancetype) mq_type : (NSString *) cls {
    objc_setAssociatedObject(self, "_MQ_ARRAY_CLAZZ_", cls, OBJC_ASSOCIATION_ASSIGN);
    return self;
}
- (instancetype) mq_append : (id) value {
    BOOL isCan = YES;
    if (objc_getAssociatedObject(self, "_MQ_ARRAY_CLAZZ_")) {
        Class clazz = NSClassFromString([NSString stringWithFormat:@"%@",objc_getAssociatedObject(self, "_MQ_ARRAY_CLAZZ_")]);
        isCan = [value isKindOfClass:clazz];
    }
    MQArrayChangeInfo type ;
    type.type = MQArrayChangeTypeAppend;
    type.count = self.count;
    if (isCan) {
        [self addObject:value];
        type.count = self.count;
        void (^t)(id , MQArrayChangeInfo) = objc_getAssociatedObject(self, "_MQ_ARRAY_CHANGE_");
        if (t) {
            t(value , type);
        }
    } else {
        type.type = MQArrayChangeTypeNone;
    }
    
    void (^r)(MQArrayChangeInfo t) = objc_getAssociatedObject(self, "_MQ_ARRAY_COMPLETE_");
    if (r) {
        r(type);
    }
    return self;
}

- (instancetype) mq_append : (id)value
                   expand : (BOOL) isExpand {
    if ([value isKindOfClass:NSArray.class]) {
        if (isExpand) {
            __weak typeof(self) pSelf = self;
            [(NSArray *)value enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [pSelf mq_append:value];
            }];
        }
        else [self mq_append:value];
    }
    else [self mq_append:value];
    return self;
}
- (instancetype) mq_remove : (id) value {
    MQArrayChangeInfo type ;
    type.type = MQArrayChangeTypeRemoved;
    type.count = self.count;
    if ([self containsObject:value]) {
        [self removeObject:value];
        void (^t)(id , MQArrayChangeInfo) = objc_getAssociatedObject(self, "_MQ_ARRAY_CHANGE_");
        if (t) {
            t(value , type);
        }
    } else {
        type.type = MQArrayChangeTypeNone;
    }
    void (^r)(MQArrayChangeInfo t) = objc_getAssociatedObject(self, "_MQ_ARRAY_COMPLETE_");
    if (r) {
        r(type);
    }
    return self;
}
- (instancetype) mq_remove_all : (BOOL (^)(BOOL isCompare , id obj)) action {
    NSString *stringClazz = [NSString stringWithFormat:@"%@",objc_getAssociatedObject(self, "_MQ_ARRAY_CLAZZ_")];
    
    NSMutableArray *arrayRemove = [NSMutableArray array];
    __block MQArrayChangeInfo type ;
    type.type = MQArrayChangeTypeRemoved;
    
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BOOL isCan = YES;
        if (action) {
            isCan = action([obj isKindOfClass:NSClassFromString(stringClazz)] , obj);
        }
        if (isCan) {
            [arrayRemove addObject:obj];
            type.count = self.count;
            void (^t)(id , MQArrayChangeInfo) = objc_getAssociatedObject(self, "_MQ_ARRAY_CHANGE_");
            if (t) {
                t(obj , type);
            }
        }
    }];
    [self removeObjectsInArray:arrayRemove];
    void (^r)(MQArrayChangeInfo t) = objc_getAssociatedObject(self, "_MQ_ARRAY_COMPLETE_");
    if (r) {
        r(type);
    }
    
    return self;
}


- (instancetype) mq_change : (void (^)(id value , MQArrayChangeInfo type)) action {
    objc_setAssociatedObject(self, "_MQ_ARRAY_CHANGE_", action, OBJC_ASSOCIATION_COPY_NONATOMIC);
    return self;
}
- (instancetype) mq_complete : (void (^)(MQArrayChangeInfo type)) action {
    objc_setAssociatedObject(self, "_MQ_ARRAY_COMPLETE_", action, OBJC_ASSOCIATION_COPY_NONATOMIC);
    return self;
}

@end
