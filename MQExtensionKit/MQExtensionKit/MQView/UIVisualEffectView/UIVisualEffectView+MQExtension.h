//
//  UIVisualEffectView+MQExtension.h
//  MQExtensionKit
//
//  Created by 冯明庆 on 12/10/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIVisualEffectView (CCExtension)

+ (instancetype) mq_common : (UIVisualEffect *) effect;

@end

#pragma mark - -----

@interface UIVisualEffect (CCExtension)

+ (instancetype) mq_blur_dark ;
+ (instancetype) mq_blur_light ;
+ (instancetype) mq_blur_extra_light ;

@end

#pragma mark - -----

@interface UIVibrancyEffect (CCExtension)

+ (instancetype) mq_vibrancy_dark ;
+ (instancetype) mq_vibrancy_light ;
+ (instancetype) mq_vibrancy_extra_light ;

@end
