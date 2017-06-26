//
//  UIScrollView+CCExtension.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/1.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (CCExtension)

+ (instancetype) ccCommon : (CGRect) rectFrame;
+ (instancetype) ccCommon : (CGRect) rectFrame
                  content : (CGSize) sizeContent ;
+ (instancetype) ccCommon : (CGRect) rectFrame
                  content : (CGSize) sizeContent
                 delegate : (id) delegate ;

@end
