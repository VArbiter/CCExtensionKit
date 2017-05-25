//
//  UITextField+CCExtension.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/5.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "UITextField+CCExtension.h"
#import "CCCommonDefine.h"

@implementation UITextField (CCExtension)

+ (UITextField *) ccCommonSettingsWithFrame : (CGRect) rectFrame {
    return [self ccCommonSettingsWithFrame:rectFrame
                              withDelegate:nil];
}
+ (UITextField *) ccCommonSettingsWithFrame : (CGRect) rectFrame
                               withDelegate : (id) delegate {
    UITextField *textField = [[UITextField alloc] initWithFrame:rectFrame];
    textField.textColor = [UIColor whiteColor];
    textField.clearsOnBeginEditing = YES;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing ;
    textField.font = [UIFont systemFontOfSize:_CC_DEFAULT_FONT_SIZE_];
    if (delegate) {
        textField.delegate = delegate;
    }
    return textField;
}

- (void) ccSetRightViewWithImageName : (NSString *) stringImageName{
    UIImage *image = [ccImage(stringImageName, YES) imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [imageView sizeToFit];
    self.rightViewMode = UITextFieldViewModeAlways;
    self.rightView = imageView;
}

- (BOOL) ccResignFirstResponder {
    BOOL isCan = [self canResignFirstResponder];
    if (isCan) {
        [self resignFirstResponder];
    }
    return isCan;
}

@end
