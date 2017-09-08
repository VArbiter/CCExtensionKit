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

// fixed UIBarButtonItem's offset
/// note : given value must lesser than 0 , if not , will crash (already prevent it .)

- (void) ccLeftOffset : (CGFloat) fOffset
                 item : (UIBarButtonItem *) item ;
- (void) ccRightOffset : (CGFloat) fOffset
                  item : (UIBarButtonItem *) item ;

@end
