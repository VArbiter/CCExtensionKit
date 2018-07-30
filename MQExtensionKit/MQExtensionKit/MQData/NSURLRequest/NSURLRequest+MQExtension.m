//
//  NSURLRequest+MQExtension.m
//  MQExtensionKit
//
//  Created by Elwinfrederick on 06/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "NSURLRequest+MQExtension.h"
#import "NSURL+MQExtension.h"

@implementation NSURLRequest (MQExtension)

+ (instancetype) mq_request : (NSString *) s_url {
    return [NSURLRequest requestWithURL:[NSURL mq_url:s_url]];
}
+ (instancetype) mq_local : (NSString *) s_url {
    return [NSURLRequest requestWithURL:[NSURL mq_local:s_url]];
}

@end

#pragma mark - -----

@implementation NSMutableURLRequest (MQExtension)

+ (instancetype)mq_request:(NSString *)s_url {
    return [NSMutableURLRequest requestWithURL:[NSURL mq_url:s_url]];
}
+ (instancetype)mq_local:(NSString *)s_url {
    return [NSMutableURLRequest requestWithURL:[NSURL mq_local:s_url]];
}

@end


