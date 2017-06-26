//
//  UITableView+CCExtension.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/1.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJRefresh/MJRefresh.h>

#import "CCCommonDefine.h"

@interface UITableView (CCExtension)

+ (instancetype) ccCommon : (CGRect) rectFrame;
+ (instancetype) ccCommon : (CGRect) rectFrame
       delegateDataSource : (id) delegateDataSource ;
+ (instancetype) ccCommon : (CGRect) rectFrame
                 delegate : (id) delegate
               dataSource : (id) dataSource ;
+ (instancetype) ccCommon : (CGRect) rectFrame
                    style : (UITableViewStyle) style
       delegateDataSource : (id) delegateDataSource ;
+ (instancetype) ccCommon : (CGRect) rectFrame
                    style : (UITableViewStyle) style
                 delegate : (id) delegate
               dataSource : (id) dataSource ;

- (void) ccRegistNib : (NSString *) stringNib ;
- (void) ccRegistClass : (NSString *) stringClazz ;

- (void) ccHeaderRefreshing : (CCEndLoadType(^)()) blockRefresh
             footerLoadMore : (CCEndLoadType(^)()) blockLoadMore ;

- (void) ccUpdateing : (dispatch_block_t) block ;

- (void) ccHeaderEndRefreshing;
- (void) ccFooterEndLoadMore ;

- (void) ccEndLoading ;
- (void) ccFooterEndLoadNoMoreData ;
- (void) ccResetLoadMoreStatus ;

@end

#pragma mark - CCTableViewDelegate ---------------------------------------------

@interface CCTableViewDelegate : NSObject < UITableViewDelegate >

- (id < UITableViewDelegate > ) init ;

@property (nonatomic , copy) CGFloat (^blockCellHeight)(UITableView * tableView , NSIndexPath *indexPath) ;
@property (nonatomic , copy) CGFloat (^blockSectionHeaderHeight)(UITableView * tableView , NSInteger integerSection) ;
@property (nonatomic , copy) UIView *(^blockSectionHeader)(UITableView *tableView , NSInteger integerSection) ;
@property (nonatomic , copy) BOOL (^blockDidSelect)(UITableView *tableView , NSIndexPath *indexPath) ;

@end

#pragma mark - CCTableViewDataSource -------------------------------------------

@interface CCTableViewDataSource : NSObject < UITableViewDataSource >

- (id < UITableViewDataSource >) init ;

@property (nonatomic , copy) NSInteger (^blockSections)(UITableView *tableView);
@property (nonatomic , copy) NSInteger (^blockRowsInSections)(UITableView * tableView , NSInteger integerSection);
@property (nonatomic , copy) NSString * (^blockCellIdentifier)(UITableView *tableView , NSIndexPath *indexPath) ;
@property (nonatomic , copy) UITableViewCell * (^blockConfigCell)(UITableView *tableView , UITableViewCell *cellConfig , NSIndexPath *indexPath) ;

@end
