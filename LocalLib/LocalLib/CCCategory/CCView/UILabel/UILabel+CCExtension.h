//
//  UILabel+CCExtension.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/1.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (CCExtension)

+ (CGFloat) ccHeight : (NSString *) stringValue
               width : (CGFloat) floatWidth ;

+ (CGFloat) ccHeight : (NSString *) stringValue
                font : (UIFont *) font
           breakMode : (NSLineBreakMode) mode
               width : (CGFloat) floatWidth ;

- (CGFloat) ccHeight : (NSString *) stringValue
               width : (CGFloat) floatWidth ;

- (CGFloat) ccHeight ;

+ (UILabel *) ccCommon : (CGRect) rectFrame ;

@end
