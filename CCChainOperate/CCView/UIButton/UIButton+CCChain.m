//
//  UIButton+CCChain.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 06/08/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "UIButton+CCChain.h"
#import <objc/runtime.h>

static const char * _CC_UIBUTTON_CHAIN_CLICK_ASSOCIATE_KEY_ = "CC_UIBUTTON_CHAIN_CLICK_ASSOCIATE_KEY";

@interface UIButton (CCChain_Assit)

- (void) ccButtonChainAction : (UIButton *) sender ;

@end

@implementation UIButton (CCChain_Assit)

- (void) ccButtonChainAction : (UIButton *) sender {
    void (^t)(UIButton *) = objc_getAssociatedObject(self, _CC_UIBUTTON_CHAIN_CLICK_ASSOCIATE_KEY_);
    if (t) {
        if (NSThread.isMainThread) t(sender);
        else dispatch_sync(dispatch_get_main_queue(), ^{
            t(sender);
        });
    }
}

@end

#pragma mark - -----

@implementation UIButton (CCChain)

+ (UIButton *(^)())common {
    return ^UIButton * {
        return self.commonS(UIButtonTypeCustom);
    };
}
+ (UIButton *(^)(UIButtonType))commonS {
    return ^UIButton * (UIButtonType t) {
        return [UIButton buttonWithType:t];
    };
}

- (UIButton *(^)(CCRect))frameS {
    __weak typeof(self) pSelf = self;
    return ^UIButton *(CCRect r) {
        return pSelf.frameC(CGMakeRectFrom(r));
    };
}
- (UIButton *(^)(CGRect))frameC {
    __weak typeof(self) pSelf = self;
    return ^UIButton *(CGRect r) {
        pSelf.frame = r;
        return pSelf;
    };
}

- (UIButton *(^)(NSString *, UIControlState))titleS {
    __weak typeof(self) pSelf = self;
    return ^UIButton *(NSString *s , UIControlState t) {
        [pSelf setTitle:s forState:t];
        return pSelf;
    };
}

- (UIButton *(^)(UIImage *, UIControlState))imageS {
    __weak typeof(self) pSelf = self;
    return ^UIButton *(UIImage *m , UIControlState t) {
        [pSelf setImage:m forState:t];
        return pSelf;
    };
}

- (UIButton *(^)(void (^)(UIButton *)))actionS {
    __weak typeof(self) pSelf = self;
    return ^UIButton *(void (^t)(UIButton *)) {
        return pSelf.targetS(pSelf, t);
    };
}

- (UIButton *(^)(id, void (^)(UIButton *)))targetS {
    __weak typeof(self) pSelf = self;
    return ^UIButton *(id t , void (^b)(UIButton *)) {
        objc_setAssociatedObject(pSelf, _CC_UIBUTTON_CHAIN_CLICK_ASSOCIATE_KEY_, b, OBJC_ASSOCIATION_COPY_NONATOMIC);
        [pSelf addTarget:t
                  action:@selector(ccButtonChainAction:)
        forControlEvents:UIControlEventTouchUpInside];
        return pSelf;
    };
}

- (UIButton *(^)(id, SEL, UIControlEvents))custom {
    __weak typeof(self) pSelf = self;
    return ^UIButton *(id t, SEL s , UIControlEvents e) {
        [pSelf addTarget:(t ? t : pSelf)
                  action:s
        forControlEvents:e];
        return pSelf;
    };
}

@end
