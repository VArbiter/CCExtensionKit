//
//  NSAttributedString+CCChain.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 01/07/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "NSAttributedString+CCChain.h"
#import "NSObject+CCChain.h"

@implementation NSAttributedString (CCChain)

+ (NSMutableAttributedString *(^)(UIColor *, NSString *))color {
    return ^NSMutableAttributedString *(UIColor *color , NSString *string) {
        if (string.isStringValued) {
            return [[NSMutableAttributedString alloc] initWithString:string
                                                          attributes:@{NSForegroundColorAttributeName : color}];;
        }
        return nil;
    };
}

- (NSMutableAttributedString *(^)(UIColor *))color {
    __weak typeof(self) pSelf = self;
    return ^NSMutableAttributedString *(UIColor *color) {
        NSMutableAttributedString *t = pSelf.mutableCopy;
        [t addAttribute:NSForegroundColorAttributeName
                  value:color
                  range:NSMakeRange(0, pSelf.length)];
        return t;
    };
}

- (NSMutableAttributedString *(^)(NSMutableAttributedString *(^)(NSMutableAttributedString *)))operate {
    __weak typeof(self) pSelf = self;
    return ^NSMutableAttributedString * (NSMutableAttributedString * (^t)(NSMutableAttributedString * sender)) {
        if (t) {
            return t(pSelf.mutableCopy);
        }
        return pSelf.mutableCopy;
    };
}

@end
