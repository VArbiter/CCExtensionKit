//
//  UILabel+CCExtension.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/1.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "UILabel+CCExtension.h"
#import "UIView+CCExtension.h"

@implementation UILabel (CCExtension)

+ (instancetype) common : (CGRect) frame {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    label.lineBreakMode = NSLineBreakByWordWrapping;
    return label;
}

- (instancetype) ccAutoHeight : (CGFloat) fEstimate {
    if (self.attributedText
        && self.attributedText.length) return [self ccAttributedTextHeight:fEstimate];
    if (self.text && self.text.length) return [self ccTextHeight:fEstimate];
    return self;
}
- (instancetype) ccAttributedTextHeight : (CGFloat) fEstimate {
    self.height = CC_TEXT_HEIGHT_A(self.width,
                                   fEstimate,
                                   self.attributedText);
    return self;
}
- (instancetype) ccTextHeight : (CGFloat) fEstimate {
    self.height = CC_TEXT_HEIGHT_C(self.width,
                                   fEstimate,
                                   self.text,
                                   self.font,
                                   self.lineBreakMode);
    return self;
}

@end
