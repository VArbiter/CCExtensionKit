//
//  UITextField+MQExtension.h
//  MQExtensionKit
//
//  Created by 冯明庆 on 2017/4/5.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIControl+MQExtension.h"

@interface UITextField (MQExtension)

+ (instancetype) mq_common : (CGRect) frame ;

- (instancetype) mq_delegate : (id <UITextFieldDelegate>) delegete ;
- (instancetype) mq_place_holder : (NSDictionary <NSString * , id> *) dAttributes
                          string : (NSString *) string ;

/// default with a image View that already size-to-fit with original image . // 默认使用一个 sizeToFit 的 imageView (original) .
- (instancetype) mq_left_view : (UIImage *) image
                         mode : (UITextFieldViewMode) mode ;
- (instancetype) mq_right_view : (UIImage *) image
                          mode : (UITextFieldViewMode) mode ;

@property (nonatomic , readonly) BOOL mq_resign_first_responder;

/// observer text did change // 监听 textField 输入变化
/// note : it has no conflict on [UITextField.instance ccTextEvent:action:] // 和 [UITextField.instance ccTextEvent:action:] 没有冲突
/// note : therefore when use [UITextField.instance ccTextDidChange:] // 所以使用 [UITextField.instance ccTextDidChange:] 的时候
/// note : [UITextField.instance ccTextEvent:UIControlEventEditingChanged action:***] not should be done . // [UITextField.instance ccTextEvent:UIControlEventEditingChanged action:***] 不应该被实现
- (instancetype) mq_text_did_change : (void (^)(__kindof UITextField *sender)) bChanged ;

/// note : only events below allowed // 仅仅下列事件被允许
/// note : if you accidently removed the event of 'UIControlEventEditingChanged' // 如果你不小心移除了 UIControlEventEditingChanged
/// note : [UITextField.instance ccTextDidChange:] will also , has no effect // [UITextField.instance ccTextDidChange:] 将会没有任何效果
/// note : all events within , always respond the latest action . // 所有的事件 , 响应到最近的
/// note : that means , for single instance , it's shared . // 所以 针对单个的实例来说 , 它是共享的
// UIControlEventEditingDidBegin
// UIControlEventEditingChanged
// UIControlEventEditingDidEnd
// UIControlEventEditingDidEndOnExit , return key to end it .
- (instancetype) mq_text_shared_event : (UIControlEvents) event
                               action : (void (^)(__kindof UITextField *sender)) bEvent ;

@end
