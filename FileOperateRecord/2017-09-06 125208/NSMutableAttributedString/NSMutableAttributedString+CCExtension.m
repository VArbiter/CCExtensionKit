//
//  NSMutableAttributedString+CCExtension.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/24.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "NSMutableAttributedString+CCExtension.h"
#import "NSString+CCExtension.h"
#import "NSObject+CCExtension.h"

@implementation NSMutableAttributedString (CCExtension)

+ (instancetype) ccAttribute : (UIColor *) color
                        with : (NSString *) string {
    if ([string isKindOfClass:[NSString class]])
        if (string.isStringValued) {
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
