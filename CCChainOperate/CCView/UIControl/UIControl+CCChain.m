//
//  UIControl+CCChain.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 08/08/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "UIControl+CCChain.h"
#import <objc/runtime.h>

static const char * _CC_UICONTROL_CHAIN_CLICK_ASSOCIATE_KEY_ = "CC_UICONTROL_CHAIN_CLICK_ASSOCIATE_KEY";

@interface UIButton (CCChain_Assit)

- (void) ccControlChainAction : (UIButton *) sender ;

@end

@implementation UIButton (CCChain_Assit)

- (void) ccControlChainAction : (UIButton *) sender {
    void (^t)(UIButton *) = objc_getAssociatedObject(self, _CC_UICONTROL_CHAIN_CLICK_ASSOCIATE_KEY_);
    if (t) {
        if (NSThread.isMainThread) t(sender);
        else dispatch_sync(dispatch_get_main_queue(), ^{
            t(sender);
        });
    }
}

@end

#pragma mark - -----

@implementation UIControl (CCChain)

+ (UIControl *(^)(CCRect))commonS {
    return ^UIControl *(CCRect r) {
         return self.commonC(CGMakeRectFrom(r));
    };
}

+ (UIControl *(^)(CGRect))commonC {
    return ^UIControl *(CGRect r) {
        UIControl *c = [[self alloc] initWithFrame:r];
        c.userInteractionEnabled = YES;
        return c;
    };
}

- (UIControl *(^)(void (^)(UIControl *)))actionS {
    __weak typeof(self) pSelf = self;
    return ^UIControl *(void (^t)(UIControl *)) {
        return pSelf.targetS(pSelf, t);
    };
}

- (UIControl *(^)(id, void (^)(UIControl *)))targetS {
    __weak typeof(self) pSelf = self;
    return ^UIControl *(id v , void (^t)(UIControl *)) {
        objc_setAssociatedObject(pSelf, _CC_UICONTROL_CHAIN_CLICK_ASSOCIATE_KEY_, t, OBJC_ASSOCIATION_COPY_NONATOMIC);
        [pSelf addTarget:t
                  action:@selector(ccControlChainAction:)
        forControlEvents:UIControlEventTouchUpInside];
        return pSelf;
    };
}

- (UIControl *(^)(id, SEL, UIControlEvents))custom {
    __weak typeof(self) pSelf = self;
    return ^UIControl *(id v , SEL s , UIControlEvents e) {
        [pSelf addTarget:(v ? v : pSelf)
                  action:s
        forControlEvents:e];
        return pSelf;
    };
}

@end
