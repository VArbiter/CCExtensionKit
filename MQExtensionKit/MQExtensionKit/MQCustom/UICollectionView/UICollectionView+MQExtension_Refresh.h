//
//  UICollectionView+MQExtension_Refresh.h
//  MQExtensionKit
//
//  Created by Elwinfrederick on 14/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

#if __has_include(<MJRefresh/MJRefresh.h>)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wstrict-prototypes"
    @import MJRefresh;
#pragma clang diagnostic pop

@interface UICollectionView (CCExtension_Refresh)

/// equals : endRefresh + endLoadMore // 等同于 endRefresh + endLoadMore
- (instancetype) mq_end_loading ;
- (instancetype) mq_end_refresh ;
- (instancetype) mq_end_load_more ;

- (instancetype) mq_reset_loading_status ;
- (instancetype) mq_no_more_data ;

- (instancetype) mq_refreshing : (void (^)(void)) refreshing ;
- (instancetype) mq_loading_more : (void (^)(void)) loading ;

@end

#endif
