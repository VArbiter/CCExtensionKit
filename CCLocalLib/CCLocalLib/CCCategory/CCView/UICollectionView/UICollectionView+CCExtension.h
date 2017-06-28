//
//  UICollectionView+CCExtension.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/1.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJRefresh/MJRefresh.h>
#import "CCCommonDefine.h"

@interface UICollectionView (CCExtension)

+ (instancetype) ccCommon : (CGRect)frame
                   layout : (UICollectionViewLayout *)layout
       delegateDataSource : (id) delegateDatasource ;

+ (instancetype) ccCommon : (CGRect)frame
                   layout : (UICollectionViewLayout *)layout
                 delegate : (id) delegate
               dataSource : (id) datasource ;

- (void) ccRegistNib : (NSString *) stringNib ;
- (void) ccRegistClass : (NSString *) stringClazz ;

- (void) ccHeaderRefreshing : (CCEndLoadType(^)()) blockRefresh
             footerLoadMore : (CCEndLoadType(^)()) blockLoadMore ;

- (void) ccHeaderEndRefreshing;
- (void) ccFooterEndLoadMore ;

- (void) ccEndLoading ;
- (void) ccFooterEndLoadMoreWithNoMoreData ;
- (void) ccResetLoadMoreStatus ;

- (void) ccReloadData ; // 屏蔽 隐式动画
- (void) ccReloadSections : (NSIndexSet *) indexSet ;

@end

#pragma mark - UICollectionViewFlowLayout --------------------------------------

@interface UICollectionViewFlowLayout (CCExtension)

+ (instancetype) ccCollectionLayout : (CGSize) sizeItem ;

+ (instancetype) ccCollectionLayout : (CGSize) sizeItem
                       sectionInset : (UIEdgeInsets) edgeInsets ;

+ (instancetype) ccCollectionLayout : (CGSize) sizeItem
                       sectionInset : (UIEdgeInsets) edgeInsets
                         headerSize : (CGSize) sizeHeader ;

@end

#pragma mark - CCCollectionViewDelegate ----------------------------------------

@interface CCCollectionViewDelegate : NSObject < UICollectionViewDelegateFlowLayout >

- (id < UICollectionViewDelegateFlowLayout > ) init;

@property (nonatomic , copy) BOOL (^blockDidSelect)(UICollectionView *collectionView , NSIndexPath *indexPath) ;
@property (nonatomic , copy) void (^blockDidHightedCell)(UICollectionView *collectionView , NSIndexPath *indexPath) ;
@property (nonatomic , copy) void (^blockDidUnhigntedCell)(UICollectionView *collectionView , NSIndexPath *indexPath) ;
@property (nonatomic , copy) CGFloat (^blockMinimumLineSpacingInSection)(UICollectionView *collectionView , UICollectionViewLayout *layout , NSInteger integerSection) ;
@property (nonatomic , copy) CGFloat (^blockMinimumInteritemSpacingInSection)(UICollectionView *collectionView , UICollectionViewLayout *layout , NSInteger integerSection) ;
@property (nonatomic , copy) UIEdgeInsets (^blockSpacingBetweenSections)(UICollectionView *collectionView , UICollectionViewLayout *layout , NSInteger integerSection) ;
@end

#pragma mark - CCCollectionViewDataSource --------------------------------------

@interface CCCollectionViewDataSource : NSObject < UICollectionViewDataSource >

- (id < UICollectionViewDataSource >) init ;

@property (nonatomic , copy) NSInteger (^blockSections)(UICollectionView *collectionView) ;
@property (nonatomic , copy) NSInteger (^blockItemsInSections)(UICollectionView * collectionView , NSInteger integerSections) ;
@property (nonatomic , copy) NSString *(^blockCellIdentifier)(UICollectionView * collectionView , NSIndexPath * indexPath) ;
@property (nonatomic , copy) UICollectionViewCell *(^blockConfigCell)(UICollectionView * collectionView , UICollectionViewCell * cellConfig , NSIndexPath * indexPath);

@end

