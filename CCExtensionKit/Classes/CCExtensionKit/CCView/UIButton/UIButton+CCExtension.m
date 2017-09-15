//
//  UIButton+CCExtension.m
//  CCLocalLibrary
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

+ (instancetype) common {
    return [self common:UIButtonTypeCustom];
}
+ (instancetype) common : (UIButtonType) type {
    return [UIButton buttonWithType:type];
}
- (instancetype) ccFrame : (CGRect) frame {
    self.frame = frame;
    return self;
}

/// titles && images
- (instancetype) ccTitle : (NSString *) sTitle
                   state : (UIControlState) state {
    [self setTitle:sTitle forState:state];
    return self;
}
- (instancetype) ccImage : (UIImage *) image
                   state : (UIControlState) state {
    [self setImage:image forState:state];
    return self;
}

/// actions , default is touchUpInside
- (instancetype) ccAction : (void (^)( __kindof UIButton *sender)) action {
    return [self ccTarget:self action:action];
}
- (instancetype) ccTarget : (id) target
                   action : (void (^)( __kindof UIButton *sender)) action {
    objc_setAssociatedObject(self, _CC_UIBUTTON_CHAIN_CLICK_ASSOCIATE_KEY_, action, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:target
              action:@selector(ccButtonExtensionAction:)
    forControlEvents:UIControlEventTouchUpInside];
    return self;
}

/// custom actions .
- (instancetype) ccCustom : (id) target
                      sel : (SEL) sel
                   events : (UIControlEvents) events {
    [self addTarget:(target ? target : self)
             action:sel
   forControlEvents:events];
    return self;
}

@end
