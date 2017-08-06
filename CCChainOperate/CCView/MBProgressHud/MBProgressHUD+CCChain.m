//
//  MBProgressHUD+CCChain.m
//  CCLocalLibrary
//
//  Created by Elwinfrederick on 02/08/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "MBProgressHUD+CCChain.h"

@implementation MBProgressHUD (CCChain)

+ (MBProgressHUD *(^)())initC {
    return ^MBProgressHUD * {
        return MBProgressHUD.initS(nil);
    };
}
+ (MBProgressHUD *(^)(UIView *))initS {
    return ^MBProgressHUD *(UIView *v) {
        if (!v) v = UIApplication.sharedApplication.keyWindow;
        if (!v) v = UIApplication.sharedApplication.delegate.window;
        return [MBProgressHUD showHUDAddedTo:v
                                    animated:YES].simple().enable();
    };
}
+ (MBProgressHUD *(^)())generate {
    return ^MBProgressHUD *{
        return MBProgressHUD.generateS(nil);
    };
}
+ (MBProgressHUD *(^)(UIView *))generateS {
    return ^MBProgressHUD *(UIView *v){
        if (!v) v = UIApplication.sharedApplication.keyWindow;
        if (!v) v = UIApplication.sharedApplication.delegate.window;
        return [[MBProgressHUD alloc] initWithView:v].simple().disableT();
    };
}

- (MBProgressHUD *(^)())enable {
    __weak typeof(self) pSelf = self;
    return ^MBProgressHUD * {
        pSelf.userInteractionEnabled = false;
        return pSelf;
    };
}

- (MBProgressHUD *(^)())disableT {
    __weak typeof(self) pSelf = self;
    return ^MBProgressHUD * {
        pSelf.userInteractionEnabled = YES;
        return pSelf;
    };
}

+ (BOOL (^)())hasHud {
    return ^BOOL {
        return self.hasHudS(nil);
    };
}
+ (BOOL (^)(UIView *))hasHudS {
    return  ^BOOL (UIView *v) {
        if (!v) v = UIApplication.sharedApplication.keyWindow;
        return !![MBProgressHUD HUDForView:v];
    };
}

- (MBProgressHUD *(^)())show {
    __weak typeof(self) pSelf = self;
    return ^MBProgressHUD *() {
        if (NSThread.isMainThread) [pSelf showAnimated:YES];
        else dispatch_sync(dispatch_get_main_queue(), ^{
            [pSelf showAnimated:YES];
        });
        return pSelf;
    };
}

- (void (^)())hide {
    __weak typeof(self) pSelf = self;
    return ^{
        pSelf.hideS(2.f);
    };
}
- (void (^)(NSTimeInterval))hideS {
    __weak typeof(self) pSelf = self;
    return ^(NSTimeInterval i) {
        pSelf.removeFromSuperViewOnHide = YES;
        if (i > .0f) {
            [pSelf hideAnimated:YES
                     afterDelay:i];
        }
        else [pSelf hideAnimated:YES];
    };
}

- (MBProgressHUD *(^)())indicatorD {
    __weak typeof(self) pSelf = self;
    return ^MBProgressHUD * {
        pSelf.mode = MBProgressHUDModeIndeterminate;
        return pSelf;
    };
}
- (MBProgressHUD *(^)())simple {
    __weak typeof(self) pSelf = self;
    return ^MBProgressHUD * {
        pSelf.mode = MBProgressHUDModeText;
        return pSelf;
    };
}

- (MBProgressHUD *(^)(NSString *))title {
    __weak typeof(self) pSelf = self;
    return ^MBProgressHUD * (NSString *t){
        pSelf.label.text = t;
        return pSelf;
    };
}
- (MBProgressHUD *(^)(NSString *))message {
    __weak typeof(self) pSelf = self;
    return ^MBProgressHUD *(NSString *m) {
        pSelf.detailsLabel.text = m;
        return pSelf;
    };
}

- (MBProgressHUD *(^)(CCHudChainType))type {
    __weak typeof(self) pSelf = self;
    return ^MBProgressHUD *(CCHudChainType t) {
        NSDictionary *d = @{@(CCHudChainTypeLight) : ^{
                                pSelf.contentColor = UIColor.blackColor;
                            },
                            @(CCHudChainTypeDarkDeep) : ^{
                                pSelf.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
                                pSelf.contentColor = UIColor.whiteColor;
                                pSelf.bezelView.backgroundColor = UIColor.blackColor;
                            },
                            @(CCHudChainTypeDark) : ^{
                                pSelf.contentColor = UIColor.whiteColor;
                                pSelf.bezelView.backgroundColor = UIColor.blackColor;
                            },
                            @(CCHudChainTypeNone) : ^{
                                pSelf.contentColor = UIColor.blackColor;
                            }};
        if (!d[@(t)]) return pSelf;
        void (^b)() = d[@(t)];
        if (b) b();
        return pSelf;
    };
}

- (MBProgressHUD *(^)(CGFloat))delay {
    __weak typeof(self) pSelf = self;
    return ^MBProgressHUD * (CGFloat f) {
        dispatch_time_t t = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(f * NSEC_PER_SEC));
        dispatch_after(t, dispatch_get_main_queue(), ^{
            pSelf.show();
        });
        return pSelf;
    };
}

- (MBProgressHUD *(^)(NSTimeInterval))grace {
    __weak typeof(self) pSelf = self;
    return ^MBProgressHUD *(NSTimeInterval i) {
        pSelf.graceTime = i;
        return pSelf;
    };
}

- (MBProgressHUD *(^)(NSTimeInterval))min {
    __weak typeof(self) pSelf = self;
    return ^MBProgressHUD *(NSTimeInterval i) {
        pSelf.minShowTime = i;
        return pSelf;
    };
}

- (MBProgressHUD *(^)(void (^)()))complete {
    __weak typeof(self) pSelf = self;
    return ^MBProgressHUD * (void (^t)()) {
        pSelf.completionBlock = t;
        return pSelf;
    };
}


@end
