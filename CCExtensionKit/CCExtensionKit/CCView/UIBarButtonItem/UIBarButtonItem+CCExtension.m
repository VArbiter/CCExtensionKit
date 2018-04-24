//
//  UIBarButtonItem+CCExtension.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/26.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "UIBarButtonItem+CCExtension.h"
#import <objc/runtime.h>

static const char * _CC_UIBARBUTTONITEM_CLICK_ASSOCIATE_KEY_ = "CC_UIBARBUTTONITEM_CLICK_ASSOCIATE_KEY";

@interface UIBarButtonItem (CCExtension_Assit)

- (void) ccBarButtonItemExtensionAction : ( __kindof UIBarButtonItem *) sender ;

@end

@implementation UIBarButtonItem (CCExtension_Assit)

- (void) ccBarButtonItemExtensionAction : ( __kindof UIBarButtonItem *) sender {
    void (^t)( __kindof UIBarButtonItem *) = objc_getAssociatedObject(self, _CC_UIBARBUTTONITEM_CLICK_ASSOCIATE_KEY_);
    if (t) {
        if (NSThread.isMainThread) {
            t(sender);
        }
        else dispatch_sync(dispatch_get_main_queue(), ^{
            t(sender);
        });
    }
}

@end

#pragma mark - -----

@implementation UIBarButtonItem (CCExtension)

+ (instancetype) common {
    return UIBarButtonItem.alloc.init;
}
- (instancetype) cc_title : (NSString *) sTitle {
    self.title = sTitle;
    return self;
}
- (instancetype) cc_image : (UIImage *) image {
    if (!CGSizeEqualToSize(image.size, CGSizeZero)) {
        self.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    else self.image = image;
    return self;
}
- (instancetype) cc_action : (void (^)( __kindof UIBarButtonItem *sender)) action {
    if (action) return [self cc_target:self action:action];
    return self;
}
- (instancetype) cc_target : (id) target
                   action : (void (^)( __kindof UIBarButtonItem *sender)) action {
    if (action) objc_setAssociatedObject(self, _CC_UIBARBUTTONITEM_CLICK_ASSOCIATE_KEY_, action, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self setTarget:target];
    [self setAction:@selector(ccBarButtonItemExtensionAction:)];
    return self;
}

@end
