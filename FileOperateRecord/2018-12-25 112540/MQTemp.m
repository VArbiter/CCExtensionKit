//
//  MQTemp.m
//  MQExtension_Example
//
//  Created by ElwinFrederick on 2018/12/24.
//  Copyright © 2018 ElwinFrederick. All rights reserved.
//

#import "MQTemp.h"

//@implementation MQTemp

//@end

/*
@interface MQRouterObject ()

@property (nonatomic , copy , readwrite) NSString * scheme ;
@property (nonatomic , copy , readwrite) MQRouterRegistKey path ;
@property (nonatomic , copy , readwrite) NSArray <NSString *> * array_required_params ;

#if DEBUG
@property (nonatomic , copy , readwrite) NSString * s_object_to_json ;
#endif

@end

@implementation MQRouterObject

- (instancetype) init_by_path : (MQRouterRegistKey) key {
    return [self init_by_scheme:nil path:key];
}
- (instancetype) init_by_scheme : (nullable NSString *) scheme
                           path : (MQRouterRegistKey) key {
    if ((self = [super init])) {
        self.scheme = scheme;
        self.path = key;
    }
    return self;
}

- (BOOL)is_block_has_return_value {
    return !!self.handler_object;
}

- (void) mq_finish {
#warning TODO >>>
}

#if DEBUG

- (NSString *)s_object_to_json {
    if (_s_object_to_json) return _s_object_to_json;
    
    NSString *(^mq_transfer_to_json)(id) = ^NSString *(id object) {
        NSError *error;
        NSData *t_data = [NSJSONSerialization dataWithJSONObject:object
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
    };
    
    NSMutableDictionary *d_json = [NSMutableDictionary dictionary];
    [d_json setValue:self.scheme forKey:@"scheme"];
    [d_json setValue:self.path forKey:@"path"];
    [d_json setValue:mq_transfer_to_json(self.array_required_params)
              forKey:@"required_params"];
    
    _s_object_to_json = mq_transfer_to_json(d_json);
    
    return _s_object_to_json;
}

- (NSString *)debugDescription {
    [super debugDescription];
    
    NSString *s = [NSString stringWithFormat:@"{\n %@ , \n user_info:%@ }" , self.s_object_to_json
                   //                   , self.user_info
                   ];
    return s;
}
#endif

@end

#pragma mark - ----- ###########################################################

*/
