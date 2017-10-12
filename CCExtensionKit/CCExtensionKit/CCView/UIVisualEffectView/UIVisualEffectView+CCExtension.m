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

+ (instancetype) ccBlurDark {
    return [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
}
+ (instancetype) ccBlurLight {
     return [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
}
+ (instancetype) ccBlurExtraLight {
     return [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
}

@end

#pragma mark - -----

@implementation UIVibrancyEffect (CCExtension)

+ (instancetype) ccVibrancyDark {
    return [UIVibrancyEffect effectForBlurEffect:UIBlurEffect.ccBlurDark];
}
+ (instancetype) ccVibrancyLight {
    return [UIVibrancyEffect effectForBlurEffect:UIBlurEffect.ccBlurLight];
}
+ (instancetype) ccVibrancyExtraLight {
    return [UIVibrancyEffect effectForBlurEffect:UIBlurEffect.ccBlurExtraLight];
}

@end
