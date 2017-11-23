//
//  UITextField+CCExtension.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/5.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIControl+CCExtension.h"

@interface UITextField (CCExtension)

+ (instancetype) common : (CGRect) frame ;
- (instancetype) ccDelegateT : (id <UITextFieldDelegate>) delegete ;
- (instancetype) ccPlaceHolder : (NSDictionary <NSString * , id> *) dAttributes
                        string : (NSString *) string ;

/// default with a image View that already size-to-fit with original image .
- (instancetype) ccLeftView : (UIImage *) image
                       mode : (UITextFieldViewMode) mode ;
- (instancetype) ccRightView : (UIImage *) image
                        mode : (UITextFieldViewMode) mode ;

@property (nonatomic , readonly) BOOL resignFirstResponderT;

/// observer text did change
/// note : it has no conflict on [UITextField.instance ccTextEvent:action:]
/// note : therefore when use [UITextField.instance ccTextDidChange:]
/// note : [UITextField.instance ccTextEvent:UIControlEventEditingChanged action:***] not should be done .
- (instancetype) ccTextDidChange : (void (^)(__kindof UITextField *sender)) bChanged ;

/// note : only events below allowed
/// note : if you accidently removed the event of 'UIControlEventEditingChanged'
/// note : [UITextField.instance ccTextDidChange:] will also , has no effect
/// note : all events within , always respond the latest action .
/// note : that means , for single instance , it's shared .
// UIControlEventEditingDidBegin
// UIControlEventEditingChanged
// UIControlEventEditingDidEnd
// UIControlEventEditingDidEndOnExit , return key to end it .
- (instancetype) ccTextSharedEvent : (UIControlEvents) event
                            action : (void (^)(__kindof UITextField *sender)) bEvent ;

@end
