//
//  UIButton+CCExtension.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/6.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (CCExtension)

/// default type is custom // 默认是 custom 类型
+ (instancetype) common ;
+ (instancetype) common : (UIButtonType) type ;

/// titles && images // title 和 images
- (instancetype) ccTitle : (NSString *) sTitle
                   state : (UIControlState) state ;
- (instancetype) ccImage : (UIImage *) image
                   state : (UIControlState) state ;

/// actions , default is touchUpInside // 动作  默认 touchUpInside
- (instancetype) ccAction : (void (^)( __kindof UIButton *sender)) action ;
- (instancetype) ccTarget : (id) target
                   action : (void (^)( __kindof UIButton *sender)) action ;

/// custom actions . // 自定义动作
- (instancetype) ccCustom : (id) target
                      sel : (SEL) sel
                   events : (UIControlEvents) events ;

@end
