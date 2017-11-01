//
//  UICollectionView+CCExtension_Refresh.h
//  CCLocalLibrary
//
//  Created by Elwinfrederick on 14/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

#if __has_include(<MJRefresh/MJRefresh.h>)

@import MJRefresh;

@interface UICollectionView (CCExtension_Refresh)

/// equals : endRefresh + endLoadMore
- (instancetype) ccEndLoading ;
- (instancetype) ccEndRefresh ;
- (instancetype) ccEndLoadMore ;

- (instancetype) ccResetLoadingStatus ;
- (instancetype) ccNoMoreData ;

- (instancetype) ccRefreshing : (void (^)(void)) refreshing ;
- (instancetype) ccLoadingMore : (void (^)(void)) loading ;

@end

#endif
