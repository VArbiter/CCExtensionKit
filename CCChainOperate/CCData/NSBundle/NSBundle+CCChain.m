//
//  NSBundle+CCChain.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 08/08/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "NSBundle+CCChain.h"

@implementation NSBundle (CCChain)

+ (NSBundle *(^)())main {
    return ^NSBundle *{
        return NSBundle.mainBundle;
    };
}

+ (NSBundle *(^)(__unsafe_unretained Class))bundleFor {
    return ^NSBundle *(Class c) {
        return [NSBundle bundleForClass:c];
    };
}

- (NSBundle *(^)(NSString *, NSString *, void (^)(NSString *)))resourceS {
    __weak typeof(self) pSelf = self;
    return ^NSBundle *(NSString *sn, NSString *se, void (^t)(NSString *)) {
        return pSelf.resourceSC(sn, se, nil, t);
    };
}
- (NSBundle *(^)(NSString *, NSString *, NSString *, void (^)(NSString *)))resourceSC {
    __weak typeof(self) pSelf = self;
    return ^NSBundle *(NSString *sn, NSString *se, NSString *sp, void (^t)(NSString *)) {
        if (t) t([pSelf pathForResource:sn ofType:se inDirectory:sp]);
        return pSelf;
    };
}
- (NSBundle *(^)(NSString *, NSString *, void (^)(NSArray<NSString *> *)))resourceST {
    __weak typeof(self) pSelf = self;
    return ^NSBundle *(NSString *se, NSString *sp, void (^t)(NSArray<NSString *> *)) {
        if (t) t([pSelf pathsForResourcesOfType:se inDirectory:sp]);
        return pSelf;
    };
}
@end
