//
//  NSPredicate+CCChain.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 01/07/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "NSPredicate+CCChain.h"

@implementation NSPredicate (CCChain)

+ (NSPredicate *(^)(NSString *))common {
    return ^NSPredicate *(NSString *regex) {
        return [NSPredicate predicateWithFormat:regex];
    };
}

+ (NSPredicate *(^)())time {
    return ^NSPredicate *() {
        return self.common(@"^(?:(?!0000)[0-9]{4}-(?:(?:0[1-9]|1[0-2])-(?:0[1-9]|1[0-9]|2[0-8])|(?:0[13-9]|1[0-2])-(?:29|30)|(?:0[13578]|1[02])-31)|(?:[0-9]{2}(?:0[48]|[2468][048]|[13579][26])|(?:0[48]|[2468][048]|[13579][26])00)-02-29)\\s+([01][0-9]|2[0-3]):[0-5][0-9]$");
    };
}

- (id (^)(id))evaluate {
    __weak typeof(self) pSelf = self;
    return ^id (id value) {
        if ([pSelf evaluateWithObject:value]) {
            return value;
        }
        return nil;
    };
}

@end
