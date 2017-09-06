//
//  UILabel+CCExtension.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/1.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "UILabel+CCExtension.h"
#import "CCCommonDefine.h"

@implementation UILabel (CCExtension)

+ (CGFloat) ccHeight : (NSString *) stringValue
               width : (CGFloat) floatWidth {
    return [self ccHeight:stringValue
                     font:[UIFont systemFontOfSize:_CC_DEFAULT_FONT_SIZE_]
                breakMode:NSLineBreakByWordWrapping
                    width:floatWidth];
}

+ (CGFloat) ccHeight : (NSString *) stringValue
                font : (UIFont *) font
           breakMode : (NSLineBreakMode) mode
               width : (CGFloat) floatWidth {
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineBreakMode:mode];
    return [stringValue boundingRectWithSize:CGSizeMake(floatWidth,
                                                        [[UIScreen mainScreen] bounds].size.height)
                                     options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName : font,
                                               NSParagraphStyleAttributeName : style}
                                     context:nil].size.height;
}

- (CGFloat) ccHeight : (NSString *) stringValue
               width : (CGFloat) floatWidth {
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineBreakMode:self.lineBreakMode];
    NSDictionary *dictionaryAttributes = @{ NSFontAttributeName : self.font,
                                            NSParagraphStyleAttributeName : style };
    
    return [stringValue boundingRectWithSize:CGSizeMake(floatWidth,
                                                        [[UIScreen mainScreen] bounds].size.height)
                                     options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                  attributes:dictionaryAttributes
                                     context:nil].size.height;
}

- (CGFloat) ccHeight {
    return [self ccHeight:self.text
                    width:self.frame.size.width];
}

+ (UILabel *) ccCommon : (CGRect) rectFrame {
    UILabel *label = [[UILabel alloc] initWithFrame:rectFrame];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:_CC_DEFAULT_FONT_SIZE_];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    label.lineBreakMode = NSLineBreakByWordWrapping;
    return label;
}

@end
