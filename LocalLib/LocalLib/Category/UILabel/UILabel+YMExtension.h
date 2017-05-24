//
//  UILabel+YMExtension.h
//  ym_sell_ios
//
//  Created by 冯明庆 on 2017/4/1.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (YMExtension)

+ (CGFloat) ymSetLabelValueAndAutoHeight : (NSString *) stringValue
                               withWidth : (CGFloat) floatWidth ;

+ (CGFloat) ymSetLabelValueAndAutoHeight : (NSString *) stringValue
                                withFont : (UIFont *) font
                       withLineBreakMode : (NSLineBreakMode) mode
                               withWidth : (CGFloat) floatWidth ;

- (CGFloat) ymSetEntityAutoHeight : (NSString *) stringValue
                        withWidth : (CGFloat) floatWidth ;

- (CGFloat) ymSetEntityAutoHeight ;

+ (UILabel *) ymLabelCommonSettings : (CGRect) rectFrame ;

@end
