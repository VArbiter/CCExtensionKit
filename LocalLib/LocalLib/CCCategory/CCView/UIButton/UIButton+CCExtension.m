//
//  UIButton+CCExtension.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/6.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "UIButton+CCExtension.h"
#import "CCCommonDefine.h"
#import "CCCommonTools.h"

#import <objc/runtime.h>

@implementation UIButton (CCExtension)

+ (instancetype) ccCommon : (CGRect) rectFrame {
    return [self ccCommon:rectFrame
                   target:nil
                 selector:nil];
}

+ (instancetype) ccCommon : (CGRect) rectFrame
                     type : (UIButtonType) type
                    title : (NSString *) stringTitleNormal
            selectedTitle : (NSString *) stringSelectedTitle
                    image : (NSString *) stringImage
            selectedImage : (NSString *) stringSelectedImage {
    UIButton *button = [UIButton buttonWithType:type];
    button.frame = rectFrame;
    button.titleLabel.font = [UIFont systemFontOfSize:_CC_DEFAULT_FONT_SIZE_];
    if (stringTitleNormal) {
        [button setTitle:stringTitleNormal
                forState:UIControlStateNormal];
    }
    if (stringSelectedTitle) {
        [button setTitle:stringSelectedTitle
                forState:UIControlStateSelected];
    }
    if (stringImage) {
        [button setImage:ccImage(stringImage, YES)
                forState:UIControlStateNormal];
    }
    if (stringSelectedImage) {
        [button setImage:ccImage(stringSelectedImage, YES)
                forState:UIControlStateSelected];
    }
    button.backgroundColor = [UIColor clearColor];
    return button;
}

#pragma mark - Target - Action

+ (instancetype) ccCommon : (CGRect) rectFrame
                   target : (id) target
                 selector : (SEL) selector {
    return [self ccCommon:rectFrame
                    title:nil
                   target:target
                 selector:selector];
}

+ (instancetype) ccCommon : (CGRect) rectFrame
                    title : (NSString *) stringtitle
                   target : (id) target
                 selector : (SEL) selector {
    return [self ccCommon:rectFrame
                    title:stringtitle
            selectedTitle:nil
                   target:target
                 selector:selector];
}

+ (instancetype) ccCommon : (CGRect) rectFrame
                    image : (NSString *) stringImage
            selectedImage : (NSString *) stringSelectedImage
                   target : (id) target
                 selector : (SEL) selector {
    return [self ccCommon:rectFrame
                     type:UIButtonTypeSystem
                    image:stringImage
            selectedImage:stringSelectedImage
                   target:target
                selector:selector];
}

+ (instancetype) ccCommon : (CGRect) rectFrame
                     type : (UIButtonType) type
                    image : (NSString *) stringImage
            selectedImage : (NSString *) stringSelectedImage
                   target : (id) target
                 selector : (SEL) selector {
    return [self ccCommon:rectFrame
                     type:type
                    title:nil
            selectedTitle:nil
                    image:stringImage
            selectedImage:stringSelectedImage
                   target:target
                 selector:selector];
}

+ (instancetype) ccCommon : (CGRect) rectFrame
                    title : (NSString *) stringTitleNormal
            selectedTitle : (NSString *) stringSelectedTitle
                   target : (id) target
                 selector : (SEL) selector {
    return [self ccCommon:rectFrame
                     type:UIButtonTypeSystem
                    title:stringTitleNormal
            selectedTitle:stringSelectedTitle
                    image:nil
            selectedImage:nil
                   target:target
                 selector:selector];
}

+ (instancetype) ccCommon : (CGRect) rectFrame
                     type : (UIButtonType) type
                    title : (NSString *) stringTitleNormal
            selectedTitle : (NSString *) stringSelectedTitle
                    image : (NSString *) stringImage
            selectedImage : (NSString *) stringSelectedImage
                   target : (id) target
                 selector : (SEL) selector {
    UIButton *button = [UIButton ccCommon:rectFrame
                                     type:type
                                    title:stringTitleNormal
                            selectedTitle:stringSelectedTitle
                                    image:stringImage
                            selectedImage:stringSelectedImage];
    
    if ([target respondsToSelector:selector]) {
        [button addTarget:target
                   action:selector
         forControlEvents:UIControlEventTouchUpInside];
    }
    
    return button;
}

#pragma mark - Block

