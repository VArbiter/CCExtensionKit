//
//  NSError+MQExtension.m
//  MQExtension_Example
//
//  Created by ElwinFrederick on 2018/8/13.
//  Copyright © 2018 ElwinFrederick. All rights reserved.
//

#import "NSError+MQExtension.h"

static NSString * MQ_NSError_DOMAIN = @"MQExtensionKit.custom.error.domain";

@implementation NSError (MQExtension)

+ (instancetype) mq_error_with_code : (NSInteger) i_code
                        description : (NSString *) s_description {
    NSError *error_t = [NSError errorWithDomain:MQ_NSError_DOMAIN
                                           code:i_code
                                       userInfo:@{NSLocalizedDescriptionKey : s_description ? s_description : @""}];
    return error_t;
}

@end
