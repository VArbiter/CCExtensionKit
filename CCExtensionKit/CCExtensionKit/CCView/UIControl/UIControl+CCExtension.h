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

/// add custom events
/// note : all events within , always respond the latest action .
/// note : that means , for single instance , it's shared .
- (instancetype) ccSharedControlEvent : (UIControlEvents) event
                              actions : (void (^)( __kindof UIControl *sender)) action ;

/// note : it only has effect on event you personaly added by [UIControl.instance ccControlEvent:actions:]
/// note : be ware on event you removed , it might has unknow effects to others
- (instancetype) ccRemoveEvent : (UIControlEvents) event ;

@end
