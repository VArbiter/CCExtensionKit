//
//  UIGestureRecognizer+CCExtension.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/16.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "UIGestureRecognizer+CCExtension.h"
#import <objc/runtime.h>

@implementation UIGestureRecognizer (CCExtension)

- (void) ccGestureAction : (UITapGestureRecognizer *) sender {
    if (self.blockClick) {
        if ([NSThread isMainThread]) {
            self.blockClick();
        } else {
            __weak typeof(self) pSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                pSelf.blockClick();
            });
        }
    }
}

- (void)setBlockClick:(dispatch_block_t)blockClick {
    objc_setAssociatedObject(self, @selector(blockClick), blockClick, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (dispatch_block_t)blockClick {
    return objc_getAssociatedObject(self, _cmd);
}

@end
