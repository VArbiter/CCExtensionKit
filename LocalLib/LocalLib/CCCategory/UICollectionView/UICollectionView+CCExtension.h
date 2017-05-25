//
//  UICollectionView+CCExtension.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/1.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJRefresh/MJRefresh.h>
#import "UICollectionViewFlowLayout+CCExtension.h"

typedef NS_ENUM(NSInteger , CCCollectionViewEndLoadType) {
    CCCollectionViewEndLoadTypeEnd = 0,
    CCCollectionViewEndLoadTypeNoMoreData ,
    CCCollectionViewEndLoadTypeEndRefresh ,
    CCCollectionViewEndLoadTypeManualEnd
};

@interface UICollectionView (CCExtension)

+ (instancetype) ccInitWithFrame : (CGRect)frame
                      withLayout : (UICollectionViewLayout *)layout
          withDelegateDataSource : (id) delegateDatasource ;

+ (instancetype) ccInitWithFrame : (CGRect)frame
                      withLayout : (UICollectionViewLayout *)layout
                    withDelegate : (id) delegate
                  withDataSource : (id) datasource ;

- (void) ccRegistNib : (NSString *) stringNib ;
- (void) ccRegistClass : (NSString *) stringClazz ;

- (void) ccHeaderRefreshing : (CCCollectionViewEndLoadType(^)()) blockRefresh
          withFooterLoadMore: (CCCollectionViewEndLoadType(^)()) blockLoadMore ;

- (void) ccHeaderEndRefreshing;
- (void) ccFooterEndLoadMore ;

- (void) ccEndLoading ;
- (void) ccFooterEndLoadMoreWithNoMoreData ;
- (void) ccResetLoadMoreStatus ;

- (void) ccReloadData ; // swizz 之后 , 调用这个会产生隐式动画

@end
