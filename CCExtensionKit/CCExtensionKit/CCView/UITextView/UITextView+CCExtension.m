//
//  UITextView+CCExtension.m
//  CCLocalLibrary
//
//  Created by Elwinfrederick on 14/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "UITextView+CCExtension.h"

@implementation UITextView (CCExtension)

- (instancetype) cc_make_default {
    self.layer.backgroundColor = UIColor.clearColor.CGColor;
    self.editable = YES;
    self.selectable = false;
    return self;
}

- (instancetype) cc_delegate : (id <UITextViewDelegate>) delegate {
    if (delegate) self.delegate = delegate;
    else self.delegate = nil;
    return self;
}
- (instancetype) cc_container_insets : (UIEdgeInsets) insets {
    self.textContainerInset = insets;
    return self;
}

@end
