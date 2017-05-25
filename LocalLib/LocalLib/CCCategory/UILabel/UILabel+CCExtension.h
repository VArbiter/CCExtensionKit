//
//  UILabel+CCExtension.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/1.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (CCExtension)

+ (CGFloat) ccSetLabelValueAndAutoHeight : (NSString *) stringValue
                               withWidth : (CGFloat) floatWidth ;

+ (CGFloat) ccSetLabelValueAndAutoHeight : (NSString *) stringValue
                                withFont : (UIFont *) font
                       withLineBreakMode : (NSLineBreakMode) mode
                               withWidth : (CGFloat) floatWidth ;

- (CGFloat) ccSetEntityAutoHeight : (NSString *) stringValue
                        withWidth : (CGFloat) floatWidth ;

- (CGFloat) ccSetEntityAutoHeight ;

+ (UILabel *) ccLabelCommonSettings : (CGRect) rectFrame ;

@end
