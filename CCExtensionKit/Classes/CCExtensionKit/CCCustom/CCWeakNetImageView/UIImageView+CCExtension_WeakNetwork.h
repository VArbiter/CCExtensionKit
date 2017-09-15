//
//  UIImageView+CCExtension_WeakNetwork.h
//  CCLocalLibrary
//
//  Created by Elwinfrederick on 14/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

#if __has_include(<SDWebImage/UIImageView+WebCache.h>)

@interface UIImageView (CCExtension_WeakNetwork)

/// if network was not strong enough , stop loading web image .
- (instancetype) ccWeakImage : (NSURL *) url
                      holder : (UIImage *) imageHolder ;

/// if set NO , this function will stop all loading for images
/// default is YES;
+ (void) ccEnableLoading : (BOOL) isEnable ;

@end

#endif
