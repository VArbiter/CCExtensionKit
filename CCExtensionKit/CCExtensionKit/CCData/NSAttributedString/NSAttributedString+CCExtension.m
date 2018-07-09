//
//  NSAttributedString+CCExtension.m
//  CCExtensionKit
//
//  Created by Elwinfrederick on 06/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "NSAttributedString+CCExtension.h"
#import "NSObject+CCExtension.h"

@implementation NSAttributedString (CCExtension)

+ (NSMutableAttributedString *) cc_color : (UIColor *) color
                                 string : (NSString *) string {
    if (CC_IS_STRING_VALUED(string)) {
        return [[NSMutableAttributedString alloc] initWithString:string
                                                      attributes:@{NSForegroundColorAttributeName : color}];
    }
    return nil;
}

- (NSMutableAttributedString *) cc_color : (UIColor *) color {
    NSMutableAttributedString *t = self.mutableCopy;
    [t addAttribute:NSForegroundColorAttributeName
              value:color
              range:NSMakeRange(0, self.length)];
    return t;
}

- (NSMutableAttributedString *) cc_operate : (NSMutableAttributedString * (^)(NSMutableAttributedString * sender)) action {
    if (action) {
        return action(self.mutableCopy);
    }
    return self.mutableCopy;
}

- (NSMutableAttributedString *) cc_append_s : (NSAttributedString *) sAttr {
    if (sAttr && [sAttr isKindOfClass:NSAttributedString.class]) {
        NSMutableAttributedString *sc = self.mutableCopy;
        [sc appendAttributedString:sAttr];
        return sc;
    }
    return self.mutableCopy;
}

- (NSMutableAttributedString *) cc_append_c : (NSString *) string {
    if (CC_IS_STRING_VALUED(string)) {
        NSMutableAttributedString *sc = self.mutableCopy;
        [sc appendAttributedString:[[NSMutableAttributedString alloc] initWithString:string]];
        return sc;
    }
    return self.mutableCopy;
}

@end

#pragma mark - -----

@implementation NSMutableAttributedString (CCExtension)

- (NSMutableAttributedString *) cc_attribute_c : (NSAttributedStringKey) sKey
                                       value : (id) value {
    if (sKey && sKey.length) [self addAttribute:sKey value:value range:(NSRange){0 , self.length}];
    return self;
}

- (NSMutableAttributedString *) cc_attribute_s : (NSDictionary <NSAttributedStringKey , id> *) dAttributes {
    if (dAttributes.allKeys) [self addAttributes:dAttributes range:NSMakeRange(0, self.length)];
    return self;
}

@end

#pragma mark - -----

@implementation NSString (CCExtension_AttributedString)

- (NSMutableAttributedString *)toAttribute {
    return CC_IS_STRING_VALUED(self) ? [[NSMutableAttributedString alloc] initWithString:self] : nil;
}
- (NSMutableAttributedString *) cc_color : (UIColor *) color {
    return [self.toAttribute cc_color:color];
}

@end
