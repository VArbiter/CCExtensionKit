//
//  UITextView+CCExtension.h
//  CCLocalLibrary
//
//  Created by Elwinfrederick on 14/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (CCExtension)

/// default , selectable = false
+ (instancetype) common : (CGRect) frame ;

- (instancetype) ccDelegateT : (id <UITextViewDelegate>) delegate ;
- (instancetype) ccContainerInsets : (UIEdgeInsets) insets ;

@end
