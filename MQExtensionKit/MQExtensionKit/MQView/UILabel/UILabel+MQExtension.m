//
//  UILabel+MQExtension.m
//  MQExtensionKit
//
//  Created by 冯明庆 on 2017/4/1.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "UILabel+MQExtension.h"
#import "UIView+MQExtension.h"

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

- (instancetype) mq_auto_height : (CGFloat) f_estimate {
    if (self.attributedText
        && self.attributedText.length) return [self mq_attributed_text_height:f_estimate];
    if (self.text && self.text.length) return [self mq_text_height:f_estimate];
    return self;
}
- (instancetype) mq_attributed_text_height : (CGFloat) f_estimate {
    self.height = MQ_TEXT_HEIGHT_A(self.width,
                                   f_estimate,
                                   self.attributedText);
    return self;
}
- (instancetype) mq_text_height : (CGFloat) f_estimate {
    self.height = MQ_TEXT_HEIGHT_C(self.width,
                                   f_estimate,
                                   self.text,
                                   self.font,
                                   self.lineBreakMode);
    return self;
}

- (CGSize) mq_attributed_text_height : (CGFloat) f_estimate
                               style : ( NSParagraphStyle * _Nonnull ) style
                                font : ( UIFont * _Nonnull ) font
                                text : ( NSString * _Nonnull ) s_text ; {
    
    CGSize size = [self sizeThatFits:CGSizeMake(self.width, MAXFLOAT)];
    
    BOOL (^cc_is_contains_chinese)(NSString *) = ^BOOL (NSString *s) {
        NSString *s_t = [NSString stringWithFormat:@"%@",s];
        for(int i = 0 ; i < s_t.length ; i++){
            int t = [s_t characterAtIndex:i];
            if( t > 0x4e00 && t < 0x9fff) return YES ;
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
