//
//  NSURLRequest+MQExtension.m
//  MQExtensionKit
//
//  Created by Elwinfrederick on 06/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "NSURLRequest+MQExtension.h"
#import "NSURL+MQExtension.h"

@implementation NSURLRequest (CCExtension)

+ (instancetype) mq_request : (NSString *) sURL {
    return [NSURLRequest requestWithURL:[NSURL mq_URL:sURL]];
}
+ (instancetype) mq_local : (NSString *) sURL {
    return [NSURLRequest requestWithURL:[NSURL mq_local:sURL]];
}

@end

#pragma mark - -----

@implementation NSMutableURLRequest (CCExtension)

+ (instancetype)mq_request:(NSString *)sURL {
    return [NSMutableURLRequest requestWithURL:[NSURL mq_URL:sURL]];
}
+ (instancetype)mq_local:(NSString *)sURL {
    return [NSMutableURLRequest requestWithURL:[NSURL mq_local:sURL]];
}

@end


