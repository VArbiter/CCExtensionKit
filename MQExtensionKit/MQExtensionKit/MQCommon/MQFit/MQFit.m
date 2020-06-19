//
//  MQFit.m
//  MQExtensionKit
//
//  Created by 冯明庆 on 18/11/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "MQFit.h"

//@implementation MQFit
//@end

#ifndef __IPHONE_13_0
CGRect mq_fit_status_bar_frame() {
    return UIApplication.sharedApplication.statusBarFrame;
}
CGFloat mq_fit_status_bar_height() {
    return mq_fit_status_bar_frame().size.height ;
}
CGFloat mq_fit_status_bar_bottom() {
    return CGRectGetMaxY(mq_fit_status_bar_frame());
}
#endif
CGFloat mq_fit_navigation_height(void) {
    return 44.f;
}
CGFloat mq_fit_navigation_bottom(void) {
    return mq_fit_is_has_bangs() ? 88.f : 64.f ;
}
CGFloat mq_fit_tabbar_height(void) {
    return mq_fit_is_has_bangs() ? 83.f : 49.f ;
}
CGFloat mq_fit_tabbar_top(void) {
    return UIScreen.mainScreen.bounds.size.height - mq_fit_tabbar_height();
}

BOOL mq_fit_is_has_bangs(void) {
#ifdef __IPHONE_13_0
    NSSet <UIScene *> *set = UIApplication.sharedApplication.connectedScenes;
    if (set.count) {
        UIScene *scene = set.anyObject;
        if ([scene isKindOfClass:[UIWindowScene class]]) {
            UIEdgeInsets insets_safe_area = ((UIWindowScene *)scene).windows.firstObject.safeAreaInsets;
            return insets_safe_area.bottom > 0;
        }
    }
#endif
#ifdef __IPHONE_11_0
    UIEdgeInsets insets_safe_area = UIApplication.sharedApplication.delegate.window.safeAreaInsets;
    return insets_safe_area.bottom > 0;
#endif
    return false;
}

CGFloat mq_fit_safe_area_top_height(void) {
    return mq_fit_is_has_bangs() ? 24.f : 0.f ;
}
CGFloat mq_fit_safe_area_bottom_height(void) {
    return mq_fit_is_has_bangs() ? 44.f : 0.f ;
}
