//
//  UICollectionView+CCExtension_Refresh.m
//  CCLocalLibrary
//
//  Created by Elwinfrederick on 14/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "UICollectionView+CCExtension_Refresh.h"
#import "NSObject+CCProtocol.h"

#if __has_include(<MJRefresh/MJRefresh.h>)

@implementation UICollectionView (CCExtension_Refresh)

- (instancetype) ccEndLoading {
    return [self.ccEndRefresh.ccEndLoadMore cc];
}
- (instancetype) ccEndRefresh {
    [self.mj_header endRefreshing];
    return self;
}
- (instancetype) ccEndLoadMore {
    [self.mj_footer endRefreshing];
    return self;
}

- (instancetype) ccResetLoadingStatus {
    [self.mj_footer resetNoMoreData];
    return self;
}
- (instancetype) ccNoMoreData {
    [self.mj_footer endRefreshingWithNoMoreData];
    return self;
}

- (instancetype) ccRefreshing : (void (^)()) refreshing {
    [self.mj_header beginRefreshingWithCompletionBlock:^{
        if (refreshing) refreshing();
    }];
    return self;
}
- (instancetype) ccLoadingMore : (void (^)()) loading {
    [self.mj_footer beginRefreshingWithCompletionBlock:^{
        if (loading) loading();
    }];
    return self;
}

@end

#endif
