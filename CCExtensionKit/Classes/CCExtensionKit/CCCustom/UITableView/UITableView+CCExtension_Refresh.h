//
//  UITableView+CCExtension_Refresh.h
//  CCLocalLibrary
//
//  Created by Elwinfrederick on 14/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

#if __has_include(<MJRefresh/MJRefresh.h>)

@import MJRefresh;

@interface UITableView (CCExtension_Refresh)

/// equals : endRefresh + endLoadMore
- (instancetype) ccEndLoading ;
- (instancetype) ccEndRefresh ;
- (instancetype) ccEndLoadMore ;

- (instancetype) ccResetLoadingStatus ;
- (instancetype) ccNoMoreData ;

- (instancetype) ccRefreshing : (void (^)()) refreshing ;
- (instancetype) ccLoadingMore : (void (^)()) loading ;

@end

#endif
