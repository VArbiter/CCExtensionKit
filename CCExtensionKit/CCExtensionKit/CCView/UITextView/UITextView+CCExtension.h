//
//  UITextView+CCExtension.h
//  CCExtensionKit
//
//  Created by Elwinfrederick on 14/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (CCExtension)

/// use these initializer might cause a problem that make UITextView can't responding to user's tap .
// 使用这些初始化方式可能会导致 UITextField 无法响应用户事件
+ (instancetype) cc_common NS_UNAVAILABLE ;
+ (instancetype) cc_common : (CGRect) frame NS_UNAVAILABLE;

/// default , selectable = false // 不可选择
- (instancetype) cc_make_default ;
- (instancetype) cc_delegate : (id <UITextViewDelegate>) delegate ;
- (instancetype) cc_container_insets : (UIEdgeInsets) insets ;

@end
