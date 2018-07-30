//
//  CCFit.h
//  MQExtensionKit
//
//  Created by 冯明庆 on 18/11/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

@import UIKit;
#import "CCDevice.h"

@interface CCFit : NSObject

/// returns fitable values related (by system origin , not custom) // 返回可适应的值 , 是系统的 , 不是自定义的
/// for annoying iPhone X =.= // 针对烦人的 iPhone X
CGRect CC_STATUS_BAR_FRAME(void) ; // returns CGRectZero if hidden // 如果隐藏 , 将会返回 CGRectZero
CGFloat CC_STATUS_BAR_HEIGHT(void) ; // returns 0 if hidden // 隐藏会返回 0
CGFloat CC_STATUS_BAR_BOTTOM(void) ; // may not equals to the navigation top on iPhone X // 在 iPhone X 上可能不会等于导航栏的上部
CGFloat CC_NAVIGATION_HEIGHT(void) ;
CGFloat CC_NAVIGATION_BOTTOM(void) ;
CGFloat CC_TABBAR_HEIGHT(void) ;
CGFloat CC_TABBAR_TOP(void) ;

BOOL CC_IS_IPHONE_X(void) ;

CGFloat CC_SAFE_AREA_TOP_HEIGHT(void) ;
CGFloat CC_SAFE_AREA_BOTTOM_HEIGHT(void) ;

@end
