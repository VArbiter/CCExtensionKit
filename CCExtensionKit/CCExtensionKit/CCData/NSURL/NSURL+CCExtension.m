//
//  NSURL+CCExtension.m
//  CCExtensionKit
//
//  Created by Elwinfrederick on 06/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "NSURL+CCExtension.h"

@implementation NSURL (CCExtension)

+ (instancetype)cc_URL:(NSString *)sURL {
    return [NSURL URLWithString:(sURL && sURL.length) ? sURL : @""];
}

+ (instancetype)cc_local:(NSString *)sURL {
    return [NSURL fileURLWithPath:(sURL && sURL.length) ? sURL : @""];
}

@end

#pragma mark - -----

@implementation NSString (CCExtension_UrlEncode)

- (NSURL *)toWebURL {
    return [NSURL cc_URL:self];
}
- (NSURL *)toLocalURL {
    return [NSURL cc_local:self];
}

@end
