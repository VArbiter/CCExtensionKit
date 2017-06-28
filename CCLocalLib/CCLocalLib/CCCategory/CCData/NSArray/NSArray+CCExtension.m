//
//  NSArray+CCExtension.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/19.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "NSArray+CCExtension.h"

#import "NSObject+CCExtension.h"

@implementation NSArray (CCExtension)

- (id) ccValue : (NSInteger) index {
    if (self) {        
        if (self.isArrayValued) {
            return self[index];
        }
    }
    return nil;
}


@end
