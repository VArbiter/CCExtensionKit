//
//  MBProgressHUD+CCChain.m
//  CCLocalLibrary
//
//  Created by Elwinfrederick on 02/08/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "MBProgressHUD+CCChain.h"

@implementation MBProgressHUD (CCChain)

- (MBProgressHUD *(^)())enable {
    __weak typeof(self) pSelf = self;
    return ^MBProgressHUD * {
        pSelf.userInteractionEnabled = false;
        return pSelf;
    };
}

- (MBProgressHUD *(^)())disable {
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

+ (MBProgressHUD *(^)())show {
    __weak typeof(self) pSelf = self;
    return ^MBProgressHUD *() {
        return pSelf.showS(nil);
    };
}
+ (MBProgressHUD *(^)(UIView *))showS {
    return ^MBProgressHUD *(UIView *v) {
        if (!v) v = UIApplication.sharedApplication.keyWindow;
        return [MBProgressHUD showHUDAddedTo:v
                                    animated:YES].simple().disable();
    };
}

- (MBProgressHUD *(^)())hide {
    __weak typeof(self) pSelf = self;
    return ^MBProgressHUD * {
        return pSelf.hideS(2.f);
    };
}
- (MBProgressHUD *(^)(NSTimeInterval))hideS {
    __weak typeof(self) pSelf = self;
    return ^MBProgressHUD *(NSTimeInterval i) {
        pSelf.removeFromSuperViewOnHide = YES;
        if (i > .0f) {
            [pSelf hideAnimated:YES
                     afterDelay:i];
        }
        else [pSelf hideAnimated:YES];
        return pSelf;
    };
}

- (MBProgressHUD *(^)())indicator {
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

- (MBProgressHUD *(^)(CCHudTypeC))type {
    __weak typeof(self) pSelf = self;
    return ^MBProgressHUD *(CCHudTypeC t) {
        NSDictionary *d = @{@(CCHudTypeCLight) : ^{
                                pSelf.contentColor = UIColor.blackColor;
                            },
                            @(CCHudTypeCDarkDeep) : ^{
                                pSelf.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
                            },
                            @(CCHudTypeCDark) : ^{
                                pSelf.contentColor = UIColor.whiteColor;
                                pSelf.bezelView.backgroundColor = UIColor.blackColor;
                            },
                            @(CCHudTypeCNone) : ^{
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
        return pSelf.hideS(f);
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
