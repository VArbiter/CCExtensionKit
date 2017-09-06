//
//  NSAttributedString+CCExtension.m
//  CCLocalLibrary
//
//  Created by Elwinfrederick on 06/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "NSAttributedString+CCExtension.h"
#import "NSObject+CCExtension.h"

@implementation NSAttributedString (CCExtension)

+ (NSMutableAttributedString *) ccColor : (UIColor *) color
                                 string : (NSString *) string {
    if (string.isStringValued) {
        return [[NSMutableAttributedString alloc] initWithString:string
                                                      attributes:@{NSForegroundColorAttributeName : color}];
    }
    return [[NSMutableAttributedString alloc] initWithString:@""];
}

- (NSMutableAttributedString *) ccColor : (UIColor *) color {
    NSMutableAttributedString *t = self.mutableCopy;
    [t addAttribute:NSForegroundColorAttributeName
              value:color
              range:NSMakeRange(0, self.length)];
    return t;
}

- (NSMutableAttributedString *) ccOperate : (NSMutableAttributedString * (^)(NSMutableAttributedString * sender)) action {
    if (action) {
        return action(self.mutableCopy);
    }
    return self.mutableCopy;
}

- (NSMutableAttributedString *) ccAppendS : (NSAttributedString *) sAttr {
    if (sAttr && [sAttr isKindOfClass:NSAttributedString.class]) {
        NSMutableAttributedString *sc = self.mutableCopy;
        [sc appendAttributedString:sAttr];
        return sc;
    }
    return self.mutableCopy;
}

- (NSMutableAttributedString *) ccAppendC : (NSString *) string {
    if (string.isStringValued) {
        NSMutableAttributedString *sc = self.mutableCopy;
        [sc appendAttributedString:[[NSMutableAttributedString alloc] initWithString:string]];
        return sc;
    }
    return self.mutableCopy;
}

@end

#pragma mark - -----

@implementation NSMutableAttributedString (CCExtension)

- (NSMutableAttributedString *) ccAttributeC : (NSString *) sKey
                                       value : (id) value {
    if (sKey && sKey.length) [self addAttribute:sKey value:value range:(NSRange){0 , self.length}];
    return self;
}

- (NSMutableAttributedString *) ccAttributeS : (NSDictionary *) dAttributes {
    if (dAttributes.allKeys) [self addAttributes:dAttributes range:NSMakeRange(0, self.length)];
    return self;
}

@end
