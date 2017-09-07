//
//  UICollectionView+CCExtension.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/1.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "UICollectionView+CCExtension.h"
#import <objc/runtime.h>

#ifndef _CC_COLLECTION_VIEW_HOLDER_ITEM_IDENTIFIER_
    #define _CC_COLLECTION_VIEW_HOLDER_ITEM_IDENTIFIER_ @"CC_COLLECTION_VIEW_HOLDER_ITEM_IDENTIFIER"
#endif

@implementation UICollectionView (CCExtension)

+ (instancetype) common : (CGRect) frame
                 layout : (UICollectionViewFlowLayout *) layout {
    UICollectionView *c = [[UICollectionView alloc] initWithFrame:frame
                                             collectionViewLayout:layout];
    c.backgroundColor = UIColor.clearColor;
    c.showsVerticalScrollIndicator = false;
    c.showsHorizontalScrollIndicator = false;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
    c.prefetchingEnabled = YES;
#endif
    
    [c registerClass:UICollectionViewCell.class
forCellWithReuseIdentifier:_CC_COLLECTION_VIEW_HOLDER_ITEM_IDENTIFIER_];
    return c;
}
- (instancetype) ccDelegate : (id <UICollectionViewDelegateFlowLayout>) delegate {
    if (delegate) self.delegate = delegate;
    else self.delegate = nil;
    return self;
}
- (instancetype) ccDataSource : (id <UICollectionViewDataSource>) dataSource {
    if (dataSource) self.dataSource = dataSource;
    else self.dataSource = nil;
    return self;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
- (instancetype) ccPrefetching : (id <UICollectionViewDataSourcePrefetching>) prefetch {
    if (prefetch) self.prefetchDataSource = prefetch;
    else self.prefetchDataSource = nil;
    return self;
}
#endif

- (instancetype) ccRegistNib : (NSString *) sNib {
    return [self ccRegistNib:sNib bundle:nil];
}
- (instancetype) ccRegistNib : (NSString *) sNib
                      bundle : (NSBundle *) bundle {
    if (!bundle) bundle = NSBundle.mainBundle;
    [self registerNib:[UINib nibWithNibName:sNib
                                     bundle:bundle]
forCellWithReuseIdentifier:sNib];
    return self;
}

- (instancetype) ccRegistCls : (Class) cls {
    [self registerClass:cls
forCellWithReuseIdentifier:NSStringFromClass(cls)];
    return self;
}

- (instancetype) ccReloading : (BOOL) isAnimated {
    if (isAnimated) {
        [self ccReloadSections:[NSIndexSet indexSetWithIndex:0]
                      animated:isAnimated];
    } else [self reloadData];
    return self;
}
- (instancetype) ccReloadSections : (NSIndexSet *) set
                         animated : (BOOL) isAnimated {
    if (isAnimated) {
        [self reloadSections:set];
    } else {
        __weak typeof(self) pSelf = self;
        void (^t)() = ^ {
            [UIView setAnimationsEnabled:false];
            [self performBatchUpdates:^{
                [pSelf reloadSections:set];
            } completion:^(BOOL finished) {
                [UIView setAnimationsEnabled:YES];
            }];
        };
        if (NSThread.isMainThread) t();
        else dispatch_sync(dispatch_get_main_queue(), ^{
            t();
        });
    }
    return self;
}
- (instancetype) ccReloadItems : (NSArray <NSIndexPath *> *) arrayItems {
    [self reloadItemsAtIndexPaths:(arrayItems ? arrayItems : @[])];
    return self;
}

/// for cell that register in collection
- (__kindof UICollectionViewCell *) ccDeqCell : (NSString *) sIdentifier
                                    indexPath : (NSIndexPath *) indexPath {
    if (sIdentifier && sIdentifier.length && indexPath)
        return [self dequeueReusableCellWithReuseIdentifier:sIdentifier
                                               forIndexPath:indexPath];
    return nil;
}
/// for reusable view
- (__kindof UICollectionReusableView *) ccDeqReuseableView : (NSString *) sElementKind
                                                identifier : (NSString *) sIdentifier
                                                 indexPath : (NSIndexPath *) indexPath {
    if (sElementKind && sElementKind.length && sIdentifier && sIdentifier.length && indexPath)
        return [self dequeueReusableSupplementaryViewOfKind:sElementKind
                                        withReuseIdentifier:sIdentifier
                                               forIndexPath:indexPath];
    return nil;
}

@end

#pragma mark - UICollectionViewFlowLayout --------------------------------------

@implementation UICollectionViewFlowLayout (CCExtension)

+ (instancetype) common {
    return UICollectionViewFlowLayout.alloc.init;
}

/// for default sizes
- (instancetype) ccItemSize : (CGSize) size {
    self.itemSize = size;
    return self;
}
- (instancetype) ccSectionsInsets : (UIEdgeInsets) insets {
    self.sectionInset = insets;
    return self;
}
- (instancetype) ccHeaderSize : (CGSize) size {
    self.headerReferenceSize = size;
    return self;
}

@end

#pragma mark - -----

#import "CCCommon.h"

@interface CCCollectionExtensionDelegate ()

@property (nonatomic , copy) BOOL (^blockDidSelect)(UICollectionView *collectionView , NSIndexPath *indexPath) ;
@property (nonatomic , copy) void (^blockDidHightedCell)(UICollectionView *collectionView , NSIndexPath *indexPath) ;
@property (nonatomic , copy) void (^blockDidUnhigntedCell)(UICollectionView *collectionView , NSIndexPath *indexPath) ;
@property (nonatomic , copy) CGFloat (^blockMinimumLineSpacingInSection)(UICollectionView *collectionView , UICollectionViewLayout *layout , NSInteger integerSection) ;
@property (nonatomic , copy) CGFloat (^blockMinimumInteritemSpacingInSection)(UICollectionView *collectionView , UICollectionViewLayout *layout , NSInteger integerSection) ;
@property (nonatomic , copy) UIEdgeInsets (^blockSpacingBetweenSections)(UICollectionView *collectionView , UICollectionViewLayout *layout , NSInteger integerSection) ;

@end

@implementation CCCollectionExtensionDelegate

- (id < UICollectionViewDelegateFlowLayout > ) init {
    if (self = [super init]) {
        return self;
    }
    return self;
}

- (instancetype) ccDidSelect : (BOOL (^)(UICollectionView *collectionView ,
                                         NSIndexPath *indexPath)) didSelect {
    self.blockDidSelect = [didSelect copy];
    return self;
}
- (instancetype) ccDidHighted : (void (^)(UICollectionView *collectionView ,
                                          NSIndexPath *indexPath)) didHighLighted {
    self.blockDidHightedCell = [didHighLighted copy];
    return self;
}
- (instancetype) ccDidUnHighted : (void (^)(UICollectionView *collectionView ,
                                            NSIndexPath *indexPath)) didUnHighLighted {
    self.blockDidUnhigntedCell = [didUnHighLighted copy];
    return self;
}
- (instancetype) ccMinimumLineSpacingInSection : (CGFloat (^)(UICollectionView *collectionView ,
                                                              UICollectionViewLayout *layout ,
                                                              NSInteger iSection)) minimumLineSpacingInSection {
    self.blockMinimumLineSpacingInSection = [minimumLineSpacingInSection copy];
    return self;
}
- (instancetype) ccMinimumInteritemSpacingInSection : (CGFloat (^)(UICollectionView *collectionView ,
                                                                   UICollectionViewLayout *layout ,
                                                                   NSInteger iSection)) minimumInteritemSpacingInSection {
    self.blockMinimumInteritemSpacingInSection = [minimumInteritemSpacingInSection copy];
    return self;
}
- (instancetype) ccSpacingBetweenSections : (UIEdgeInsets(^)(UICollectionView *collectionView ,
                                                             UICollectionViewLayout *layout ,
                                                             NSInteger iSection)) spacingBetweenSections {
    self.blockSpacingBetweenSections = [spacingBetweenSections copy];
    return self;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.blockDidSelect) {
        if (self.blockDidSelect(collectionView , indexPath)) {
            [collectionView deselectItemAtIndexPath:indexPath animated:false];
        }
    }
}
- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.blockDidHightedCell) self.blockDidHightedCell(collectionView, indexPath);
}
- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.blockDidUnhigntedCell) self.blockDidUnhigntedCell(collectionView, indexPath);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return self.blockMinimumLineSpacingInSection ? self.blockMinimumLineSpacingInSection(collectionView , collectionViewLayout , section) : .0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return self.blockMinimumInteritemSpacingInSection ? self.blockMinimumInteritemSpacingInSection (collectionView , collectionViewLayout , section) : .0f;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return self.blockSpacingBetweenSections ? self.blockSpacingBetweenSections(collectionView , collectionViewLayout , section) : UIEdgeInsetsZero ;
}

