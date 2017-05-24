//
//  UIButton+YMExtension.m
//  ym_sell_ios
//
//  Created by 冯明庆 on 2017/4/6.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "UIButton+YMExtension.h"
#import "YMCommonDefine.h"

#import <objc/runtime.h>

const char * _YM_BUTTON_ASSOCIATE_KEY_;
const char * _YM_BUTTON_CLICK_ASSOCIATE_KEY;

@implementation UIButton (YMExtension)

+ (instancetype) ymButtonWithFrame : (CGRect) rectFrame {
    return [self ymButtonWithFrame:rectFrame
                        withTarget:nil
                      withSelector:nil];
}

+ (instancetype) ymButtonWithFrame : (CGRect) rectFrame
                          withType : (UIButtonType) type
                   withNormalTitle : (NSString *) stringTitleNormal
                 withSelectedTitle : (NSString *) stringSelectedTitle
                   withNormalImage : (NSString *) stringImage
                 withSelectedImage : (NSString *) stringSelectedImage {
    UIButton *button = [UIButton buttonWithType:type];
    button.frame = rectFrame;
    button.titleLabel.font = [UIFont systemFontOfSize:_YM_DEFAULT_FONT_SIZE_];
    if (stringTitleNormal) {
        [button setTitle:stringTitleNormal
                forState:UIControlStateNormal];
    }
    if (stringSelectedTitle) {
        [button setTitle:stringSelectedTitle
                forState:UIControlStateSelected];
    }
    if (stringImage) {
        [button setImage:ymImage(stringImage, YES)
                forState:UIControlStateNormal];
    }
    if (stringSelectedImage) {
        [button setImage:ymImage(stringSelectedImage, YES)
                forState:UIControlStateSelected];
    }
    button.backgroundColor = [UIColor clearColor];
    return button;
}

#pragma mark - Target - Action

+ (instancetype) ymButtonWithFrame : (CGRect) rectFrame
                        withTarget : (id) target
                      withSelector : (SEL) selector {
    return [self ymButtonWithFrame:rectFrame
                          withType:UIButtonTypeSystem
                   withNormalTitle:nil
                 withSelectedTitle:nil
                   withNormalImage:nil
                 withSelectedImage:nil
                        withTarget:target
                      withSelector:selector];
}

+ (instancetype) ymButtonWithFrame : (CGRect) rectFrame
                         withTitle : (NSString *) stringtitle
                        withTarget : (id) target
                      withSelector : (SEL) selector {
    return [self ymButtonWithFrame:rectFrame
                          withType:UIButtonTypeSystem
                   withNormalTitle:stringtitle
                 withSelectedTitle:nil
                   withNormalImage:nil
                 withSelectedImage:nil
                        withTarget:target
                      withSelector:selector];
}

+ (instancetype) ymButtonWithFrame : (CGRect) rectFrame
                   withNormalImage : (NSString *) stringImage
                 withSelectedImage : (NSString *) stringSelectedImage
                        withTarget : (id) target
                      withSelector : (SEL) selector {
    return [self ymButtonWithFrame:rectFrame
                          withType:UIButtonTypeSystem
                   withNormalTitle:nil
                 withSelectedTitle:nil
                   withNormalImage:stringImage
                 withSelectedImage:stringSelectedImage
                        withTarget:target
                      withSelector:selector];
}

+ (instancetype) ymButtonWithFrame : (CGRect) rectFrame
                          withType : (UIButtonType) type
                   withNormalImage : (NSString *) stringImage
                 withSelectedImage : (NSString *) stringSelectedImage
                        withTarget : (id) target
                      withSelector : (SEL) selector {
    return [self ymButtonWithFrame:rectFrame
                          withType:type
                   withNormalTitle:nil
                 withSelectedTitle:nil
                   withNormalImage:stringImage
                 withSelectedImage:stringSelectedImage
                        withTarget:target
                      withSelector:selector];
}

+ (instancetype) ymButtonWithFrame : (CGRect) rectFrame
                   withNormalTitle : (NSString *) stringTitleNormal
                 withSelectedTitle : (NSString *) stringSelectedTitle
                        withTarget : (id) target
                      withSelector : (SEL) selector {
    return [self ymButtonWithFrame:rectFrame
                          withType:UIButtonTypeSystem
                   withNormalTitle:stringTitleNormal
                 withSelectedTitle:stringSelectedTitle
                   withNormalImage:nil
                 withSelectedImage:nil
                        withTarget:target
                      withSelector:selector];
}

