//
//  UIButton+CCExtension.m
//  CCExtensionKit
//
//  Created by 冯明庆 on 2017/4/6.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "UIButton+CCExtension.h"
#import <objc/runtime.h>

static const char * _CC_UIBUTTON_CHAIN_CLICK_ASSOCIATE_KEY_ = "CC_UIBUTTON_CHAIN_CLICK_ASSOCIATE_KEY";

@interface UIButton (CCExtension_Assit)

- (void) ccButtonExtensionAction : ( __kindof UIButton *) sender ;

@end

@implementation UIButton (CCExtension_Assit)

- (void) ccButtonExtensionAction : ( __kindof UIButton *) sender {
    void (^t)( __kindof UIButton *) = objc_getAssociatedObject(self, _CC_UIBUTTON_CHAIN_CLICK_ASSOCIATE_KEY_);
    if (t) {
        if (NSThread.isMainThread) t(sender);
        else dispatch_sync(dispatch_get_main_queue(), ^{
            t(sender);
        });
    }
}

@end

@implementation UIButton (CCExtension)

+ (instancetype) cc_common {
    return [self cc_common:UIButtonTypeCustom];
}
+ (instancetype) cc_common : (UIButtonType) type {
    return [UIButton buttonWithType:type];
}

/// titles && images
- (instancetype) cc_title : (NSString *) sTitle
                    state : (UIControlState) state {
    [self setTitle:sTitle forState:state];
    return self;
}
- (instancetype) cc_image : (UIImage *) image
                    state : (UIControlState) state {
    [self setImage:image forState:state];
    return self;
}

/// actions , default is touchUpInside
- (instancetype) cc_action : (void (^)( __kindof UIButton *sender)) action {
    return [self cc_target:self action:action];
}
- (instancetype) cc_target : (id) target
                    action : (void (^)( __kindof UIButton *sender)) action {
    objc_setAssociatedObject(self, _CC_UIBUTTON_CHAIN_CLICK_ASSOCIATE_KEY_, action, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:target
              action:@selector(ccButtonExtensionAction:)
    forControlEvents:UIControlEventTouchUpInside];
    return self;
}

/// custom actions .
- (instancetype) cc_custom : (id) target
                       sel : (SEL) sel
                    events : (UIControlEvents) events {
    [self addTarget:(target ? target : self)
             action:sel
   forControlEvents:events];
    return self;
}

@end
