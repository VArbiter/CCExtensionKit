//
//  UILabel+CCExtension.m
//  CCExtensionKit
//
//  Created by 冯明庆 on 2017/4/1.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "UILabel+CCExtension.h"
#import "UIView+CCExtension.h"

@implementation UILabel (CCExtension)

+ (instancetype) cc_common : (CGRect) frame {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    label.lineBreakMode = NSLineBreakByWordWrapping;
    return label;
}

- (instancetype) cc_auto_height : (CGFloat) fEstimate {
    if (self.attributedText
        && self.attributedText.length) return [self cc_attributed_text_height:fEstimate];
    if (self.text && self.text.length) return [self cc_text_height:fEstimate];
    return self;
}
- (instancetype) cc_attributed_text_height : (CGFloat) fEstimate {
    self.height = CC_TEXT_HEIGHT_A(self.width,
                                   fEstimate,
                                   self.attributedText);
    return self;
}
- (instancetype) cc_text_height : (CGFloat) fEstimate {
    self.height = CC_TEXT_HEIGHT_C(self.width,
                                   fEstimate,
                                   self.text,
                                   self.font,
                                   self.lineBreakMode);
    return self;
}

- (instancetype) cc_attributed_text_height_t : (CGFloat)fEstimate {
    CGSize size = [self sizeThatFits:CGSizeMake(self.width, MAXFLOAT)];
    if (size.height > fEstimate) self.height = size.height;
    else self.height = fEstimate;
    return self;
}

@end
