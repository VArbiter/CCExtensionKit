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

+ (instancetype) cc_request : (NSString *) sURL {
    return [NSURLRequest requestWithURL:[NSURL cc_URL:sURL]];
}
+ (instancetype) cc_local : (NSString *) sURL {
    return [NSURLRequest requestWithURL:[NSURL cc_local:sURL]];
}

@end

#pragma mark - -----

@implementation NSMutableURLRequest (CCExtension)

+ (instancetype)cc_request:(NSString *)sURL {
    return [NSMutableURLRequest requestWithURL:[NSURL cc_URL:sURL]];
}
+ (instancetype)cc_local:(NSString *)sURL {
    return [NSMutableURLRequest requestWithURL:[NSURL cc_local:sURL]];
}

@end


