//
//  NSURLRequest+CCExtension.m
//  CCLocalLibrary
//
//  Created by Elwinfrederick on 06/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "NSURLRequest+CCExtension.h"
#import "NSURL+CCExtension.h"

@implementation NSURLRequest (CCExtension)

+ (instancetype) ccRequest : (NSString *) sURL {
    return [NSURLRequest requestWithURL:[NSURL ccURL:sURL]];
}
+ (instancetype) ccLocal : (NSString *) sURL {
    return [NSURLRequest requestWithURL:[NSURL ccLocal:sURL]];
}

@end

#pragma mark - -----

@implementation NSMutableURLRequest (CCExtension)

+ (instancetype)ccRequest:(NSString *)sURL {
    return [NSMutableURLRequest requestWithURL:[NSURL ccURL:sURL]];
}
+ (instancetype)ccLocal:(NSString *)sURL {
    return [NSMutableURLRequest requestWithURL:[NSURL ccLocal:sURL]];
}

@end


