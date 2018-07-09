//
//  CCMenuView.h
//  CCExtensionKit
//
//  Created by Elwinfrederick on 14/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

/// this file that makes UIMenuController's item can be managed && sorted . // 这个文件让 UIMenuController 的 item 可以被管理和控制顺序

@class CCMenuView;

@protocol CCMenuViewProtocol <NSObject>

@optional
- (void) ccMenuViewDidClose : (CCMenuView *) menuView ;

@end

@interface CCMenuView : UIView < CCMenuViewProtocol >

/// show for frame , @[@{@"methodName" : @"showingTitle"}] , // 展示的 frame , 参数 @[@{@"方法名" : @" item 标题"}]
/// note : it will shown exclusive in that order you've given in array . // 会严格按照数组给出的顺序来展示
/// note : when you give out the methodName , make sure that won't use by system . // 确保给出的"方法名"不会和系统方法名重名
/// eg (for method name): copy -> error && crash , copyy -> correct // 若给出方法名为 copy , 会崩溃 . copyy 就没有问题

- (instancetype) cc_show : (CGRect) frame
                   items : (NSArray <NSDictionary <NSString * , NSString *> *> *) arrayTitles ;
- (instancetype) cc_click : (void (^)(NSDictionary *dTotal ,
                                      NSString *sKey ,
                                      NSString *sValue ,
                                      NSInteger index)) click ;
- (instancetype) cc_delegate : (id <CCMenuViewProtocol>) delegate ;

/// remove form super view && destory (set to nil) . // 从父视图移除和销毁
void CC_DESTORY_MENU_ITEM(CCMenuView *view);

@end
