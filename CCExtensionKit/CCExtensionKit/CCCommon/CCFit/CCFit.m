//
//  CCFit.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 18/11/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "CCFit.h"

@implementation CCFit

CGRect CC_STATUS_BAR_FRAME() {
    return UIApplication.sharedApplication.statusBarFrame;
}
CGFloat CC_STATUS_BAR_HEIGHT() {
    return CC_STATUS_BAR_FRAME().size.height ;
}
CGFloat CC_STATUS_BAR_BOTTOM() {
    return CGRectGetMaxY(CC_STATUS_BAR_FRAME());
}
CGFloat CC_NAVIGATION_HEIGHT(void) {
    return 44.f;
}
CGFloat CC_NAVIGATION_BOTTOM(void) {
    return CC_IS_IPHONE_X() ? 88.f : 64.f ;
}
CGFloat CC_TABBAR_HEIGHT(void) {
    return CC_IS_IPHONE_X() ? 83.f : 49.f ;
}
CGFloat CC_TABBAR_TOP(void) {
    return UIScreen.mainScreen.bounds.size.height - CC_TABBAR_HEIGHT();
}

BOOL CC_IS_IPHONE_X(void) {
    return [[CCDevice cc_device_type] isEqualToString:@"iPhone X"];
}

CGFloat CC_SAFE_AREA_TOP_HEIGHT(void) {
    return CC_IS_IPHONE_X() ? 24.f : 0.f ;
}
CGFloat CC_SAFE_AREA_BOTTOM_HEIGHT(void) {
    return CC_IS_IPHONE_X() ? 44.f : 0.f ;
}

@end
