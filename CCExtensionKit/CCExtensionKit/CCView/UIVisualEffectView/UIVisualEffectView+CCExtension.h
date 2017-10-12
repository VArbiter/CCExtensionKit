//
//  UIVisualEffectView+CCExtension.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 12/10/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIVisualEffectView (CCExtension)

+ (instancetype) common : (UIVisualEffect *) effect;

@end

#pragma mark - -----

@interface UIVisualEffect (CCExtension)

+ (instancetype) ccBlurDark ;
+ (instancetype) ccBlurLight ;
+ (instancetype) ccBlurExtraLight ;

@end

#pragma mark - -----

@interface UIVibrancyEffect (CCExtension)

+ (instancetype) ccVibrancyDark ;
+ (instancetype) ccVibrancyLight ;
+ (instancetype) ccVibrancyExtraLight ;

@end
