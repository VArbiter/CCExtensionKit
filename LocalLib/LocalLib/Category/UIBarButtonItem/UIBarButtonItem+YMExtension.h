//
//  UIBarButtonItem+YMExtension.h
//  ym_sell_ios
//
//  Created by 冯明庆 on 2017/4/26.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (YMExtension)

+ (instancetype) ymInitWithImage : (NSString *) stringImageName
                  withClickBlock : (void(^)(UIBarButtonItem *sender)) blockClick;
+ (instancetype) ymInitWithImage : (NSString *) stringImageName
                       withStyle : (UIBarButtonItemStyle) style
                  withClickBlock : (void(^)(UIBarButtonItem *sender)) blockClick;

+ (instancetype) ymInitWithImage : (NSString *) stringImageName
                      withTarget : (id) target
                    withSelector : (SEL) selector ;
+ (instancetype) ymInitWithImage : (NSString *) stringImageName
                       withStyle : (UIBarButtonItemStyle) style
                      withTarget : (id) target
                    withSelector : (SEL) selector ;

@property (nonatomic , copy) void(^blockClick)(UIBarButtonItem *sender) ;


#pragma mark - NOT FOR PRIMARY 

- (void) ymBarButtonAction : (UIBarButtonItem *) sender ;

@end
