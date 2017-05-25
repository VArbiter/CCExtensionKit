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

@implementation UIImageView (CCExtension)

+ (instancetype) ccCommonSettingsWithFrame : (CGRect) rectFrame {
    return [self ccCommonSettingsWithFrame:rectFrame
                                 withImage:nil];
}

+ (instancetype) ccCommonSettingsWithFrame : (CGRect) rectFrame
                                 withImage : (UIImage *) image {
    return [self ccCommonSettingsWithFrame:rectFrame
                                 withImage:image
                    withEnableUserInteract:false];
}

+ (instancetype) ccCommonSettingsWithFrame : (CGRect) rectFrame
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
    [self.image ccGaussianImage:floatValue
              withCompleteBlock:^(UIImage *imageOrigin, UIImage *imageProcessed) {
        pSelf.image = imageProcessed;
        _CC_Safe_UI_Block_(block, ^{
            block();
        });
    }];
    return self;
}

@end

#import "NSMutableArray+CCExtension.h"

@implementation NSArray (CCGifExtension)

+ (NSArray *) ccRefreshGifImageArray {
    NSMutableArray *array = [NSMutableArray array];
    for (short i = 1 ; i <= 8; i ++) {
        @autoreleasepool {
//            NSString *stringPath = [[NSBundle mainBundle] pathForResource:ccMergeObject(@"刷新-",@(i), @"(dragged)")
//                                                                   ofType:@"tiff"];
            NSString *stringImageName = ccStringFormat(@"%@",@(i));
            [array ccAddObject:[UIImage imageNamed:stringImageName]];
        }
    }
    return array;
}

@end
