//
//  UIImageView+MQExtension.h
//  MQExtensionKit
//
//  Created by 冯明庆 on 2017/4/6.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (MQExtension)

/// set contentMode && masksToBounds in app-wide with CCExtensionKit . // 在 app 中, 全局设置由 CCExtensionKit 创建 的 imageView 的 contentMode 和 masksToBounds .
+ (void) mq_set_image_view_content_mode : (UIViewContentMode) mode ;
+ (void) mq_set_image_view_masks_to_bounds : (BOOL) masks ;

+ (instancetype) mq_common : (CGRect) frame ;
- (instancetype) mq_image : (UIImage *) image ;

@end
