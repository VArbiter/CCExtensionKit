//
//  UITextField+CCExtension.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/5.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "UITextField+CCExtension.h"

@implementation UITextField (CCExtension)

+ (instancetype) common : (CGRect) frame {
    UITextField *v = [[UITextField alloc] initWithFrame:frame];
    v.clearsOnBeginEditing = YES;
    v.clearButtonMode = UITextFieldViewModeWhileEditing ;
    return v;
}
- (instancetype) ccDelegateT : (id <UITextFieldDelegate>) delegete {
    if (delegete) self.delegate = delegete;
    else self.delegate = nil;
    return self;
}
- (instancetype) ccPlaceHolder : (NSDictionary <NSString * , id> *) dAttributes
                        string : (NSString *) string {
    if (![string isKindOfClass:NSString.class] || !string || !string.length) return self;
    NSAttributedString *sAttr = [[NSAttributedString alloc] initWithString:string
                                                                attributes:dAttributes];
    self.attributedPlaceholder = sAttr;
    return self;
}

- (instancetype) ccLeftView : (UIImage *) image
                       mode : (UITextFieldViewMode) mode {
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImageView *v = [[UIImageView alloc] initWithImage:image];
    v.contentMode = UIViewContentModeScaleAspectFit;
    [v sizeToFit];
    self.rightViewMode = mode;
    self.rightView = v;
    return self;
}
- (instancetype) ccRightView : (UIImage *) image
                        mode : (UITextFieldViewMode) mode {
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImageView *v = [[UIImageView alloc] initWithImage:image];
    v.contentMode = UIViewContentModeScaleAspectFit;
    [v sizeToFit];
    self.leftViewMode = mode;
    self.leftView = v;
    return self;
}

- (BOOL)resignFirstResponderT {
    BOOL b = [self canResignFirstResponder];
    if (b) [self resignFirstResponder];
    return b;
}

@end
