//
//  NSURL+CCExtension.m
//  CCLocalLibrary
//
//  Created by Elwinfrederick on 06/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "NSURL+CCExtension.h"

@implementation NSURL (CCExtension)

+ (instancetype)ccURL:(NSString *)sURL {
    return [NSURL URLWithString:(sURL && sURL.length) ? sURL : @""];
}

+ (instancetype)ccLocal:(NSString *)sURL {
    return [NSURL fileURLWithPath:(sURL && sURL.length) ? sURL : @""];
}

@end

#pragma mark - -----

@implementation NSString (CCExtension_UrlEncode)

- (NSURL *)toWebURL {
    return [NSURL ccURL:self];
}
- (NSURL *)toLocalURL {
    return [NSURL ccLocal:self];
}

@end
