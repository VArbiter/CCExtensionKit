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

- (__kindof NSMutableAttributedString *) mq_attribute_c : (NSAttributedStringKey) s_key
                                                  value : (id) value {
    if (s_key && s_key.length) [self addAttribute:s_key value:value range:(NSRange){0 , self.length}];
    return self;
}

- (__kindof NSMutableAttributedString *) mq_attribute_s : (NSDictionary <NSAttributedStringKey , id> *) d_attributes {
    if (d_attributes.allKeys) [self addAttributes:d_attributes range:NSMakeRange(0, self.length)];
    return self;
}

+ (__kindof NSMutableAttributedString *) mq_color : (UIColor *) color
                                           string : (NSString *) string {
    if (mq_is_string_valued(string)) {
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

- (__kindof NSMutableAttributedString *) mq_append_s : (NSAttributedString *) s_attr {
    if (s_attr && [s_attr isKindOfClass:NSAttributedString.class]) {
        NSMutableAttributedString *t = nil;
        if (self.is_mutable) t = self;
        else t = self.to_mutable;
        [t appendAttributedString:s_attr];
        return t;
    }
    return self;
}

- (__kindof NSMutableAttributedString *) mq_append_c : (NSString *) string {
    if (mq_is_string_valued(string)) {
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
    return mq_is_string_valued(self) ? [[NSMutableAttributedString alloc] initWithString:self] : nil;
}

@end
