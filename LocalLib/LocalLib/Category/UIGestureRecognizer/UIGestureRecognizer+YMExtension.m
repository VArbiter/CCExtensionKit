//
//  UIGestureRecognizer+YMExtension.m
//  ym_sell_ios
//
//  Created by 冯明庆 on 2017/4/16.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "UIGestureRecognizer+YMExtension.h"
#import <objc/runtime.h>

const char * _YM_GESTURE_KEY_ ;

@implementation UIGestureRecognizer (YMExtension)

- (void) ymGestureAction : (UITapGestureRecognizer *) sender {
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
    objc_setAssociatedObject(self, &_YM_GESTURE_KEY_, blockClick, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (dispatch_block_t)blockClick {
    return objc_getAssociatedObject(self, &_YM_GESTURE_KEY_);
}

@end
