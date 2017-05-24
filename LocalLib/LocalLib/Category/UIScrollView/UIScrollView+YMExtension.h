//
//  UIScrollView+YMExtension.h
//  ym_sell_ios
//
//  Created by 冯明庆 on 2017/4/1.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (YMExtension)

+ (instancetype) ymInitWithFrame : (CGRect) rectFrame;
+ (instancetype) ymInitWithFrame : (CGRect) rectFrame
                 withContentSize : (CGSize) sizeContent ;
+ (instancetype) ymInitWithFrame : (CGRect) rectFrame
                 withContentSize : (CGSize) sizeContent
                    withDelegate : (id) delegate ;

@end
