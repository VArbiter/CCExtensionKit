//
//  UIColor+CCExtension.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/17.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "UIColor+CCExtension.h"

#import "UIImage+CCExtension.h"

@implementation UIColor (CCExtension)

- (UIImage *)image {
    return self.ccImage;
}

- (UIImage *) ccImage {
    return [UIImage ccGenerate:self];
}

@end
