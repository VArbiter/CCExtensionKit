//
//  NSDictionary+MQExtension.m
//  MQExtensionKit
//
//  Created by 冯明庆 on 2017/4/20.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "NSDictionary+MQExtension.h"

@implementation NSDictionary (CCExtension)

- (NSString *)toJson {
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

+ (instancetype) mq_json : (NSString *) sJson {
    if (!sJson || !sJson.length) return nil;
    
    NSData *dataJson = [sJson dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *dicionary = [NSJSONSerialization JSONObjectWithData:dataJson
                                                              options:NSJSONReadingMutableContainers | NSJSONReadingAllowFragments
                                                                error:&error];
    return error ? nil : dicionary.mutableCopy;
}

@end

#pragma mark - -----
#import <objc/runtime.h>

static const char * _CC_NSMUTABLEDICTIONARY_OBSERVER_KEY_S_ = "CC_NSMUTABLEDICTIONARY_OBSERVER_KEY_S";
static const char * _CC_NSMUTABLEDICTIONARY_OBSERVER_KEY_T_ = "CC_NSMUTABLEDICTIONARY_OBSERVER_KEY_T";

@implementation NSMutableDictionary (CCExtension)

- (instancetype) mq_set : (id) key
                  value : (id) value {
    [self setValue:value forKey:key];
    return self;
}

- (instancetype) mq_set_with_observer : (id) key
                                value : (id) value {
    [self mq_set:key value:value];
    void (^s)(id , id) = objc_getAssociatedObject(self, _CC_NSMUTABLEDICTIONARY_OBSERVER_KEY_S_);
    if (s) s(key , value);
    void (^t)(id , id , NSArray * , NSArray *) = objc_getAssociatedObject(self, _CC_NSMUTABLEDICTIONARY_OBSERVER_KEY_T_);
    if (t) t(key , value , self.allKeys , self.allValues);
    return self;
}

- (instancetype) mq_observer : (void (^)(id key , id value)) action {
    if (action) objc_setAssociatedObject(self, _CC_NSMUTABLEDICTIONARY_OBSERVER_KEY_S_, action, OBJC_ASSOCIATION_COPY_NONATOMIC);
    return self;
}

- (instancetype) mq_observer_t : (void (^)(void(^t)(id key , id value , NSArray * aAllKeys , NSArray * aAllValues))) action {
    if (action) objc_setAssociatedObject(self, _CC_NSMUTABLEDICTIONARY_OBSERVER_KEY_T_, action, OBJC_ASSOCIATION_COPY_NONATOMIC);
    return self;
}

@end
