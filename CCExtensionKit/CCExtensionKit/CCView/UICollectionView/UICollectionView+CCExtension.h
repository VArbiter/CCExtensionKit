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

#pragma mark - -----

@interface UICollectionViewFlowLayout (CCExtension)

+ (instancetype) common ;

/// for default sizes
- (instancetype) ccItemSize : (CGSize) size ;
- (instancetype) ccSectionsInsets : (UIEdgeInsets) insets ;
- (instancetype) ccHeaderSize : (CGSize) size ;

@end

#pragma mark - -----

@interface CCCollectionExtensionDelegate : NSObject < UICollectionViewDelegateFlowLayout >

- (id < UICollectionViewDelegateFlowLayout > ) init;
- (instancetype) ccDidSelect : (BOOL (^)(UICollectionView *collectionView ,
                                         NSIndexPath *indexPath)) didSelect;
- (instancetype) ccDidHighted : (void (^)(UICollectionView *collectionView ,
                                          NSIndexPath *indexPath)) didHighLighted ;
- (instancetype) ccDidUnHighted : (void (^)(UICollectionView *collectionView ,
                                            NSIndexPath *indexPath)) didUnHighLighted ;
- (instancetype) ccMinimumLineSpacingInSection : (CGFloat (^)(UICollectionView *collectionView ,
                                                              UICollectionViewLayout *layout ,
                                                              NSInteger iSection)) minimumLineSpacingInSection;
- (instancetype) ccMinimumInteritemSpacingInSection : (CGFloat (^)(UICollectionView *collectionView ,
                                                                   UICollectionViewLayout *layout ,
                                                                   NSInteger iSection)) minimumInteritemSpacingInSection;
- (instancetype) ccSpacingBetweenSections : (UIEdgeInsets(^)(UICollectionView *collectionView ,
                                                             UICollectionViewLayout *layout ,
                                                             NSInteger iSection)) spacingBetweenSections;

@end

#pragma mark - -----

@interface CCCollectionExtensionDataSource : NSObject < UICollectionViewDataSource >

- (id < UICollectionViewDataSource >) init ;
- (instancetype) ccSections : (NSInteger (^)(UICollectionView *collectionView)) sections ;
- (instancetype) ccItemsInSections : (NSInteger (^)(UICollectionView * collectionView ,
                                                    NSInteger iSections)) itemInSections ;
- (instancetype) ccCellIdentifier : (NSString *(^)(UICollectionView * collectionView ,
                                                   NSIndexPath * indexPath)) identifier ;
- (instancetype) ccConfiguration : (__kindof UICollectionViewCell *(^)(UICollectionView * collectionView ,
                                                                       __kindof UICollectionViewCell * cell ,
                                                                       NSIndexPath * indexPath)) configuration ;

@end

#pragma mark - -----

@interface NSArray (CCExtension_Collection_Refresh)

- (instancetype) ccReload : (UICollectionView *) collectionView ;
- (instancetype) ccReload : (UICollectionView *) collectionView
                 sections : (NSIndexSet *) set ;

@end

#pragma mark - -----

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0

/// pre-fetching
/// note: highly recommended to put prefetching in background thread , in other word , must
/// note: pre-fetch is sort-of auto fit technics , therefore , these method (for dellegate it self)
///     will not recalls for every time the collection view shows it cells .
/// note: that is , if users scrolling slowly or stop to scroll , it will goes pre-fetch
///     if fast , goes not .
/// note: for canceling , when users interested in sth , or reverse it scroll directions ,
///     or press to make system reponse an event , then , canceling was active .
/// note: sometimes canceling was not used in actual.
/// note: when canceling has recall values , maybe it's a subset of 'ccPrefetchAt:'

@interface CCCollectionExtensionDataPrefetching : NSObject < UICollectionViewDataSourcePrefetching >

/// auto enable prefetch in background thread
- (id <UICollectionViewDataSourcePrefetching> ) init ;
- (instancetype) ccDisableBackgroundMode;
- (instancetype) ccPrefetchAt : (void (^)(__kindof UICollectionView *collectionView ,
                                          NSArray <NSIndexPath *> *array)) fetch ;
- (instancetype) ccCancelPrefetchAt : (void (^)(__kindof UICollectionView *collectionView ,
                                                NSArray <NSIndexPath *> *array)) cancel ;

@end

#endif

