//
//  UIFont+MQExtension.m
//  MQExtensionKit
//
//  Created by Elwinfrederick on 08/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "UIFont+MQExtension.h"

CCFontFamilyName CCFontFamily_PingFangSC_Regular = @"PingFangSC-Regular";
CCFontFamilyName CCFontFamily_PingFangSC_Medium = @"PingFangSC-Medium";
CCFontFamilyName CCFontFamily_PingFangSC_Bold = @"PingFangSC-Bold";

@implementation UIFont (MQExtension)

- (instancetype) mq_size : (CGFloat) fSize {
    return [self fontWithSize:fSize];
}
+ (instancetype) mq_system : (CGFloat) fSize {
    return [UIFont systemFontOfSize:fSize];
}
+ (instancetype) mq_bold : (CGFloat) fSize {
    return [UIFont boldSystemFontOfSize:fSize];
}
+ (instancetype) mq_family : (NSString *) sFontName
                      size : (CGFloat) fSize {
    if ([sFontName isKindOfClass:NSString.class] && sFontName && sFontName.length) {
        return [UIFont fontWithName:sFontName size:fSize];
    }
    return [self mq_system:fSize];
}

+ (instancetype) mq_italic : (UIFont *) font
                      size : (CGFloat) fSize {
    return [self mq_italic:font size:fSize angle_percent:5];
}
+ (instancetype) mq_italic : (UIFont *) font
                      size : (CGFloat) fSize
             angle_percent : (CGFloat) percent {
    CGAffineTransform transform = CGAffineTransformMake(1, 0, tanf(percent * (CGFloat)M_PI / 180), 1, 0, 0);
    UIFontDescriptor * descriptor = [UIFontDescriptor fontDescriptorWithName:font.fontName
                                                                      matrix:transform];
    return [UIFont fontWithDescriptor:descriptor size:fSize];
}

@end
