//
//  NSMutableAttributedString+CCExtension.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/24.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "NSMutableAttributedString+CCExtension.h"
#import "NSString+CCExtension.h"
#import "CCCommonDefine.h"

@implementation NSMutableAttributedString (CCExtension)

+ (instancetype) ccAttributeWithColor : (UIColor *) color
                           withString : (NSString *) string {
    if ([string isKindOfClass:[NSString class]])
        if (string.ccIsStringValued) {
            NSMutableAttributedString *stringResult = [[NSMutableAttributedString alloc] initWithString:string
                                                                                             attributes:@{NSForegroundColorAttributeName : color}];
            return stringResult;
        }
    return nil;
}

- (instancetype) ccAppend : (NSMutableAttributedString *) attributeString {
    if ([attributeString isKindOfClass:[NSMutableAttributedString class]])
        if (attributeString.length) {
            [self appendAttributedString:attributeString];
            return self;
        }
    return self;
}

@end
