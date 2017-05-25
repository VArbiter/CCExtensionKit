//
//  UIButton+CCExtension.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/6.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "UIButton+CCExtension.h"
#import "CCCommonDefine.h"

#import <objc/runtime.h>

@implementation UIButton (CCExtension)

+ (instancetype) ccButtonWithFrame : (CGRect) rectFrame {
    return [self ccButtonWithFrame:rectFrame
                        withTarget:nil
                      withSelector:nil];
}

+ (instancetype) ccButtonWithFrame : (CGRect) rectFrame
                          withType : (UIButtonType) type
                   withNormalTitle : (NSString *) stringTitleNormal
                 withSelectedTitle : (NSString *) stringSelectedTitle
                   withNormalImage : (NSString *) stringImage
                 withSelectedImage : (NSString *) stringSelectedImage {
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

+ (instancetype) ccButtonWithFrame : (CGRect) rectFrame
                        withTarget : (id) target
                      withSelector : (SEL) selector {
    return [self ccButtonWithFrame:rectFrame
                          withType:UIButtonTypeSystem
                   withNormalTitle:nil
                 withSelectedTitle:nil
                   withNormalImage:nil
                 withSelectedImage:nil
                        withTarget:target
                      withSelector:selector];
}

+ (instancetype) ccButtonWithFrame : (CGRect) rectFrame
                         withTitle : (NSString *) stringtitle
                        withTarget : (id) target
                      withSelector : (SEL) selector {
    return [self ccButtonWithFrame:rectFrame
                          withType:UIButtonTypeSystem
                   withNormalTitle:stringtitle
                 withSelectedTitle:nil
                   withNormalImage:nil
                 withSelectedImage:nil
                        withTarget:target
                      withSelector:selector];
}

+ (instancetype) ccButtonWithFrame : (CGRect) rectFrame
                   withNormalImage : (NSString *) stringImage
                 withSelectedImage : (NSString *) stringSelectedImage
                        withTarget : (id) target
                      withSelector : (SEL) selector {
    return [self ccButtonWithFrame:rectFrame
                          withType:UIButtonTypeSystem
                   withNormalTitle:nil
                 withSelectedTitle:nil
                   withNormalImage:stringImage
                 withSelectedImage:stringSelectedImage
                        withTarget:target
                      withSelector:selector];
}

+ (instancetype) ccButtonWithFrame : (CGRect) rectFrame
                          withType : (UIButtonType) type
                   withNormalImage : (NSString *) stringImage
                 withSelectedImage : (NSString *) stringSelectedImage
                        withTarget : (id) target
                      withSelector : (SEL) selector {
    return [self ccButtonWithFrame:rectFrame
                          withType:type
                   withNormalTitle:nil
                 withSelectedTitle:nil
                   withNormalImage:stringImage
                 withSelectedImage:stringSelectedImage
                        withTarget:target
                      withSelector:selector];
}

+ (instancetype) ccButtonWithFrame : (CGRect) rectFrame
                   withNormalTitle : (NSString *) stringTitleNormal
                 withSelectedTitle : (NSString *) stringSelectedTitle
                        withTarget : (id) target
                      withSelector : (SEL) selector {
    return [self ccButtonWithFrame:rectFrame
                          withType:UIButtonTypeSystem
                   withNormalTitle:stringTitleNormal
                 withSelectedTitle:stringSelectedTitle
                   withNormalImage:nil
                 withSelectedImage:nil
                        withTarget:target
                      withSelector:selector];
}

+ (instancetype) ccButtonWithFrame : (CGRect) rectFrame
                          withType : (UIButtonType) type
                   withNormalTitle : (NSString *) stringTitleNormal
                 withSelectedTitle : (NSString *) stringSelectedTitle
                   withNormalImage : (NSString *) stringImage
                 withSelectedImage : (NSString *) stringSelectedImage
                        withTarget : (id) target
                      withSelector : (SEL) selector {
    UIButton *button = [UIButton ccButtonWithFrame:rectFrame
                                          withType:type
                                   withNormalTitle:stringTitleNormal
                                 withSelectedTitle:stringSelectedTitle
                                   withNormalImage:stringImage
                                 withSelectedImage:stringSelectedImage];
    
    if ([target respondsToSelector:selector]) {
        [button addTarget:target
                   action:selector
         forControlEvents:UIControlEventTouchUpInside];
    }
    
    return button;
}

#pragma mark - Block

+ (instancetype) ccButtonWithFrame : (CGRect) rectFrame
                    withClickblock : (void(^)(UIButton *sender)) blockButton {
    return [self ccButtonWithFrame:rectFrame
                   withNormalImage:nil
                 withSelectedImage:nil
                    withClickblock:blockButton];
}

+ (instancetype) ccButtonWithFrame : (CGRect) rectFrame
                         withTitle : (NSString *) stringtitle
                    withClickblock : (void(^)(UIButton *sender)) blockButton {
    return [self ccButtonWithFrame:rectFrame
                   withNormalTitle:stringtitle
                 withSelectedTitle:nil
                    withClickblock:blockButton];
}

+ (instancetype) ccButtonWithFrame : (CGRect) rectFrame
                    withButtonType : (UIButtonType) type
                         withTitle : (NSString *) stringtitle
                    withClickblock : (void(^)(UIButton *sender)) blockButton {
    return [self ccButtonWithFrame:rectFrame
                          withType:type
                   withNormalTitle:stringtitle
                 withSelectedTitle:nil
                   withNormalImage:nil
                 withSelectedImage:nil
                    withClickblock:blockButton];
}

+ (instancetype) ccButtonWithFrame : (CGRect) rectFrame
                   withNormalImage : (NSString *) stringImage
                 withSelectedImage : (NSString *) stringSelectedImage
                    withClickblock : (void(^)(UIButton *sender)) blockButton{
    return [self ccButtonWithFrame:rectFrame
                          withType:UIButtonTypeSystem
                   withNormalTitle:nil
                 withSelectedTitle:nil
                   withNormalImage:stringImage
                 withSelectedImage:stringSelectedImage
                    withClickblock:blockButton];
}

+ (instancetype) ccButtonWithFrame : (CGRect) rectFrame
                    withButtonType : (UIButtonType) type
                   withNormalImage : (NSString *) stringImage
                    withClickblock : (void(^)(UIButton *sender)) blockButton {
    return [self ccButtonWithFrame:rectFrame
                    withButtonType:type
                   withNormalImage:stringImage
                 withSelectedImage:nil
                    withClickblock:blockButton];
}

+ (instancetype) ccButtonWithFrame : (CGRect) rectFrame
                    withButtonType : (UIButtonType) type
                   withNormalImage : (NSString *) stringImage
                 withSelectedImage : (NSString *) stringSelectedImage
                    withClickblock : (void(^)(UIButton *sender)) blockButton{
    return [self ccButtonWithFrame:rectFrame
                          withType:type
                   withNormalTitle:nil
                 withSelectedTitle:nil
                   withNormalImage:stringImage
                 withSelectedImage:stringSelectedImage
                    withClickblock:blockButton];
}

+ (instancetype) ccButtonWithFrame : (CGRect) rectFrame
                   withNormalTitle : (NSString *) stringTitleNormal
                 withSelectedTitle : (NSString *) stringSelectedTitle
                    withClickblock : (void(^)(UIButton *sender)) blockButton{
    return [self ccButtonWithFrame:rectFrame
                          withType:UIButtonTypeSystem
                   withNormalTitle:stringTitleNormal
                 withSelectedTitle:stringSelectedTitle
                   withNormalImage:nil
                 withSelectedImage:nil
                    withClickblock:blockButton];
}

+ (instancetype) ccButtonWithFrame : (CGRect) rectFrame
                          withType : (UIButtonType) type
                   withNormalTitle : (NSString *) stringTitleNormal
                 withSelectedTitle : (NSString *) stringSelectedTitle
                   withNormalImage : (NSString *) stringImage
                 withSelectedImage : (NSString *) stringSelectedImage
                    withClickblock : (void(^)(UIButton *sender)) blockButton{
    UIButton *button = [UIButton ccButtonWithFrame:rectFrame
                                          withType:type
                                   withNormalTitle:stringTitleNormal
                                 withSelectedTitle:stringSelectedTitle
                                   withNormalImage:stringImage
                                 withSelectedImage:stringSelectedImage];
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
    _CC_Safe_Block_(self.blockButton, ^{
        pSelf.blockButton(sender);
    });
    _CC_Safe_Block_(self.blockClick, ^{
        pSelf.blockClick(sender);
    });
}

@end
