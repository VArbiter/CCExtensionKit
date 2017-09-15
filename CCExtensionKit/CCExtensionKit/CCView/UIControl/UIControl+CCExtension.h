//
//  UIControl+CCExtension.h
//  CCLocalLibrary
//
//  Created by Elwinfrederick on 08/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (CCExtension)

+ (instancetype) common : (CGRect) frame ;
/// actions , default is touchUpInside
- (instancetype) ccActions : (void (^)( __kindof UIControl *sender)) action ;
- (instancetype) ccTarget : (id) target
                  actions : (void (^)( __kindof UIControl *sender)) action ;
/// custom actions .
- (instancetype) ccTarget : (id) target
                 selector : (SEL) sel
                   events : (UIControlEvents) events ;
/// increase trigger rect .
- (instancetype) ccIncrease : (UIEdgeInsets) insets ;

@end