_CC_DETECT_DEALLOC_

@end

#pragma mark - -----

@interface CCCollectionExtensionDataSource ()

@property (nonatomic , copy) NSInteger (^blockSections)(UICollectionView *collectionView) ;
@property (nonatomic , copy) NSInteger (^blockItemsInSections)(UICollectionView * collectionView , NSInteger integerSections) ;
@property (nonatomic , copy) NSString *(^blockCellIdentifier)(UICollectionView * collectionView , NSIndexPath * indexPath) ;
@property (nonatomic , copy) UICollectionViewCell *(^blockConfigCell)(UICollectionView * collectionView , UICollectionViewCell * cellConfig , NSIndexPath * indexPath);

@end

@implementation CCCollectionExtensionDataSource

- (id < UICollectionViewDataSource >) init {
    if ((self = [super init])) {
        return self;
    }
    return self;
}
- (instancetype) ccSections : (NSInteger (^)(UICollectionView *collectionView)) sections {
    self.blockSections = [sections copy];
    return self;
}
- (instancetype) ccItemsInSections : (NSInteger (^)(UICollectionView * collectionView ,
                                                    NSInteger iSections)) itemInSections {
    self.blockItemsInSections = [itemInSections copy];
    return self;
}
- (instancetype) ccCellIdentifier : (NSString *(^)(UICollectionView * collectionView ,
                                                   NSIndexPath * indexPath)) identifier {
    self.blockCellIdentifier = [identifier copy];
    return self;
}
- (instancetype) ccConfiguration : (UICollectionViewCell *(^)(UICollectionView * collectionView ,
                                                              __kindof UICollectionViewCell * cell ,
                                                              NSIndexPath * indexPath)) configuration {
    self.blockConfigCell = [configuration copy];
    return self;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.blockSections ? self.blockSections(collectionView) : 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.blockItemsInSections ? self.blockItemsInSections(collectionView , section) : 0;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *stringCellIdentifier = self.blockCellIdentifier ? self.blockCellIdentifier(collectionView , indexPath) : _CC_COLLECTION_VIEW_HOLDER_ITEM_IDENTIFIER_;
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:stringCellIdentifier
                                                                           forIndexPath:indexPath];
    if (!cell) cell = [[UICollectionViewCell alloc] init];
    return self.blockConfigCell ? self.blockConfigCell(collectionView , cell , indexPath) : cell;
}

