//
//  UIButton+CCExtension.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/6.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (CCExtension)

+ (instancetype) ccCommon : (CGRect) rectFrame;

+ (instancetype) ccCommon : (CGRect) rectFrame
                     type : (UIButtonType) type
                    title : (NSString *) stringTitleNormal
            selectedTitle : (NSString *) stringSelectedTitle
                    image : (NSString *) stringImage
            selectedImage : (NSString *) stringSelectedImage;

#pragma mark - Target - Action
+ (instancetype) ccCommon : (CGRect) rectFrame
                    title : (NSString *) stringTitle
                   target : (id) target
                 selector : (SEL) selector ;

+ (instancetype) ccCommon : (CGRect) rectFrame
                   target : (id) target
                 selector : (SEL) selector ;

+ (instancetype) ccCommon : (CGRect) rectFrame
                    image : (NSString *) stringImage
            selectedImage : (NSString *) stringSelectedImage
                   target : (id) target
                 selector : (SEL) selector ;

+ (instancetype) ccCommon : (CGRect) rectFrame
                     type : (UIButtonType) type
                    image : (NSString *) stringImage
            selectedImage : (NSString *) stringSelectedImage
                   target : (id) target
                 selector : (SEL) selector ;

+ (instancetype) ccCommon : (CGRect) rectFrame
                    title : (NSString *) stringTitleNormal
            selectedTitle : (NSString *) stringSelectedTitle
                   target : (id) target
                 selector : (SEL) selector ;

+ (instancetype) ccCommon : (CGRect) rectFrame
                     type : (UIButtonType) type
                    title : (NSString *) stringTitleNormal
            selectedTitle : (NSString *) stringSelectedTitle
                    image : (NSString *) stringImage
            selectedImage : (NSString *) stringSelectedImage
                   target : (id) target
                 selector : (SEL) selector ;

#pragma mark - Block

+ (instancetype) ccCommon : (CGRect) rectFrame
                    click : (void(^)(UIButton *sender)) blockButton;

+ (instancetype) ccCommon : (CGRect) rectFrame
                    title : (NSString *) stringTitle
                    click : (void(^)(UIButton *sender)) blockButton;

+ (instancetype) ccCommon : (CGRect) rectFrame
                     type : (UIButtonType) type
                    title : (NSString *) stringTitle
                    click : (void(^)(UIButton *sender)) blockButton;

+ (instancetype) ccCommon : (CGRect) rectFrame
                    image : (NSString *) stringImage
            selectedImage : (NSString *) stringSelectedImage
                    click : (void(^)(UIButton *sender)) blockButton;

+ (instancetype) ccCommon : (CGRect) rectFrame
                     type : (UIButtonType) type
                    image : (NSString *) stringImage
                    click : (void(^)(UIButton *sender)) blockButton;

+ (instancetype) ccCommon : (CGRect) rectFrame
                     type : (UIButtonType) type
                    image : (NSString *) stringImage
            selectedImage : (NSString *) stringSelectedImage
                    click : (void(^)(UIButton *sender)) blockButton;

+ (instancetype) ccCommon : (CGRect) rectFrame
                    title : (NSString *) stringTitleNormal
            selectedTitle : (NSString *) stringSelectedTitle
                    click : (void(^)(UIButton *sender)) blockButton;

+ (instancetype) ccCommon : (CGRect) rectFrame
                     type : (UIButtonType) type
                    title : (NSString *) stringTitleNormal
            selectedTitle : (NSString *) stringSelectedTitle
                    image : (NSString *) stringImage
            selectedImage : (NSString *) stringSelectedImage
                    click : (void(^)(UIButton *sender)) blockButton;

@property (nonatomic , copy) void (^blockButton)(UIButton *sender);

@property (nonatomic , copy) void (^blockClick)(UIButton *sender) ;

- (void) ccButtonAction : (UIButton *) sender ;

@end
