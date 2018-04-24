//
//  UICollectionView+CCExtension_Refresh.h
//  CCLocalLibrary
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
- (instancetype) cc_end_loading ;
- (instancetype) cc_end_refresh ;
- (instancetype) cc_end_load_more ;

- (instancetype) cc_reset_loading_status ;
- (instancetype) cc_no_more_data ;

- (instancetype) cc_refreshing : (void (^)(void)) refreshing ;
- (instancetype) cc_loading_more : (void (^)(void)) loading ;

@end

#endif
