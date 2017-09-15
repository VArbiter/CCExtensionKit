//
//  UIScrollView+CCExtension.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/1.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (CCExtension)

+ (instancetype) common : (CGRect) frame ;

- (instancetype) ccContentSize : (CGSize) size ;
- (instancetype) ccDelegateT : (id) delegate ;

/// animated is YES .
- (instancetype) ccAnimatedOffset : (CGPoint) offSet ;
- (instancetype) ccAnimatedOffset : (CGPoint) offSet
                         animated : (BOOL) isAnimated ;

- (instancetype) hideVerticalIndicator ;
- (instancetype) hideHorizontalIndicator ;
- (instancetype) disableBounces ;
- (instancetype) disableScroll ;
- (instancetype) disableScrollsToTop ;

- (instancetype) enablePaging ;
- (instancetype) enableDirectionLock ;

@end
