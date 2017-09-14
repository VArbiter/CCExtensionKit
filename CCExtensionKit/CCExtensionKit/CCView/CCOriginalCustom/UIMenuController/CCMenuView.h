//
//  CCMenuView.h
//  CCLocalLibrary
//
//  Created by Elwinfrederick on 14/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

/// this file that makes UIMenuController's item can be managed && sorted .

@class CCMenuView;

@protocol CCMenuViewProtocol <NSObject>

@optional
- (void) ccMenuViewDidClose : (CCMenuView *) menuView ;

@end

@interface CCMenuView : UIView < CCMenuViewProtocol >

/// show for frame , @[@{@"methodName" : @"showingTitle"}] ,
/// note : it will shown exclusive in that order you've given in array .
/// note : when you give out the methodName , make sure that won't use by system .
/// eg (for method name): copy -> error && crash , copyy -> correct

- (instancetype) ccShow : (CGRect) frame
                  items : (NSArray <NSDictionary <NSString * , NSString *> *> *) arrayTitles ;
- (instancetype) ccClick : (void (^)(NSDictionary *dTotal ,
                                     NSString *sKey ,
                                     NSString *sValue ,
                                     NSInteger index)) click ;
- (instancetype) ccDelegate : (id <CCMenuViewProtocol>) delegate ;

/// remove form super view && destory (set to nil) .
void CC_DESTORY_MENU_ITEM(CCMenuView *view);

@end
