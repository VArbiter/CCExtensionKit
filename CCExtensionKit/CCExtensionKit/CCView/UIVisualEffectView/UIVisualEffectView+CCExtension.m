//
//  UIVisualEffectView+CCExtension.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 12/10/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "UIVisualEffectView+CCExtension.h"

@implementation UIVisualEffectView (CCExtension)

+ (instancetype) common : (UIVisualEffect *) effect {
    return [[self alloc] initWithEffect:effect];
}

@end

#pragma mark - -----

@implementation UIVisualEffect (CCExtension)

+ (instancetype) cc_blur_dark {
    return [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
}
+ (instancetype) cc_blur_light {
     return [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
}
+ (instancetype) cc_blur_extra_light {
     return [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
}

@end

#pragma mark - -----

@implementation UIVibrancyEffect (CCExtension)

+ (instancetype) cc_vibrancy_dark {
    return [UIVibrancyEffect effectForBlurEffect:UIBlurEffect.cc_blur_dark];
}
+ (instancetype) cc_vibrancy_light {
    return [UIVibrancyEffect effectForBlurEffect:UIBlurEffect.cc_blur_light];
}
+ (instancetype) cc_vibrancy_extra_light {
    return [UIVibrancyEffect effectForBlurEffect:UIBlurEffect.cc_blur_extra_light];
}

@end
