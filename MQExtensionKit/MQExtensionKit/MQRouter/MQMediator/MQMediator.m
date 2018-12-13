//
//  MQMediator.m
//  MQExtensionKit
//
//  Created by Elwinfrederick on 14/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "MQMediator.h"

@implementation MQMediator

+ (id) mq_perform : (NSString *) s_target
           action : (NSString *) s_action
     return_value : (BOOL) is_need
            value : (id (^)(void)) value {
    id m;
    if (value) m = value();
    Class ts = NSClassFromString(s_target);
    SEL as = NSSelectorFromString(s_action);
    
    if (!ts || !as || ![ts respondsToSelector:as]) return nil;
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    if (is_need) return [ts performSelector:as withObject:m];
    else [ts performSelector:as withObject:m];
#pragma clang diagnostic pop
    return nil;
}

@end
