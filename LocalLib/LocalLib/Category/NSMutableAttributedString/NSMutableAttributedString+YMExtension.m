//
//  NSMutableAttributedString+YMExtension.m
//  ym_sell_ios
//
//  Created by 冯明庆 on 2017/4/24.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "NSMutableAttributedString+YMExtension.h"

#import "NSString+YMExtension.h"

@implementation NSMutableAttributedString (YMExtension)

+ (instancetype) ymAttributeWithColor : (UIColor *) color
                           withString : (NSString *) string {
    if ([string isKindOfClass:[NSString class]])
        if (string.ymIsStringValued) {
            NSMutableAttributedString *stringResult = [[NSMutableAttributedString alloc] initWithString:string
                                                                                             attributes:@{NSForegroundColorAttributeName : color}];
            return stringResult;
        }
    return nil;
}

- (instancetype) ymAppend : (NSMutableAttributedString *) attributeString {
    if ([attributeString isKindOfClass:[NSMutableAttributedString class]])
        if (attributeString.length) {
            [self appendAttributedString:attributeString];
            return self;
        }
    return self;
}

@end
