//
//  NSAttributedString+MQExtension.m
//  MQExtensionKit
//
//  Created by Elwinfrederick on 06/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "NSAttributedString+MQExtension.h"
#import "NSObject+MQExtension.h"

@implementation NSAttributedString (MQExtension)

- (NSMutableAttributedString *)to_mutable {
    return self.mutableCopy;
}

- (BOOL)is_mutable {
    if ([self isKindOfClass:[NSMutableAttributedString class]]) { return YES; }
    return false;
}

@end

#pragma mark - -----

@implementation NSMutableAttributedString (MQExtension)

- (__kindof NSMutableAttributedString *) mq_attribute_c : (NSAttributedStringKey) sKey
                                       value : (id) value {
    if (sKey && sKey.length) [self addAttribute:sKey value:value range:(NSRange){0 , self.length}];
    return self;
}

- (__kindof NSMutableAttributedString *) mq_attribute_s : (NSDictionary <NSAttributedStringKey , id> *) dAttributes {
    if (dAttributes.allKeys) [self addAttributes:dAttributes range:NSMakeRange(0, self.length)];
    return self;
}

+ (__kindof NSMutableAttributedString *) mq_color : (UIColor *) color
                                           string : (NSString *) string {
    if (MQ_IS_STRING_VALUED(string)) {
        return [[NSMutableAttributedString alloc] initWithString:string
                                                      attributes:@{NSForegroundColorAttributeName : color}];
    }
    return nil;
}

- (__kindof NSMutableAttributedString *) mq_color : (UIColor *) color {
    NSMutableAttributedString *t = nil;
    if (self.is_mutable) t = self;
    else t = self.to_mutable;
    [t addAttribute:NSForegroundColorAttributeName
              value:color
              range:NSMakeRange(0, self.length)];
    return t;
}

- (__kindof NSMutableAttributedString *) mq_font : (UIFont *) font {
    NSMutableAttributedString *t = nil;
    if (self.is_mutable) t = self;
    else t = self.to_mutable;
    [t addAttribute:NSFontAttributeName
              value:font
              range:NSMakeRange(0, self.length)];
    return t;
}
- (__kindof NSMutableAttributedString *) mq_style : (void (^)(__kindof NSMutableParagraphStyle * style)) action {
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    if (action) action(style);
    NSMutableAttributedString *t = nil;
    if (self.is_mutable) t = self;
    else t = self.to_mutable;
    [t addAttribute:NSParagraphStyleAttributeName
              value:style
              range:NSMakeRange(0, self.length)];
    return t;
}

- (__kindof NSMutableAttributedString *) mq_operate : (__kindof NSMutableAttributedString * (^)(__kindof NSMutableAttributedString * sender)) action {
    if (action) {
        return action(self);
    }
    return self;
}

- (__kindof NSMutableAttributedString *) mq_append_s : (NSAttributedString *) sAttr {
    if (sAttr && [sAttr isKindOfClass:NSAttributedString.class]) {
        NSMutableAttributedString *t = nil;
        if (self.is_mutable) t = self;
        else t = self.to_mutable;
        [t appendAttributedString:sAttr];
        return t;
    }
    return self;
}

- (__kindof NSMutableAttributedString *) mq_append_c : (NSString *) string {
    if (MQ_IS_STRING_VALUED(string)) {
        NSMutableAttributedString *t = nil;
        if (self.is_mutable) t = self;
        else t = self.to_mutable;
        [t appendAttributedString:[[NSMutableAttributedString alloc] initWithString:string]];
        return t;
    }
    return self;
}

@end

#pragma mark - -----

@implementation NSString (MQExtension_AttributedString)

- (NSMutableAttributedString *)to_attribute {
    return MQ_IS_STRING_VALUED(self) ? [[NSMutableAttributedString alloc] initWithString:self] : nil;
}

@end
