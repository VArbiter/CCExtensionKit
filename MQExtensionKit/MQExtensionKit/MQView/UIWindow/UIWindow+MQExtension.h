//
//  UIWindow+MQExtension.h
//  MQExtension_Example
//
//  Created by ElwinFrederick on 2018/11/27.
//  Copyright © 2018 ElwinFrederick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWindow (MQExtension)

/// get current window . // 获得当前的 窗口
+ (instancetype) mq_current_window ;

/// get all app windows . // 获得应用所有的窗口
+ (NSArray <__kindof UIWindow *> *) mq_all_windows ;

@end

@interface UIViewController (MQExtension_Window)

/// when have muti windows . // 如果有多个 window 的话 .
+ (instancetype) mq_windowed_current : (__kindof UIWindow *) window ;

/// current controller that shows on screen . (only the main window) // 当前 main window 上所显示的控制器
+ (instancetype) mq_current ;
+ (instancetype) mq_current_root ;
+ (instancetype) mq_current_navigation;
+ (instancetype) mq_current_from : (__kindof UIViewController *) controller ;

@end
