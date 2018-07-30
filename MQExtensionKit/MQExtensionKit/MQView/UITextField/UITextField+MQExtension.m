//
//  UITextField+MQExtension.m
//  MQExtensionKit
//
//  Created by 冯明庆 on 2017/4/5.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "UITextField+MQExtension.h"
#import <objc/runtime.h>

@interface UITextField (CCExtension_Assist)

- (void) ccTextFieldTextDidChange : (__kindof UITextField *) textField ;

@end

@implementation UITextField (CCExtension_Assist)

- (void) ccTextFieldTextDidChange : (__kindof UITextField *) textField {
    void (^bChanged)(__kindof UITextField *sender) = objc_getAssociatedObject(self, "CC_TEXT_FIELD_TEXT_DID_CHANGE_ACTION");
    if (bChanged) bChanged(textField);
}

@end

#pragma mark - -----

@implementation UITextField (CCExtension)

+ (instancetype) mq_common : (CGRect) frame {
    UITextField *v = [[UITextField alloc] initWithFrame:frame];
    v.clearsOnBeginEditing = YES;
    v.clearButtonMode = UITextFieldViewModeWhileEditing ;
    return v;
}
- (instancetype) mq_delegate : (id <UITextFieldDelegate>) delegete {
    if (delegete) self.delegate = delegete;
    else self.delegate = nil;
    return self;
}
- (instancetype) mq_place_holder : (NSDictionary <NSString * , id> *) dAttributes
                          string : (NSString *) string {
    if (![string isKindOfClass:NSString.class] || !string || !string.length) return self;
    NSAttributedString *sAttr = [[NSAttributedString alloc] initWithString:string
                                                                attributes:dAttributes];
    self.attributedPlaceholder = sAttr;
    return self;
}

- (instancetype) mq_left_view : (UIImage *) image
                         mode : (UITextFieldViewMode) mode {
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImageView *v = [[UIImageView alloc] initWithImage:image];
    v.contentMode = UIViewContentModeScaleAspectFit;
    [v sizeToFit];
    self.rightViewMode = mode;
    self.rightView = v;
    return self;
}
- (instancetype) mq_right_view : (UIImage *) image
                          mode : (UITextFieldViewMode) mode {
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImageView *v = [[UIImageView alloc] initWithImage:image];
    v.contentMode = UIViewContentModeScaleAspectFit;
    [v sizeToFit];
    self.leftViewMode = mode;
    self.leftView = v;
    return self;
}

- (BOOL)mq_resign_first_responder {
    BOOL b = [self canResignFirstResponder];
    if (b) [self resignFirstResponder];
    return b;
}

- (instancetype) mq_text_did_change : (void (^)(__kindof UITextField *sender)) bChanged {
    if (!bChanged) return self;
    objc_setAssociatedObject(self, "CC_TEXT_FIELD_TEXT_DID_CHANGE_ACTION", bChanged, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self
             action:@selector(ccTextFieldTextDidChange:)
   forControlEvents:UIControlEventEditingChanged];
    return self;
}

- (instancetype) mq_text_shared_event : (UIControlEvents) event
                               action : (void (^)(__kindof UITextField *sender)) bEvent {
    if (event & UIControlEventEditingDidBegin
        || event & UIControlEventEditingChanged
        || event & UIControlEventEditingDidEnd
        || event & UIControlEventEditingDidEndOnExit) {
        return [self mq_shared_control_event:event actions:^(__kindof UIControl *sender) {
            if (bEvent) bEvent(((UITextField *) sender));
        }];
    }
    return self;
}


@end
