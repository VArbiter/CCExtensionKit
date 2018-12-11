//
//  MQMenuView.h
//  MQExtensionKit
//
//  Created by Elwinfrederick on 14/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

/// this file that makes UIMenuController's item can be managed && sorted . // 这个文件让 UIMenuController 的 item 可以被管理和控制顺序

@class MQMenuView;

@protocol MQMenuViewProtocol <NSObject>

@optional
- (void) mq_menu_view_did_close : (MQMenuView *) menu_view ;

@end

@interface MQMenuView : UIView < MQMenuViewProtocol >

/// show for frame , @[@{@"methodName" : @"showingTitle"}] , // 展示的 frame , 参数 @[@{@"方法名" : @" item 标题"}]
/// note : it will shown exclusive in that order you've given in array . // 会严格按照数组给出的顺序来展示
/// note : when you give out the methodName , make sure that won't use by system . // 确保给出的"方法名"不会和系统方法名重名
/// eg (for method name): copy -> error && crash , copyy -> correct // 若给出方法名为 copy , 会崩溃 . copyy 就没有问题

- (instancetype) mq_show : (CGRect) frame
                   items : (NSArray <NSDictionary <NSString * , NSString *> *> *) array_titles ;
- (instancetype) mq_click : (void (^)(NSDictionary *d_total ,
                                      NSString *s_key ,
                                      NSString *s_value ,
                                      NSInteger index)) click ;
- (instancetype) mq_delegate : (id <MQMenuViewProtocol>) delegate ;

/// remove form super view && destory (set to nil) . // 从父视图移除和销毁
void MQ_DESTORY_MENU_ITEM(MQMenuView *view);

@end
