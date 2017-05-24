//
//  UIButton+YMExtension.h
//  ym_sell_ios
//
//  Created by 冯明庆 on 2017/4/6.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (YMExtension)

+ (instancetype) ymButtonWithFrame : (CGRect) rectFrame;

+ (instancetype) ymButtonWithFrame : (CGRect) rectFrame
                          withType : (UIButtonType) type
                   withNormalTitle : (NSString *) stringTitleNormal
                 withSelectedTitle : (NSString *) stringSelectedTitle
                   withNormalImage : (NSString *) stringImage
                 withSelectedImage : (NSString *) stringSelectedImage;

#pragma mark - Target - Action
+ (instancetype) ymButtonWithFrame : (CGRect) rectFrame
                         withTitle : (NSString *) stringtitle
                        withTarget : (id) target
                      withSelector : (SEL) selector ;

+ (instancetype) ymButtonWithFrame : (CGRect) rectFrame
                        withTarget : (id) target
                      withSelector : (SEL) selector ;

+ (instancetype) ymButtonWithFrame : (CGRect) rectFrame
                   withNormalImage : (NSString *) stringImage
                 withSelectedImage : (NSString *) stringSelectedImage
                        withTarget : (id) target
                      withSelector : (SEL) selector ;

+ (instancetype) ymButtonWithFrame : (CGRect) rectFrame
                          withType : (UIButtonType) type
                   withNormalImage : (NSString *) stringImage
                 withSelectedImage : (NSString *) stringSelectedImage
                        withTarget : (id) target
                      withSelector : (SEL) selector ;

+ (instancetype) ymButtonWithFrame : (CGRect) rectFrame
                   withNormalTitle : (NSString *) stringTitleNormal
                 withSelectedTitle : (NSString *) stringSelectedTitle
                        withTarget : (id) target
                      withSelector : (SEL) selector ;

+ (instancetype) ymButtonWithFrame : (CGRect) rectFrame
                          withType : (UIButtonType) type
                   withNormalTitle : (NSString *) stringTitleNormal
                 withSelectedTitle : (NSString *) stringSelectedTitle
                   withNormalImage : (NSString *) stringImage
                 withSelectedImage : (NSString *) stringSelectedImage
                        withTarget : (id) target
                      withSelector : (SEL) selector ;

#pragma mark - Block

+ (instancetype) ymButtonWithFrame : (CGRect) rectFrame
                    withClickblock : (void(^)(UIButton *sender)) blockButton;

+ (instancetype) ymButtonWithFrame : (CGRect) rectFrame
                         withTitle : (NSString *) stringtitle
                    withClickblock : (void(^)(UIButton *sender)) blockButton;

+ (instancetype) ymButtonWithFrame : (CGRect) rectFrame
                    withButtonType : (UIButtonType) type
                         withTitle : (NSString *) stringtitle
                    withClickblock : (void(^)(UIButton *sender)) blockButton;

+ (instancetype) ymButtonWithFrame : (CGRect) rectFrame
                   withNormalImage : (NSString *) stringImage
                 withSelectedImage : (NSString *) stringSelectedImage
                    withClickblock : (void(^)(UIButton *sender)) blockButton;

+ (instancetype) ymButtonWithFrame : (CGRect) rectFrame
                    withButtonType : (UIButtonType) type
                   withNormalImage : (NSString *) stringImage
                    withClickblock : (void(^)(UIButton *sender)) blockButton;

+ (instancetype) ymButtonWithFrame : (CGRect) rectFrame
                    withButtonType : (UIButtonType) type
                   withNormalImage : (NSString *) stringImage
                 withSelectedImage : (NSString *) stringSelectedImage
                    withClickblock : (void(^)(UIButton *sender)) blockButton;

+ (instancetype) ymButtonWithFrame : (CGRect) rectFrame
                   withNormalTitle : (NSString *) stringTitleNormal
                 withSelectedTitle : (NSString *) stringSelectedTitle
                     withClickblock : (void(^)(UIButton *sender)) blockButton;

+ (instancetype) ymButtonWithFrame : (CGRect) rectFrame
                          withType : (UIButtonType) type
                   withNormalTitle : (NSString *) stringTitleNormal
                 withSelectedTitle : (NSString *) stringSelectedTitle
                   withNormalImage : (NSString *) stringImage
                 withSelectedImage : (NSString *) stringSelectedImage
                    withClickblock : (void(^)(UIButton *sender)) blockButton;

@property (nonatomic , copy) void (^blockButton)(UIButton *sender);

@property (nonatomic , copy) void (^blockClick)(UIButton *sender) ;

- (void) ymButtonAction : (UIButton *) sender ;

@end
