//
//  UIImageView+CCExtension_WeakNetwork.h
//  CCExtensionKit
//
//  Created by Elwinfrederick on 14/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

#if __has_include(<SDWebImage/UIImageView+WebCache.h>)

@interface UIImageView (CCExtension_WeakNetwork)

/// if network was not strong enough , stop loading web image . // 如果网络不够强 , 停止加载网络图片
- (instancetype) cc_weak_image : (NSURL *) url
                        holder : (UIImage *) imageHolder ;

/// if set NO , this function will stop all loading for images // 如果设置为 NO , 将会停止加载所有的图片
/// default is YES; // 默认为 YES 
+ (void) cc_enable_loading : (BOOL) isEnable ;

@end

#endif
