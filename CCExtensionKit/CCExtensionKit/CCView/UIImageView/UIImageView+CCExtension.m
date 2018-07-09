//
//  UIImageView+CCExtension.m
//  CCExtensionKit
//
//  Created by 冯明庆 on 2017/4/6.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "UIImageView+CCExtension.h"

@implementation UIImageView (CCExtension)

static UIViewContentMode __mode_image_view = UIViewContentModeScaleAspectFit;
static BOOL __masks_image_view = false;

+ (void) cc_set_image_view_content_mode : (UIViewContentMode) mode {
    __mode_image_view = mode;
}
+ (void) cc_set_image_view_masks_to_bounds : (BOOL) masks {
    __masks_image_view = masks;
}

+ (instancetype)cc_common:(CGRect)frame {
    UIImageView *v = [[self alloc] initWithFrame:frame];
    v.backgroundColor = [UIColor clearColor];
    v.contentMode = __mode_image_view;
    v.layer.masksToBounds = __masks_image_view;
    return v;
}

- (instancetype)cc_image:(UIImage *)image {
    self.image = image;
    return self;
}

@end


