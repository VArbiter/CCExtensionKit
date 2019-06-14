//
//  UILabel+MQExtension.m
//  MQExtensionKit
//
//  Created by 冯明庆 on 2017/4/1.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "UILabel+MQExtension.h"

@implementation UILabel (MQExtension)

+ (instancetype) mq_common : (CGRect) frame {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    label.lineBreakMode = NSLineBreakByWordWrapping;
    return label;
}

- (CGSize) mq_attributed_text_height : (CGFloat) f_estimate
                               style : ( NSParagraphStyle * _Nonnull ) style
                                font : ( UIFont * _Nonnull ) font
                                text : ( NSString * _Nonnull ) s_text ; {
    
    CGSize size = [self sizeThatFits:CGSizeMake(self.bounds.size.width, MAXFLOAT)];
    
    BOOL (^cc_is_contains_chinese)(NSString *) = ^BOOL (NSString *s) {
        NSString *s_t = [NSString stringWithFormat:@"%@",s];
        for(int i = 0 ; i < s_t.length ; i++){
            int t = [s_t characterAtIndex:i];
            if( t >= 0x4e00 && t <= 0x9fff) return YES ;
        }
        return false;
    };
    
    NSInteger i_space = size.height - font.lineHeight;
    if (i_space <= style.lineSpacing) {
        if (cc_is_contains_chinese(s_text)) {
            CGFloat f_height = size.height - style.lineSpacing ;
            return (CGSize){size.width,(f_height > f_estimate ? f_height : f_estimate)};
        }
    }
    
    return (CGSize){size.width,(size.height > f_estimate ? size.height : f_estimate)};
}

@end
