//
//  NSURL+MQExtension.m
//  MQExtensionKit
//
//  Created by Elwinfrederick on 06/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "NSURL+MQExtension.h"

@implementation NSURL (MQExtension)

+ (instancetype) mq_url : (NSString *) s_url {
    return [NSURL URLWithString:(s_url && s_url.length) ? s_url : @""];
}

+ (instancetype)mq_local:(NSString *)s_url {
    return [NSURL fileURLWithPath:(s_url && s_url.length) ? s_url : @""];
}

@end

#pragma mark - -----

@implementation NSString (MQExtension_UrlEncode)

- (NSURL *)to_web_url {
    return [NSURL mq_url:self];
}
- (NSURL *)to_local_url {
    return [NSURL mq_local:self];
}

@end
