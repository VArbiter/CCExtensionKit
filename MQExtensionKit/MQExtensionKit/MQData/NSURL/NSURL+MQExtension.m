//
//  NSURL+MQExtension.m
//  MQExtensionKit
//
//  Created by Elwinfrederick on 06/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "NSURL+MQExtension.h"

@implementation NSURL (CCExtension)

+ (instancetype)mq_URL:(NSString *)sURL {
    return [NSURL URLWithString:(sURL && sURL.length) ? sURL : @""];
}

+ (instancetype)mq_local:(NSString *)sURL {
    return [NSURL fileURLWithPath:(sURL && sURL.length) ? sURL : @""];
}

@end

#pragma mark - -----

@implementation NSString (CCExtension_UrlEncode)

- (NSURL *)toWebURL {
    return [NSURL mq_URL:self];
}
- (NSURL *)toLocalURL {
    return [NSURL mq_local:self];
}

@end
