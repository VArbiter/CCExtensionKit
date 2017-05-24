//
//  UICollectionView+YMExtension.h
//  ym_sell_ios
//
//  Created by 冯明庆 on 2017/4/1.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJRefresh/MJRefresh.h>
#import "UICollectionViewFlowLayout+YMExtension.h"

typedef NS_ENUM(NSInteger , YMCollectionViewEndLoadType) {
    YMCollectionViewEndLoadTypeEnd = 0,
    YMCollectionViewEndLoadTypeNoMoreData ,
    YMCollectionViewEndLoadTypeEndRefresh ,
    YMCollectionViewEndLoadTypeManualEnd
};

@interface UICollectionView (YMExtension)

+ (instancetype) ymInitWithFrame : (CGRect)frame
                      withLayout : (UICollectionViewLayout *)layout
          withDelegateDataSource : (id) delegateDatasource ;

+ (instancetype) ymInitWithFrame : (CGRect)frame
                      withLayout : (UICollectionViewLayout *)layout
                    withDelegate : (id) delegate
                  withDataSource : (id) datasource ;

- (void) ymRegistNib : (NSString *) stringNib ;
- (void) ymRegistClass : (NSString *) stringClazz ;

- (void) ymHeaderRefreshing : (YMCollectionViewEndLoadType(^)()) blockRefresh
          withFooterLoadMore: (YMCollectionViewEndLoadType(^)()) blockLoadMore ;

- (void) ymHeaderEndRefreshing;
- (void) ymFooterEndLoadMore ;

- (void) ymEndLoading ;
- (void) ymFooterEndLoadMoreWithNoMoreData ;
- (void) ymResetLoadMoreStatus ;

- (void) ymReloadData ; // swizz 之后 , 调用这个会产生隐式动画

@end
