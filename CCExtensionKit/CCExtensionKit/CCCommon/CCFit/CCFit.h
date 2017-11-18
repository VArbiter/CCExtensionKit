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

/// returns fitable values related (by system origin , not custom)
/// for annoying iPhone X =.=
CGRect _CC_STATUS_BAR_FRAME_(void) ; // returns CGRectZero if hidden
CGFloat _CC_STATUS_BAR_HEIGHT_(void) ; // returns 0 if hidden
CGFloat _CC_STATUS_BAR_BOTTOM_(void) ; // may not equals to the navigation top on iPhone X
CGFloat _CC_NAVIGATION_HEIGHT_(void) ;
CGFloat _CC_NAVIGATION_BOTTOM_(void) ;
CGFloat _CC_TABBAR_HEIGHT_(void) ;
CGFloat _CC_TABBAR_TOP_(void) ;

BOOL _CC_IS_IPHONE_X_(void) ;

@end
