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
/// actions , default is touchUpInside // 动作 , 默认 touchUpInside
- (instancetype) ccActions : (void (^)( __kindof UIControl *sender)) action ;
- (instancetype) ccTarget : (id) target
                  actions : (void (^)( __kindof UIControl *sender)) action ;
/// custom actions . // 自定义动作
- (instancetype) ccTarget : (id) target
                 selector : (SEL) sel
                   events : (UIControlEvents) events ;
/// increase trigger rect . // 增加响应范围
- (instancetype) ccIncrease : (UIEdgeInsets) insets ;

/// add custom events // 添加自定义动作
/// note : all events within , always respond the latest action . // 所有事件 , 只响应最近的那个
/// note : that means , for single instance , it's shared . // 意味着 , 针对于一个实例来说 , 它是共享的
- (instancetype) ccSharedControlEvent : (UIControlEvents) event
                              actions : (void (^)( __kindof UIControl *sender)) action ;

/// note : it only has effect on event you personaly added by [UIControl.instance ccControlEvent:actions:] // 只针对于 [UIControl.instance ccControlEvent:actions:] 添加的事件起效
/// note : be ware on event you removed , it might has unknow effects to others // 应该注意你移除的事件 , 可能会影响到其它的
- (instancetype) ccRemoveEvent : (UIControlEvents) event ;

@end
