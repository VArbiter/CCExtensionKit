//
//  CCFit.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 18/11/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "CCFit.h"

@implementation CCFit

CGRect _CC_STATUS_BAR_FRAME_() {
    return UIApplication.sharedApplication.statusBarFrame;
}
CGFloat _CC_STATUS_BAR_HEIGHT_() {
    return _CC_STATUS_BAR_FRAME_().size.height ;
}
CGFloat _CC_STATUS_BAR_BOTTOM_() {
    return CGRectGetMaxY(_CC_STATUS_BAR_FRAME_());
}
CGFloat _CC_NAVIGATION_HEIGHT_(void) {
    return 44.f;
}
CGFloat _CC_NAVIGATION_BOTTOM_(void) {
    if (_CC_IS_IPHONE_X_()) {
        return 88.f;
    }
    else return 64.f;
}
CGFloat _CC_TABBAR_HEIGHT_(void) {
    if (_CC_IS_IPHONE_X_()) {
        return 83.f;
    }
    else return 49.f;
}
CGFloat _CC_TABBAR_TOP_(void) {
    return UIScreen.mainScreen.bounds.size.height - _CC_TABBAR_HEIGHT_();
}

BOOL _CC_IS_IPHONE_X_(void) {
    return [[CCDevice ccDeviceType] isEqualToString:@"iPhone X"];
}

@end
