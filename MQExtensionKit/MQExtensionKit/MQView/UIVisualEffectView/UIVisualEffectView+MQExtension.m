//
//  UIVisualEffectView+MQExtension.m
//  MQExtensionKit
//
//  Created by 冯明庆 on 12/10/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "UIVisualEffectView+MQExtension.h"

@implementation UIVisualEffectView (MQExtension)

+ (instancetype) mq_common : (UIVisualEffect *) effect {
    return [[self alloc] initWithEffect:effect];
}

@end

#pragma mark - -----

@implementation UIVisualEffect (MQExtension)

+ (instancetype) mq_blur_dark {
    return [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
}
+ (instancetype) mq_blur_light {
     return [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
}
+ (instancetype) mq_blur_extra_light {
     return [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
}

@end

#pragma mark - -----

@implementation UIVibrancyEffect (MQExtension)

+ (instancetype) mq_vibrancy_dark {
    return [UIVibrancyEffect effectForBlurEffect:UIBlurEffect.mq_blur_dark];
}
+ (instancetype) mq_vibrancy_light {
    return [UIVibrancyEffect effectForBlurEffect:UIBlurEffect.mq_blur_light];
}
+ (instancetype) mq_vibrancy_extra_light {
    return [UIVibrancyEffect effectForBlurEffect:UIBlurEffect.mq_blur_extra_light];
}

@end
