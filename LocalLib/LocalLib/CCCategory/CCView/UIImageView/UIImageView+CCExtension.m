//
//  UIImageView+CCExtension.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/6.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "UIImageView+CCExtension.h"

#import "UIImage+CCExtension.h"

#import "CCCommonDefine.h"
#import "CCCommonTools.h"

@implementation UIImageView (CCExtension)

+ (instancetype) ccCommon : (CGRect) rectFrame {
    return [self ccCommon:rectFrame
                    image:nil];
}

+ (instancetype) ccCommon : (CGRect) rectFrame
                                 image : (UIImage *) image {
    return [self ccCommon:rectFrame
                    image:image
                   enable:false];
}

+ (instancetype) ccCommon : (CGRect) rectFrame
                    image : (UIImage *) image
                   enable : (BOOL) isEnable {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:rectFrame];
    if (image) {
        imageView.image = image;
    }
    imageView.userInteractionEnabled = isEnable;
    imageView.backgroundColor = [UIColor clearColor];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    return imageView;
}

- (instancetype) ccGussianImage {
    return [self ccGussianImageWithComplete:nil];
}
- (instancetype) ccGussianImageWithComplete : (dispatch_block_t) block {
    return [self ccViewWithGaussianBlurValue:_CC_GAUSSIAN_BLUR_VALUE_
                           withCompleteBlock:block];
}

- (instancetype) ccViewWithGaussianBlurValue : (CGFloat) floatValue
                           withCompleteBlock : (dispatch_block_t) block {
    UIImage *image = self.image;
    if (!image) return self;
    
    ccWeakSelf;
    [self.image ccGaussianImageAcc:floatValue
                    iterationCount:0
                              tint:UIColor.whiteColor
                          complete:^(UIImage *imageOrigin, UIImage *imageProcessed) {
        pSelf.image = imageProcessed;
        CC_Safe_UI_Operation(block, ^{
            block();
        });
    }];
    return self;
}

@end

