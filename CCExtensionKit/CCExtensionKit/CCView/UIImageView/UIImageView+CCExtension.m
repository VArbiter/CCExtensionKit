//
//  UIImageView+CCExtension.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/6.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "UIImageView+CCExtension.h"

@implementation UIImageView (CCExtension)

+ (instancetype)common:(CGRect)frame {
    UIImageView *v = [[self alloc] initWithFrame:frame];
    v.backgroundColor = [UIColor clearColor];
    v.contentMode = UIViewContentModeScaleAspectFit;
    return v;
}

- (instancetype)ccImageT:(UIImage *)image {
    self.image = image;
    return self;
}

@end


