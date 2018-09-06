//
//  UIFont+MQExtension.m
//  MQExtensionKit
//
//  Created by Elwinfrederick on 08/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "UIFont+MQExtension.h"

MQFontFamilyName MQFontFamily_PingFangSC_Regular = @"PingFangSC-Regular";
MQFontFamilyName MQFontFamily_PingFangSC_Medium = @"PingFangSC-Medium";
MQFontFamilyName MQFontFamily_PingFangSC_Bold = @"PingFangSC-Bold";

@implementation UIFont (MQExtension)

- (instancetype) mq_size : (CGFloat) f_size {
    return [self fontWithSize:f_size];
}
+ (instancetype) mq_system : (CGFloat) f_size {
    return [UIFont systemFontOfSize:f_size];
}
+ (instancetype) mq_bold : (CGFloat) f_size {
    return [UIFont boldSystemFontOfSize:f_size];
}
+ (instancetype) mq_family : (NSString *) s_font_name
                      size : (CGFloat) f_size {
    if ([s_font_name isKindOfClass:NSString.class] && s_font_name && s_font_name.length) {
        return [UIFont fontWithName:s_font_name size:f_size];
    }
    return [self mq_system:f_size];
}

+ (instancetype) mq_italic : (UIFont *) font
                      size : (CGFloat) f_size {
    return [self mq_italic:font size:f_size angle_percent:5];
}
+ (instancetype) mq_italic : (UIFont *) font
                      size : (CGFloat) f_size
             angle_percent : (CGFloat) percent {
    CGAffineTransform transform = CGAffineTransformMake(1, 0, tanf(percent * (CGFloat)M_PI / 180), 1, 0, 0);
    UIFontDescriptor * descriptor = [UIFontDescriptor fontDescriptorWithName:font.fontName
                                                                      matrix:transform];
    return [UIFont fontWithDescriptor:descriptor size:f_size];
}

@end