_CC_DETECT_DEALLOC_

@end

#pragma mark - -----

@implementation NSArray (CCExtension_Collection_Refresh)

- (instancetype) ccReload : (UICollectionView *) collectionView {
    if (self.count) [collectionView ccReloading:YES];
    else [collectionView reloadData];
    return self;
}
- (instancetype) ccReload : (UICollectionView *) collectionView
                 sections : (NSIndexSet *) set {
    if (self.count) [collectionView ccReloadSections:set
                                            animated:YES];
    else [collectionView ccReloadSections:set
                                 animated:false];
    return self;
}

@end

#pragma mark - -----

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0

#import <objc/runtime.h>

@interface CCCollectionExtensionDataPrefetching ()

@property (nonatomic , assign) BOOL isDisableBackground ;
@property (nonatomic , copy) void (^prefetching)(__kindof UICollectionView *, NSArray<NSIndexPath *> *);
@property (nonatomic , copy) void (^canceling)(__kindof UICollectionView *, NSArray<NSIndexPath *> *);

@property (nonatomic) dispatch_queue_t queue ;

@end

@implementation CCCollectionExtensionDataPrefetching

- (id <UICollectionViewDataSourcePrefetching> ) init {
    if ((self = [super init])) {
        
    }
    return self;
}
- (instancetype) ccDisableBackgroundMode {
    self.isDisableBackground = YES;
    return self;
}
- (instancetype) ccPrefetchAt : (void (^)(__kindof UICollectionView *collectionView ,
                                          NSArray <NSIndexPath *> *array)) fetch {
    self.prefetching = [fetch copy];
    return self;
}
- (instancetype) ccCancelPrefetchAt : (void (^)(__kindof UICollectionView *collectionView ,
                                                NSArray <NSIndexPath *> *array)) cancel {
    self.canceling = [cancel copy];
    return self;
}

- (void)collectionView:(UICollectionView *)collectionView prefetchItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths NS_AVAILABLE_IOS(10_0) {
    if (!self.queue && !self.isDisableBackground) {
        if (UIDevice.currentDevice.systemVersion.floatValue >= 8.f) {
            self.queue = dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0);
        }
        else self.queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    }
    
    if (!self.isDisableBackground) {
        __weak typeof(self) pSelf = self;
        dispatch_async(self.queue, ^{
            if (pSelf.prefetching) pSelf.prefetching(collectionView, indexPaths);
        });
    }
    else if (self.prefetching) self.prefetching(collectionView, indexPaths);
}

- (void)collectionView:(UICollectionView *)collectionView cancelPrefetchingForItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths  NS_AVAILABLE_IOS(10_0) {
    if (self.canceling) self.canceling(collectionView , indexPaths);
}

@end

#endif


