//
//  UINavigationItem+CCExtension.h
//  CCLocalLibrary
//
//  Created by Elwinfrederick on 08/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationItem (CCExtension)

@end

#pragma mark - -----

@interface UINavigationItem (CCExtension_FixedSpace)

/// fixed UIBarButtonItem's offset // 修复 导航栏上 UIBarButtonItem 的偏移
/// note : given value must lesser than 0 , if not , will crash (already prevent it .) // 给出的结果必须小于 0 , 否则崩溃 (以防止)

- (void) ccLeftOffset : (CGFloat) fOffset
                 item : (UIBarButtonItem *) item ;
- (void) ccRightOffset : (CGFloat) fOffset
                  item : (UIBarButtonItem *) item ;

@end
