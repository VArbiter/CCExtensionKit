//
//  UIImageView+YMExtension.m
//  ym_sell_ios
//
//  Created by 冯明庆 on 2017/4/6.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "UIImageView+YMExtension.h"

#import "UIImage+YMExtension.h"

#import "YMCommonDefine.h"

@implementation UIImageView (YMExtension)

+ (instancetype) ymCommonSettingsWithFrame : (CGRect) rectFrame {
    return [self ymCommonSettingsWithFrame:rectFrame
                                 withImage:nil];
}

+ (instancetype) ymCommonSettingsWithFrame : (CGRect) rectFrame
                                 withImage : (UIImage *) image {
    return [self ymCommonSettingsWithFrame:rectFrame
                                 withImage:image
                    withEnableUserInteract:false];
}

+ (instancetype) ymCommonSettingsWithFrame : (CGRect) rectFrame
                                 withImage : (UIImage *) image
                    withEnableUserInteract : (BOOL) isEnable {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:rectFrame];
    if (image) {
        imageView.image = image;
    }
    imageView.userInteractionEnabled = isEnable;
    imageView.backgroundColor = [UIColor clearColor];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    return imageView;
}

- (instancetype) ymGussianImage {
    return [self ymGussianImageWithComplete:nil];
}
- (instancetype) ymGussianImageWithComplete : (dispatch_block_t) block {
    return [self ymViewWithGaussianBlurValue:_YM_GAUSSIAN_BLUR_VALUE_
                           withCompleteBlock:block];
}

- (instancetype) ymViewWithGaussianBlurValue : (CGFloat) floatValue
                           withCompleteBlock : (dispatch_block_t) block {
    UIImage *image = self.image;
    if (!image) return self;
    
    ymWeakSelf;
    [self.image ymGaussianImage:floatValue
              withCompleteBlock:^(UIImage *imageOrigin, UIImage *imageProcessed) {
        pSelf.image = imageProcessed;
        _YM_Safe_UI_Block_(block, ^{
            block();
        });
    }];
    return self;
}

@end

#import "NSMutableArray+YMExtension.h"

@implementation NSArray (YMGifExtension)

+ (NSArray *) ymRefreshGifImageArray {
    NSMutableArray *array = [NSMutableArray array];
    for (short i = 1 ; i <= 8; i ++) {
        @autoreleasepool {
//            NSString *stringPath = [[NSBundle mainBundle] pathForResource:ymMergeObject(@"刷新-",@(i), @"(dragged)")
//                                                                   ofType:@"tiff"];
            NSString *stringImageName = ymStringFormat(@"%@",@(i));
            [array ymAddObject:[UIImage imageNamed:stringImageName]];
        }
    }
    return array;
}

@end
