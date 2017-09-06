//
//  UICollectionView+CCExtension.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/1.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionView (CCExtension)

/// auto enable prefetchiong if support
+ (instancetype) common : (CGRect) frame
                 layout : (UICollectionViewFlowLayout *) layout;
- (instancetype) ccDelegate : (id <UICollectionViewDelegateFlowLayout>) delegate ;
- (instancetype) ccDataSource : (id <UICollectionViewDataSource>) dataSource ;

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
/// data source that pre-fetching
- (instancetype) ccPrefetching : (id <UICollectionViewDataSourcePrefetching>) prefetch ;
#endif

/// requires that nib name is equal to cell's idetifier .
- (instancetype) ccRegistNib : (NSString *) sNib ;
- (instancetype) ccRegistNib : (NSString *) sNib
                      bundle : (NSBundle *) bundle ;
/// requires that class name is equal to cell's idetifier .
- (instancetype) ccRegistCls : (Class) cls ;

/// for non-animated , only section 0 was available.
/// note : false means reloading without hidden animations .
/// note : if animated is setting to YES , only section 0 will be reloaded .
/// note : if reloeded muti sections , using "ccReloadSections:animated:" down below
- (instancetype) ccReloading : (BOOL) isAnimated;
- (instancetype) ccReloadSections : (NSIndexSet *) set
                         animated : (BOOL) isAnimated ;
- (instancetype) ccReloadItems : (NSArray <NSIndexPath *> *) arrayItems;

/// for cell that register in collection
- (__kindof UICollectionViewCell *) ccDeqCell : (NSString *) sIdentifier
                                    indexPath : (NSIndexPath *) indexPath ;
/// for reusable view
- (__kindof UICollectionReusableView *) ccDeqReuseableView : (NSString *) sElementKind
                                                identifier : (NSString *) sIdentifier
                                                 indexPath : (NSIndexPath *) indexPath ;

@end

#pragma mark - UICollectionViewFlowLayout --------------------------------------

@interface UICollectionViewFlowLayout (CCExtension)

+ (instancetype) common ;

/// for default sizes
- (instancetype) ccItemSize : (CGSize) size ;
- (instancetype) ccSectionsInsets : (UIEdgeInsets) insets ;
- (instancetype) ccHeaderSize : (CGSize) size ;

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

