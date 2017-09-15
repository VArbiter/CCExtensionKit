//
//  UITextView+CCExtension.m
//  CCLocalLibrary
//
//  Created by Elwinfrederick on 14/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "UITextView+CCExtension.h"

@implementation UITextView (CCExtension)

+ (instancetype) common : (CGRect) frame {
    UITextView *v = [[UITextView alloc] initWithFrame:frame];
    v.layer.backgroundColor = UIColor.clearColor.CGColor;
    v.editable = YES;
    v.selectable = false;
    return v;
}

- (instancetype) ccDelegateT : (id <UITextViewDelegate>) delegate {
    if (delegate) self.delegate = delegate;
    else self.delegate = nil;
    return self;
}
- (instancetype) ccContainerInsets : (UIEdgeInsets) insets {
    self.textContainerInset = insets;
    return self;
}

@end
