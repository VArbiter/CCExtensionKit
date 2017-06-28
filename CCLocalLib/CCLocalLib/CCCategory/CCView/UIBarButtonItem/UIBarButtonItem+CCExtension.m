//
//  UIBarButtonItem+CCExtension.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/26.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "UIBarButtonItem+CCExtension.h"

#import <objc/runtime.h>
#import "UIImage+CCExtension.h"

@implementation UIBarButtonItem (CCExtension)

+ (instancetype) ccInitByImage : (NSString *) stringImageName
                          click: (void(^)(UIBarButtonItem *sender)) blockClick {
    return [self ccInitByImage:stringImageName
                         style:UIBarButtonItemStylePlain
                         click:blockClick];
}
+ (instancetype) ccInitByImage : (NSString *) stringImageName
                         style : (UIBarButtonItemStyle) style
                         click : (void(^)(UIBarButtonItem *sender)) blockClick {
    UIImage *image = [[UIImage ccImage:stringImageName] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 30, 0, 0)];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:image
                                                             style:style
                                                            target:nil
                                                            action:nil];
    item.blockClick = [blockClick copy];
    [item setTarget:item];
    [item setAction:@selector(ccBarButtonAction:)];
    return item;
}

+ (instancetype) ccInitByImage : (NSString *) stringImageName
                        target : (id) target
                      selector : (SEL) selector {
    return [self ccInitByImage:stringImageName
                         style:UIBarButtonItemStylePlain
                        target:target
                      selector:selector];
}
+ (instancetype) ccInitByImage : (NSString *) stringImageName
                         style : (UIBarButtonItemStyle) style
                        target : (id) target
                      selector : (SEL) selector {
    UIImage *image = [[UIImage ccImage:stringImageName] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 30, 0, 0)];
    
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
    objc_setAssociatedObject(self, @selector(blockClick), blockClick, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void (^)(UIBarButtonItem *))blockClick {
    return objc_getAssociatedObject(self, _cmd);
}

- (void) ccBarButtonAction : (UIBarButtonItem *) sender {
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
