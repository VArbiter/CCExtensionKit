//
//  UITableView+CCExtension.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/1.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJRefresh/MJRefresh.h>

typedef NS_ENUM(NSInteger , CCTableViewEndLoadType) {
    CCTableViewEndLoadTypeEnd = 0,
    CCTableViewEndLoadTypeNoMoreData ,
    CCTableViewEndLoadTypeEndRefresh ,
    CCTableViewEndLoadTypeManualEnd
};

@interface UITableView (CCExtension)

+ (instancetype) ccInitWithFrame : (CGRect) rectFrame;
+ (instancetype) ccInitWithFrame : (CGRect) rectFrame
          withDelegateDataSource : (id) delegateDataSource ;
+ (instancetype) ccInitWithFrame : (CGRect) rectFrame
                    withDelegate : (id) delegate
                  withDataSource : (id) dataSource ;
+ (instancetype) ccInitWithFrame : (CGRect) rectFrame
                       withStyle : (UITableViewStyle) style
          withDelegateDataSource : (id) delegateDataSource ;
+ (instancetype) ccInitWithFrame : (CGRect) rectFrame
                       withStyle : (UITableViewStyle) style
                    withDelegate : (id) delegate
                  withDataSource : (id) dataSource ;

- (void) ccRegistNib : (NSString *) stringNib ;
- (void) ccRegistClass : (NSString *) stringClazz ;

- (void) ccHeaderRefreshing : (CCTableViewEndLoadType(^)()) blockRefresh
          withFooterLoadMore: (CCTableViewEndLoadType(^)()) blockLoadMore ;

- (void) ccUpdateing : (dispatch_block_t) block ;

- (void) ccHeaderEndRefreshing;
- (void) ccFooterEndLoadMore ;

- (void) ccEndLoading ;
- (void) ccFooterEndLoadMoreWithNoMoreData ;
- (void) ccResetLoadMoreStatus ;

@end
