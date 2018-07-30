//
//  UICollectionView+MQExtension_Refresh.m
//  MQExtensionKit
//
//  Created by Elwinfrederick on 14/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "UICollectionView+MQExtension_Refresh.h"
#import "NSObject+CCProtocol.h"

#if __has_include(<MJRefresh/MJRefresh.h>)

@implementation UICollectionView (MQExtension_Refresh)

- (instancetype) mq_end_loading {
    return [self.mq_end_refresh.mq_end_load_more cc];
}
- (instancetype) mq_end_refresh {
    [self.mj_header endRefreshing];
    return self;
}
- (instancetype) mq_end_load_more {
    [self.mj_footer endRefreshing];
    return self;
}

- (instancetype) mq_reset_loading_status {
    [self.mj_footer resetNoMoreData];
    return self;
}
- (instancetype) mq_no_more_data {
    [self.mj_footer endRefreshingWithNoMoreData];
    return self;
}

- (instancetype) mq_refreshing : (void (^)(void)) refreshing {
    [self.mj_header beginRefreshingWithCompletionBlock:^{
        if (refreshing) refreshing();
    }];
    return self;
}
- (instancetype) mq_loading_more : (void (^)(void)) loading {
    [self.mj_footer beginRefreshingWithCompletionBlock:^{
        if (loading) loading();
    }];
    return self;
}

@end

#endif
