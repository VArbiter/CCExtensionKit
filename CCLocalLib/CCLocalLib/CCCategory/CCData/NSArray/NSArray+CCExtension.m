//
//  NSArray+CCExtension.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/19.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "NSArray+CCExtension.h"

#import "NSObject+CCExtension.h"
#import "CCCommonDefine.h"

@implementation NSArray (CCExtension)

- (id (^)(NSInteger))valueAt {
    ccWeakSelf;
    return ^id(NSInteger index) {
        if (pSelf) {
            if (pSelf.isArrayValued) {
                if (index >= 0 && index < pSelf.count) {
                    return pSelf[index];
                }
            }
        }
        return nil;
    };
}

- (id) ccValue : (NSInteger) index {
    if (self) {        
        if (self.isArrayValued) {
            if (index >= 0 && index < self.count) {
                return self[index];
            }
        }
    }
    return nil;
}


@end
