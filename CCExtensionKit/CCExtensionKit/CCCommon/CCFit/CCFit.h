//
//  CCFit.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 18/11/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

@import UIKit;
#import "CCDevice.h"

@interface CCFit : NSObject

/// returns fitable values related (by system origin , not custom) // 返回可适应的值 , 是系统的 , 不是自定义的
/// for annoying iPhone X =.= // 针对烦人的 iPhone X
CGRect _CC_STATUS_BAR_FRAME_(void) ; // returns CGRectZero if hidden // 如果隐藏 , 将会返回 CGRectZero
CGFloat _CC_STATUS_BAR_HEIGHT_(void) ; // returns 0 if hidden // 隐藏会返回 0
CGFloat _CC_STATUS_BAR_BOTTOM_(void) ; // may not equals to the navigation top on iPhone X // 在 iPhone X 上可能不会等于导航栏的上部
CGFloat _CC_NAVIGATION_HEIGHT_(void) ;
CGFloat _CC_NAVIGATION_BOTTOM_(void) ;
CGFloat _CC_TABBAR_HEIGHT_(void) ;
CGFloat _CC_TABBAR_TOP_(void) ;

BOOL _CC_IS_IPHONE_X_(void) ;

@end
