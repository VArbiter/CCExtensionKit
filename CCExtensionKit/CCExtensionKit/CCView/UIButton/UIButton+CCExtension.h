//
//  UIButton+CCExtension.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/6.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (CCExtension)

/// default type is custom
+ (instancetype) common ;
+ (instancetype) common : (UIButtonType) type ;
- (instancetype) ccFrame : (CGRect) frame ;

/// titles && images
- (instancetype) ccTitle : (NSString *) sTitle
                   state : (UIControlState) state ;
- (instancetype) ccImage : (UIImage *) image
                   state : (UIControlState) state ;

/// actions , default is touchUpInside
- (instancetype) ccAction : (void (^)( __kindof UIButton *sender)) action ;
- (instancetype) ccTarget : (id) target
                   action : (void (^)( __kindof UIButton *sender)) action ;

/// custom actions .
- (instancetype) ccCustom : (id) target
                      sel : (SEL) sel
                   events : (UIControlEvents) events ;

@end