+ (instancetype) ymButtonWithFrame : (CGRect) rectFrame
                          withType : (UIButtonType) type
                   withNormalTitle : (NSString *) stringTitleNormal
                 withSelectedTitle : (NSString *) stringSelectedTitle
                   withNormalImage : (NSString *) stringImage
                 withSelectedImage : (NSString *) stringSelectedImage
                        withTarget : (id) target
                      withSelector : (SEL) selector {
    UIButton *button = [UIButton ymButtonWithFrame:rectFrame
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

+ (instancetype) ymButtonWithFrame : (CGRect) rectFrame
                    withClickblock : (void(^)(UIButton *sender)) blockButton {
    return [self ymButtonWithFrame:rectFrame
                   withNormalImage:nil
                 withSelectedImage:nil
                    withClickblock:blockButton];
}

+ (instancetype) ymButtonWithFrame : (CGRect) rectFrame
                         withTitle : (NSString *) stringtitle
                    withClickblock : (void(^)(UIButton *sender)) blockButton {
    return [self ymButtonWithFrame:rectFrame
                   withNormalTitle:stringtitle
                 withSelectedTitle:nil
                    withClickblock:blockButton];
}

+ (instancetype) ymButtonWithFrame : (CGRect) rectFrame
                    withButtonType : (UIButtonType) type
                         withTitle : (NSString *) stringtitle
                    withClickblock : (void(^)(UIButton *sender)) blockButton {
    return [self ymButtonWithFrame:rectFrame
                          withType:type
                   withNormalTitle:stringtitle
                 withSelectedTitle:nil
                   withNormalImage:nil
                 withSelectedImage:nil
                    withClickblock:blockButton];
}

+ (instancetype) ymButtonWithFrame : (CGRect) rectFrame
                   withNormalImage : (NSString *) stringImage
                 withSelectedImage : (NSString *) stringSelectedImage
                    withClickblock : (void(^)(UIButton *sender)) blockButton{
    return [self ymButtonWithFrame:rectFrame
                          withType:UIButtonTypeSystem
                   withNormalTitle:nil
                 withSelectedTitle:nil
                   withNormalImage:stringImage
                 withSelectedImage:stringSelectedImage
                    withClickblock:blockButton];
}

+ (instancetype) ymButtonWithFrame : (CGRect) rectFrame
                    withButtonType : (UIButtonType) type
                   withNormalImage : (NSString *) stringImage
                    withClickblock : (void(^)(UIButton *sender)) blockButton {
    return [self ymButtonWithFrame:rectFrame
                    withButtonType:type
                   withNormalImage:stringImage
                 withSelectedImage:nil
                    withClickblock:blockButton];
}

+ (instancetype) ymButtonWithFrame : (CGRect) rectFrame
                    withButtonType : (UIButtonType) type
                   withNormalImage : (NSString *) stringImage
                 withSelectedImage : (NSString *) stringSelectedImage
                    withClickblock : (void(^)(UIButton *sender)) blockButton{
    return [self ymButtonWithFrame:rectFrame
                          withType:type
                   withNormalTitle:nil
                 withSelectedTitle:nil
                   withNormalImage:stringImage
                 withSelectedImage:stringSelectedImage
                    withClickblock:blockButton];
}

+ (instancetype) ymButtonWithFrame : (CGRect) rectFrame
                   withNormalTitle : (NSString *) stringTitleNormal
                 withSelectedTitle : (NSString *) stringSelectedTitle
                    withClickblock : (void(^)(UIButton *sender)) blockButton{
    return [self ymButtonWithFrame:rectFrame
                          withType:UIButtonTypeSystem
                   withNormalTitle:stringTitleNormal
                 withSelectedTitle:stringSelectedTitle
                   withNormalImage:nil
                 withSelectedImage:nil
                    withClickblock:blockButton];
}

+ (instancetype) ymButtonWithFrame : (CGRect) rectFrame
                          withType : (UIButtonType) type
                   withNormalTitle : (NSString *) stringTitleNormal
                 withSelectedTitle : (NSString *) stringSelectedTitle
                   withNormalImage : (NSString *) stringImage
                 withSelectedImage : (NSString *) stringSelectedImage
                    withClickblock : (void(^)(UIButton *sender)) blockButton{
    UIButton *button = [UIButton ymButtonWithFrame:rectFrame
                                          withType:type
                                   withNormalTitle:stringTitleNormal
                                 withSelectedTitle:stringSelectedTitle
                                   withNormalImage:stringImage
                                 withSelectedImage:stringSelectedImage];
    if (blockButton) {
        button.blockButton = [blockButton copy];
    }
    if ([button respondsToSelector:@selector(ymButtonAction:)]) {
        [button addTarget:button
                   action:@selector(ymButtonAction:)
         forControlEvents:UIControlEventTouchUpInside];
    }
    return button;
}

#pragma mark - Setter
- (void)setBlockButton:(void (^)(UIButton *))blockButton {
    objc_setAssociatedObject(self, &_YM_BUTTON_ASSOCIATE_KEY_, blockButton, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void)setBlockClick:(void (^)(UIButton *))blockClick {
    if (self) {
        [self addTarget:self
                 action:@selector(ymButtonAction:)
       forControlEvents:UIControlEventTouchUpInside];
    }
    objc_setAssociatedObject(self, &_YM_BUTTON_CLICK_ASSOCIATE_KEY, blockClick, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma mark - Getter
- (void (^)(UIButton *))blockButton {
    return objc_getAssociatedObject(self, &_YM_BUTTON_ASSOCIATE_KEY_);
}
- (void (^)(UIButton *))blockClick {
    return objc_getAssociatedObject(self, &_YM_BUTTON_CLICK_ASSOCIATE_KEY);
}

- (void) ymButtonAction : (UIButton *) sender {
    ymWeakSelf;
    _YM_Safe_Block_(self.blockButton, ^{
        pSelf.blockButton(sender);
    });
    _YM_Safe_Block_(self.blockClick, ^{
        pSelf.blockClick(sender);
    });
}

@end
