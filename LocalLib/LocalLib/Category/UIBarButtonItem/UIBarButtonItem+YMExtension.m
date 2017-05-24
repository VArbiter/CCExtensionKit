//
//  UIBarButtonItem+YMExtension.m
//  ym_sell_ios
//
//  Created by 冯明庆 on 2017/4/26.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "UIBarButtonItem+YMExtension.h"

#import <objc/runtime.h>
#import "UIImage+YMExtension.h"

const char * _YM_BAR_BUTTON_ITEM_CLICK_KEY_ ;

@implementation UIBarButtonItem (YMExtension)

+ (instancetype) ymInitWithImage : (NSString *) stringImageName
                  withClickBlock : (void(^)(UIBarButtonItem *sender)) blockClick {
    return [self ymInitWithImage:stringImageName
                       withStyle:UIBarButtonItemStylePlain
                  withClickBlock:blockClick];
}
+ (instancetype) ymInitWithImage : (NSString *) stringImageName
                       withStyle : (UIBarButtonItemStyle) style
                  withClickBlock : (void(^)(UIBarButtonItem *sender)) blockClick {
    UIImage *image = [[UIImage ymImageNamed:stringImageName] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 30, 0, 0)];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:image
                                                             style:style
                                                            target:nil
                                                            action:nil];
    item.blockClick = [blockClick copy];
    [item setTarget:item];
    [item setAction:@selector(ymBarButtonAction:)];
    return item;
}

+ (instancetype) ymInitWithImage : (NSString *) stringImageName
                      withTarget : (id) target
                    withSelector : (SEL) selector {
    return [self ymInitWithImage:stringImageName
                       withStyle:UIBarButtonItemStylePlain
                      withTarget:target
                    withSelector:selector];
}
+ (instancetype) ymInitWithImage : (NSString *) stringImageName
                       withStyle : (UIBarButtonItemStyle) style
                      withTarget : (id) target
                    withSelector : (SEL) selector {
    UIImage *image = [[UIImage ymImageNamed:stringImageName] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 30, 0, 0)];
    
    UIBarButtonItem *item = nil;
    if (target && selector) {
        if ([target respondsToSelector:selector]) {
            item = [[UIBarButtonItem alloc] initWithImage:image
                                                    style:style
                                                   target:target
                                                   action:selector];
            return item;
        }
    }
    item = [[UIBarButtonItem alloc] initWithImage:image
                                            style:style
                                           target:nil
                                           action:nil];
    
    return item;
}

- (void)setBlockClick:(void (^)(UIBarButtonItem *))blockClick {
    objc_setAssociatedObject(self, &_YM_BAR_BUTTON_ITEM_CLICK_KEY_, blockClick, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void (^)(UIBarButtonItem *))blockClick {
    return objc_getAssociatedObject(self, &_YM_BAR_BUTTON_ITEM_CLICK_KEY_);
}

- (void) ymBarButtonAction : (UIBarButtonItem *) sender {
    if (self.blockClick) {
        if ([NSThread isMainThread])
            self.blockClick(sender);
        else {
            __weak typeof(self) pSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                pSelf.blockClick(sender);
            });
        }
    }
}

@end
