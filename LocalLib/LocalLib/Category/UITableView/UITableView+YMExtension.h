//
//  UITableView+YMExtension.h
//  ym_sell_ios
//
//  Created by 冯明庆 on 2017/4/1.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJRefresh/MJRefresh.h>

typedef NS_ENUM(NSInteger , YMTableViewEndLoadType) {
    YMTableViewEndLoadTypeEnd = 0,
    YMTableViewEndLoadTypeNoMoreData ,
    YMTableViewEndLoadTypeEndRefresh ,
    YMTableViewEndLoadTypeManualEnd
};

@interface UITableView (YMExtension)

+ (instancetype) ymInitWithFrame : (CGRect) rectFrame;
+ (instancetype) ymInitWithFrame : (CGRect) rectFrame
          withDelegateDataSource : (id) delegateDataSource ;
+ (instancetype) ymInitWithFrame : (CGRect) rectFrame
                    withDelegate : (id) delegate
                  withDataSource : (id) dataSource ;
+ (instancetype) ymInitWithFrame : (CGRect) rectFrame
                       withStyle : (UITableViewStyle) style
          withDelegateDataSource : (id) delegateDataSource ;
+ (instancetype) ymInitWithFrame : (CGRect) rectFrame
                       withStyle : (UITableViewStyle) style
                    withDelegate : (id) delegate
                  withDataSource : (id) dataSource ;

- (void) ymRegistNib : (NSString *) stringNib ;
- (void) ymRegistClass : (NSString *) stringClazz ;

- (void) ymHeaderRefreshing : (YMTableViewEndLoadType(^)()) blockRefresh
          withFooterLoadMore: (YMTableViewEndLoadType(^)()) blockLoadMore ;

- (void) ymUpdateing : (dispatch_block_t) block ;

- (void) ymHeaderEndRefreshing;
- (void) ymFooterEndLoadMore ;

- (void) ymEndLoading ;
- (void) ymFooterEndLoadMoreWithNoMoreData ;
- (void) ymResetLoadMoreStatus ;

@end
