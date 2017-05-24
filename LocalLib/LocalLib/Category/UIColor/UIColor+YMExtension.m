//
//  UIColor+YMExtension.m
//  ym_sell_ios
//
//  Created by 冯明庆 on 2017/4/17.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "UIColor+YMExtension.h"

#import "UIImage+YMExtension.h"

@implementation UIColor (YMExtension)

- (UIImage *) ymColorImage {
    return [UIImage ymGenerateImageWithColor:self];
}

@end
