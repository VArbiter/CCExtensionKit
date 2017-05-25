//
//  UIScrollView+CCExtension.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/1.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (CCExtension)

+ (instancetype) ccInitWithFrame : (CGRect) rectFrame;
+ (instancetype) ccInitWithFrame : (CGRect) rectFrame
                 withContentSize : (CGSize) sizeContent ;
+ (instancetype) ccInitWithFrame : (CGRect) rectFrame
                 withContentSize : (CGSize) sizeContent
                    withDelegate : (id) delegate ;

@end
