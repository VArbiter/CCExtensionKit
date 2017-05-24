//
//  UIImageView+YMExtension.h
//  ym_sell_ios
//
//  Created by 冯明庆 on 2017/4/6.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (YMExtension)

+ (instancetype) ymCommonSettingsWithFrame : (CGRect) rectFrame ;

+ (instancetype) ymCommonSettingsWithFrame : (CGRect) rectFrame
                                 withImage : (UIImage *) image ;

+ (instancetype) ymCommonSettingsWithFrame : (CGRect) rectFrame
                                 withImage : (UIImage *) image
                    withEnableUserInteract : (BOOL) isEnable ;

- (instancetype) ymGussianImage;
- (instancetype) ymGussianImageWithComplete : (dispatch_block_t) block;
- (instancetype) ymViewWithGaussianBlurValue : (CGFloat) floatValue
                           withCompleteBlock : (dispatch_block_t) block; // 高斯模糊, 只在 UIImageView 下起效

@end

@interface NSArray (YMGifExtension)

+ (NSArray *) ymRefreshGifImageArray ;

@end
