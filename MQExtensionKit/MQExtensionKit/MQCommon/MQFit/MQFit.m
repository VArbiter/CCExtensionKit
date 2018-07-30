//
//  MQFit.m
//  MQExtensionKit
//
//  Created by 冯明庆 on 18/11/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "MQFit.h"

@implementation MQFit

CGRect MQ_STATUS_BAR_FRAME() {
    return UIApplication.sharedApplication.statusBarFrame;
}
CGFloat MQ_STATUS_BAR_HEIGHT() {
    return MQ_STATUS_BAR_FRAME().size.height ;
}
CGFloat MQ_STATUS_BAR_BOTTOM() {
    return CGRectGetMaxY(MQ_STATUS_BAR_FRAME());
}
CGFloat MQ_NAVIGATION_HEIGHT(void) {
    return 44.f;
}
CGFloat MQ_NAVIGATION_BOTTOM(void) {
    return MQ_IS_IPHONE_X() ? 88.f : 64.f ;
}
CGFloat MQ_TABBAR_HEIGHT(void) {
    return MQ_IS_IPHONE_X() ? 83.f : 49.f ;
}
CGFloat MQ_TABBAR_TOP(void) {
    return UIScreen.mainScreen.bounds.size.height - MQ_TABBAR_HEIGHT();
}

BOOL MQ_IS_IPHONE_X(void) {
//    return [[MQDevice mq_device_type] isEqualToString:@"iPhone X"];
    CGFloat f_s_w = UIScreen.mainScreen.bounds.size.width ,
    f_s_h = UIScreen.mainScreen.bounds.size.height ;
    return ((f_s_w == 375.f) && (f_s_h == 812.f));
}

CGFloat MQ_SAFE_AREA_TOP_HEIGHT(void) {
    return MQ_IS_IPHONE_X() ? 24.f : 0.f ;
}
CGFloat MQ_SAFE_AREA_BOTTOM_HEIGHT(void) {
    return MQ_IS_IPHONE_X() ? 44.f : 0.f ;
}

@end