+ (instancetype) ccCommon : (CGRect) rectFrame
                    click : (void(^)(UIButton *sender)) blockButton {
    return [self ccCommon:rectFrame
                    image:nil
            selectedImage:nil
                    click:blockButton];
}

+ (instancetype) ccCommon : (CGRect) rectFrame
                    title : (NSString *) stringTitle
                    click : (void(^)(UIButton *sender)) blockButton {
    return [self ccCommon:rectFrame
                    title:stringTitle
            selectedTitle:nil
                    click:blockButton];
}

+ (instancetype) ccCommon : (CGRect) rectFrame
                     type : (UIButtonType) type
                    title : (NSString *) stringTitle
                    click : (void(^)(UIButton *sender)) blockButton {
    return [self ccCommon:rectFrame
                     type:type
                    title:stringTitle
            selectedTitle:nil
                    image:nil
            selectedImage:nil
                    click:blockButton];
}

+ (instancetype) ccCommon : (CGRect) rectFrame
                    image : (NSString *) stringImage
            selectedImage : (NSString *) stringSelectedImage
                    click : (void(^)(UIButton *sender)) blockButton{
    return [self ccCommon:rectFrame
                     type:UIButtonTypeSystem
                    title:nil
            selectedTitle:nil
                    image:stringImage
            selectedImage:stringSelectedImage
                    click:blockButton];
}

+ (instancetype) ccCommon : (CGRect) rectFrame
                     type : (UIButtonType) type
                    image : (NSString *) stringImage
                    click : (void(^)(UIButton *sender)) blockButton {
    return [self ccCommon:rectFrame
                     type:type
                    image:stringImage
            selectedImage:nil
                    click:blockButton];
}

+ (instancetype) ccCommon : (CGRect) rectFrame
                     type : (UIButtonType) type
                    image : (NSString *) stringImage
            selectedImage : (NSString *) stringSelectedImage
                    click : (void(^)(UIButton *sender)) blockButton{
    return [self ccCommon:rectFrame
                     type:type
                    title:nil
            selectedTitle:nil
                    image:stringImage
            selectedImage:stringSelectedImage
                    click:blockButton];
}

+ (instancetype) ccCommon : (CGRect) rectFrame
                    title : (NSString *) stringTitleNormal
            selectedTitle : (NSString *) stringSelectedTitle
                    click : (void(^)(UIButton *sender)) blockButton{
    return [self ccCommon:rectFrame
                     type:UIButtonTypeSystem
                    title:stringTitleNormal
            selectedTitle:stringSelectedTitle
                    image:nil
            selectedImage:nil
                    click:blockButton];
}

+ (instancetype) ccCommon : (CGRect) rectFrame
                     type : (UIButtonType) type
                    title : (NSString *) stringTitleNormal
            selectedTitle : (NSString *) stringSelectedTitle
                    image : (NSString *) stringImage
            selectedImage : (NSString *) stringSelectedImage
                    click : (void(^)(UIButton *sender)) blockButton{
    UIButton *button = [UIButton ccCommon:rectFrame
                                     type:type
                                    title:stringTitleNormal
                            selectedTitle:stringSelectedTitle
                                    image:stringImage
                            selectedImage:stringSelectedImage];
    if (blockButton) {
        button.blockButton = [blockButton copy];
    }
    if ([button respondsToSelector:@selector(ccButtonAction:)]) {
        [button addTarget:button
                   action:@selector(ccButtonAction:)
         forControlEvents:UIControlEventTouchUpInside];
    }
    return button;
}

#pragma mark - Setter
- (void)setBlockButton:(void (^)(UIButton *))blockButton {
    objc_setAssociatedObject(self, @selector(blockButton), blockButton, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void)setBlockClick:(void (^)(UIButton *))blockClick {
    if (self) {
        [self addTarget:self
                 action:@selector(ccButtonAction:)
       forControlEvents:UIControlEventTouchUpInside];
    }
    objc_setAssociatedObject(self, @selector(blockClick), blockClick, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma mark - Getter
- (void (^)(UIButton *))blockButton {
    return objc_getAssociatedObject(self, _cmd);
}
- (void (^)(UIButton *))blockClick {
    return objc_getAssociatedObject(self, _cmd);
}

- (void) ccButtonAction : (UIButton *) sender {
    ccWeakSelf;
    CC_Safe_Operation(self.blockButton, ^{
        pSelf.blockButton(sender);
    });
    CC_Safe_Operation(self.blockClick, ^{
        pSelf.blockClick(sender);
    });
}

@end
