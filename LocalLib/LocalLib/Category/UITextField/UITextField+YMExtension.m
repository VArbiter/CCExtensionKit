//
//  UITextField+YMExtension.m
//  ym_sell_ios
//
//  Created by 冯明庆 on 2017/4/5.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "UITextField+YMExtension.h"
#import "YMCommonDefine.h"

@implementation UITextField (YMExtension)

+ (UITextField *) ymCommonSettingsWithFrame : (CGRect) rectFrame {
    return [self ymCommonSettingsWithFrame:rectFrame
                              withDelegate:nil];
}
+ (UITextField *) ymCommonSettingsWithFrame : (CGRect) rectFrame
                               withDelegate : (id) delegate {
    UITextField *textField = [[UITextField alloc] initWithFrame:rectFrame];
    textField.textColor = [UIColor whiteColor];
    textField.clearsOnBeginEditing = YES;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing ;
    textField.font = [UIFont systemFontOfSize:_YM_DEFAULT_FONT_SIZE_];
    if (delegate) {
        textField.delegate = delegate;
    }
    return textField;
}

- (void) ymSetRightViewWithImageName : (NSString *) stringImageName{
    UIImage *image = [ymImage(stringImageName, YES) imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [imageView sizeToFit];
    self.rightViewMode = UITextFieldViewModeAlways;
    self.rightView = imageView;
}

- (BOOL) ymResignFirstResponder {
    BOOL isCan = [self canResignFirstResponder];
    if (isCan) {
        [self resignFirstResponder];
    }
    return isCan;
}

@end
