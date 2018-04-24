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

- (instancetype) cc_end_loading {
    return [self.cc_end_refresh.cc_end_load_more cc];
}
- (instancetype) cc_end_refresh {
    [self.mj_header endRefreshing];
    return self;
}
- (instancetype) cc_end_load_more {
    [self.mj_footer endRefreshing];
    return self;
}

- (instancetype) cc_reset_loading_status {
    [self.mj_footer resetNoMoreData];
    return self;
}
- (instancetype) cc_no_more_data {
    [self.mj_footer endRefreshingWithNoMoreData];
    return self;
}

- (instancetype) cc_refreshing : (void (^)(void)) refreshing {
    [self.mj_header beginRefreshingWithCompletionBlock:^{
        if (refreshing) refreshing();
    }];
    return self;
}
- (instancetype) cc_loading_more : (void (^)(void)) loading {
    [self.mj_footer beginRefreshingWithCompletionBlock:^{
        if (loading) loading();
    }];
    return self;
}

@end

#endif
