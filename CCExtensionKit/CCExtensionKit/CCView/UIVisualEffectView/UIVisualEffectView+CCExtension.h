//
//  UIVisualEffectView+CCExtension.h
//  CCExtensionKit
//
//  Created by 冯明庆 on 12/10/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIVisualEffectView (CCExtension)

+ (instancetype) cc_common : (UIVisualEffect *) effect;

@end

#pragma mark - -----

@interface UIVisualEffect (CCExtension)

+ (instancetype) cc_blur_dark ;
+ (instancetype) cc_blur_light ;
+ (instancetype) cc_blur_extra_light ;

@end

#pragma mark - -----

@interface UIVibrancyEffect (CCExtension)

+ (instancetype) cc_vibrancy_dark ;
+ (instancetype) cc_vibrancy_light ;
+ (instancetype) cc_vibrancy_extra_light ;

@end
