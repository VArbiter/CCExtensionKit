//
//  UIImageView+CCExtension.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/6.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (CCExtension)

+ (instancetype) ccCommonSettingsWithFrame : (CGRect) rectFrame ;

+ (instancetype) ccCommonSettingsWithFrame : (CGRect) rectFrame
                                 withImage : (UIImage *) image ;

+ (instancetype) ccCommonSettingsWithFrame : (CGRect) rectFrame
                                 withImage : (UIImage *) image
                    withEnableUserInteract : (BOOL) isEnable ;

- (instancetype) ccGussianImage;
- (instancetype) ccGussianImageWithComplete : (dispatch_block_t) block;
- (instancetype) ccViewWithGaussianBlurValue : (CGFloat) floatValue
                           withCompleteBlock : (dispatch_block_t) block; // 高斯模糊, 只在 UIImageView 下起效

@end

@interface NSArray (CCGifExtension)

+ (NSArray *) ccRefreshGifImageArray ;

@end
