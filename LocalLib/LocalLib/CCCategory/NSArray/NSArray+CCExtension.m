//
//  NSArray+CCExtension.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/19.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "NSArray+CCExtension.h"

@implementation NSArray (CCExtension)

- (id) ccValue : (NSInteger) integerIndex {
    if (self) {        
        if ([self isKindOfClass:[NSArray class]] || [self isKindOfClass:[NSMutableArray class]]) {
            if (self.count > integerIndex) {
                return self[integerIndex];
            }
        }
    }
    return nil;
}


@end
