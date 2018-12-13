//
//  UITextField+MQExtension.m
//  MQExtensionKit
//
//  Created by 冯明庆 on 2017/4/5.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "UITextField+MQExtension.h"
#import <objc/runtime.h>

@interface UITextField (MQExtension_Assist)

- (void) mq_textfield_text_did_change : (__kindof UITextField *) sender ;

@end

@implementation UITextField (MQExtension_Assist)

- (void) mq_textfield_text_did_change : (__kindof UITextField *) sender {
    void (^block_changed)(__kindof UITextField *sender) = objc_getAssociatedObject(self, "MQ_TEXT_FIELD_TEXT_DID_CHANGE_ACTION");
    if (block_changed) block_changed(sender);
}

@end

#pragma mark - -----

@implementation UITextField (MQExtension)

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
- (instancetype) mq_place_holder : (NSDictionary <NSString * , id> *) dict_attributes
                          string : (NSString *) string {
    if (![string isKindOfClass:NSString.class] || !string || !string.length) return self;
    NSAttributedString *s_attr = [[NSAttributedString alloc] initWithString:string
                                                                 attributes:dict_attributes];
    self.attributedPlaceholder = s_attr;
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

- (instancetype) mq_text_did_change : (void (^)(__kindof UITextField *sender)) block_changed {
    if (!block_changed) return self;
    objc_setAssociatedObject(self, "MQ_TEXT_FIELD_TEXT_DID_CHANGE_ACTION", block_changed, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self
             action:@selector(mq_textfield_text_did_change:)
   forControlEvents:UIControlEventEditingChanged];
    return self;
}

- (instancetype) mq_text_shared_event : (UIControlEvents) event
                               action : (void (^)(__kindof UITextField *sender)) block_event {
    if (event & UIControlEventEditingDidBegin
        || event & UIControlEventEditingChanged
        || event & UIControlEventEditingDidEnd
        || event & UIControlEventEditingDidEndOnExit) {
        return [self mq_shared_control_event:event actions:^(__kindof UIControl *sender) {
            if (block_event) block_event(((UITextField *) sender));
        }];
    }
    return self;
}


@end
