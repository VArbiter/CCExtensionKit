//
//  MQFit.h
//  MQExtensionKit
//
//  Created by 冯明庆 on 18/11/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

@import UIKit;

//@interface MQFit : NSObject
//@end

/// returns fitable values related (by system origin , not custom) // 返回可适应的值 , 是系统的 , 不是自定义的
#ifndef __IPHONE_13_0
CGRect mq_fit_status_bar_frame(void) ; // returns CGRectZero if hidden // 如果隐藏 , 将会返回 CGRectZero
CGFloat mq_fit_status_bar_height(void) ; // returns 0 if hidden // 隐藏会返回 0
CGFloat mq_fit_status_bar_bottom(void) ; // may not equals to the navigation top on iPhone X // 在 iPhone X 上可能不会等于导航栏的上部
#endif
CGFloat mq_fit_navigation_height(void) ;
CGFloat mq_fit_navigation_bottom(void) ;
CGFloat mq_fit_tabbar_height(void) ;
CGFloat mq_fit_tabbar_top(void) ;

/// whether the screen has the "bangs" . // 屏幕是否是刘海屏 .
BOOL mq_fit_is_has_bangs(void) ;

CGFloat mq_fit_safe_area_top_height(void) ;
CGFloat mq_fit_safe_area_bottom_height(void) ;


