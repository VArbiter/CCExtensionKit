//
//  UICollectionView+CCExtension.m
//  CCExtensionKit
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

+ (instancetype) cc_common : (CGRect) frame
                    layout : (UICollectionViewFlowLayout *) layout {
    UICollectionView *c = [[UICollectionView alloc] initWithFrame:frame
                                             collectionViewLayout:layout];
    c.backgroundColor = UIColor.clearColor;
    c.showsVerticalScrollIndicator = false;
    c.showsHorizontalScrollIndicator = false;
    if (UIDevice.currentDevice.systemVersion.floatValue >= 10.f) {
        c.prefetchingEnabled = YES;
    }
    
    [c registerClass:UICollectionViewCell.class
forCellWithReuseIdentifier:_CC_COLLECTION_VIEW_HOLDER_ITEM_IDENTIFIER_];
    return c;
}
- (instancetype) cc_delegate : (id <UICollectionViewDelegateFlowLayout>) delegate {
    if (delegate) self.delegate = delegate;
    else self.delegate = nil;
    return self;
}
- (instancetype) cc_datasource : (id <UICollectionViewDataSource>) dataSource {
    if (dataSource) self.dataSource = dataSource;
    else self.dataSource = nil;
    return self;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
- (instancetype) cc_prefetching : (id <UICollectionViewDataSourcePrefetching>) prefetch {
    if (UIDevice.currentDevice.systemVersion.floatValue >= 10.f) {    
        if (prefetch) self.prefetchDataSource = prefetch;
        else self.prefetchDataSource = nil;
    }
    return self;
}
#endif

- (instancetype) cc_regist_nib : (NSString *) sNib {
    return [self cc_regist_nib:sNib bundle:nil];
}
- (instancetype) cc_regist_nib : (NSString *) sNib
                        bundle : (NSBundle *) bundle {
    if (!bundle) bundle = NSBundle.mainBundle;
    [self registerNib:[UINib nibWithNibName:sNib
                                     bundle:bundle]
forCellWithReuseIdentifier:sNib];
    return self;
}

- (instancetype) cc_regist_cls : (Class) cls {
    [self registerClass:cls
forCellWithReuseIdentifier:NSStringFromClass(cls)];
    return self;
}

- (instancetype) cc_reloading : (BOOL) isAnimated {
    if (isAnimated) {
        [self cc_reload_sections:[NSIndexSet indexSetWithIndex:0]
                        animated:isAnimated];
    } else [self reloadData];
    return self;
}
- (instancetype) cc_reload_sections : (NSIndexSet *) set
                           animated : (BOOL) isAnimated {
    if (isAnimated) {
        [self reloadSections:set];
    } else {
        __weak typeof(self) pSelf = self;
        void (^t)(void) = ^ {
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
- (instancetype) cc_reload_items : (NSArray <NSIndexPath *> *) arrayItems {
    [self reloadItemsAtIndexPaths:(arrayItems ? arrayItems : @[])];
    return self;
}

/// for cell that register in collection
- (__kindof UICollectionViewCell *) cc_deq_cell : (NSString *) sIdentifier
                                      indexPath : (NSIndexPath *) indexPath {
    if (sIdentifier && sIdentifier.length && indexPath)
        return [self dequeueReusableCellWithReuseIdentifier:sIdentifier
                                               forIndexPath:indexPath];
    return nil;
}
/// for reusable view
- (__kindof UICollectionReusableView *) cc_deq_reuseable_view : (NSString *) sElementKind
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
- (instancetype) cc_item_size : (CGSize) size {
    self.itemSize = size;
    return self;
}
- (instancetype) cc_sections_insets : (UIEdgeInsets) insets {
    self.sectionInset = insets;
    return self;
}
- (instancetype) cc_header_size : (CGSize) size {
    self.headerReferenceSize = size;
    return self;
}

@end

#pragma mark - -----

#import "CCCommon.h"

@interface CCCollectionExtensionDelegate ()

@property (nonatomic , copy) BOOL (^bDidSelect)(__kindof UICollectionView *collectionView , NSIndexPath *indexPath) ;
@property (nonatomic , copy) void (^bDidHightedCell)(__kindof UICollectionView *collectionView , NSIndexPath *indexPath) ;
@property (nonatomic , copy) void (^bDidUnhigntedCell)(__kindof UICollectionView *collectionView , NSIndexPath *indexPath) ;
@property (nonatomic , copy) CGFloat (^bMinimumLineSpacingInSection)(__kindof UICollectionView *collectionView ,__kindof  UICollectionViewLayout *layout , NSInteger integerSection) ;
@property (nonatomic , copy) CGFloat (^bMinimumInteritemSpacingInSection)(__kindof UICollectionView *collectionView ,__kindof  UICollectionViewLayout *layout , NSInteger integerSection) ;
@property (nonatomic , copy) UIEdgeInsets (^bSpacingBetweenSections)(__kindof UICollectionView *collectionView ,__kindof  UICollectionViewLayout *layout , NSInteger integerSection) ;

@property (nonatomic , copy) void (^bDidScroll)(__kindof UIScrollView *scrollView);
@property (nonatomic , copy) void (^bWillBeginDecelerating)(__kindof UIScrollView *scrollView);
@property (nonatomic , copy) void (^bDidEndDecelerating)(__kindof UIScrollView *scrollView);
@property (nonatomic , copy) BOOL (^bShouldScrollToTop)(__kindof UIScrollView *scrollView);
@property (nonatomic , copy) void (^bDidScrollToTop)(__kindof UIScrollView *scrollView);
@property (nonatomic , copy) void (^bWillBeginDragging)(__kindof UIScrollView *scrollView);
@property (nonatomic , copy) void (^bDidEndDragging)(__kindof UIScrollView *scrollView , BOOL decelerate);

@end

@implementation CCCollectionExtensionDelegate

- (id < UICollectionViewDelegateFlowLayout > ) init {
    if (self = [super init]) {
        return self;
    }
    return self;
}

- (instancetype) cc_did_select : (BOOL (^)(__kindof UICollectionView *collectionView ,
                                         NSIndexPath *indexPath)) didSelect {
    self.bDidSelect = [didSelect copy];
    return self;
}
- (instancetype) cc_did_highted : (void (^)(__kindof UICollectionView *collectionView ,
                                          NSIndexPath *indexPath)) didHighLighted {
    self.bDidHightedCell = [didHighLighted copy];
    return self;
}
- (instancetype) cc_did_un_highted : (void (^)(__kindof UICollectionView *collectionView ,
                                            NSIndexPath *indexPath)) didUnHighLighted {
    self.bDidUnhigntedCell = [didUnHighLighted copy];
    return self;
}
- (instancetype) cc_minimum_line_spacing_in_section : (CGFloat (^)(__kindof UICollectionView *collectionView ,
                                                                   __kindof UICollectionViewLayout *layout ,
                                                                   NSInteger iSection)) minimumLineSpacingInSection {
    self.bMinimumLineSpacingInSection = [minimumLineSpacingInSection copy];
    return self;
}
- (instancetype) cc_minimum_inter_item_spacing_in_section : (CGFloat (^)(__kindof UICollectionView *collectionView ,
                                                                         __kindof UICollectionViewLayout *layout ,
                                                                         NSInteger iSection)) minimumInteritemSpacingInSection {
    self.bMinimumInteritemSpacingInSection = [minimumInteritemSpacingInSection copy];
    return self;
}
- (instancetype) cc_spacing_between_sections : (UIEdgeInsets(^)(__kindof UICollectionView *collectionView ,
                                                                __kindof UICollectionViewLayout *layout ,
                                                                NSInteger iSection)) spacingBetweenSections {
    self.bSpacingBetweenSections = [spacingBetweenSections copy];
    return self;
}

- (instancetype) cc_did_scroll : (void (^)(__kindof UIScrollView *scrollView)) didScroll {
    self.bDidScroll = [didScroll copy];
    return self;
}
- (instancetype) cc_will_begin_decelerating : (void (^)(__kindof UIScrollView *scrollView)) willBeginDecelerating {
    self.bWillBeginDecelerating = [willBeginDecelerating copy];
    return self;
}
- (instancetype) cc_did_end_decelerating : (void (^)(__kindof UIScrollView *scrollView)) didEndDecelerating {
    self.bDidEndDecelerating = [didEndDecelerating copy];
    return self;
}
- (instancetype) cc_should_scroll_to_top : (BOOL (^)(__kindof UIScrollView *scrollView)) shouldScrollToTop {
    self.bShouldScrollToTop = [shouldScrollToTop copy];
    return self;
}
- (instancetype) cc_did_scroll_to_top : (void (^)(__kindof UIScrollView *scrollView)) didScrollToTop {
    self.bDidScrollToTop = [didScrollToTop copy];
    return self;
}
- (instancetype) cc_will_begin_dragging : (void (^)(__kindof UIScrollView *scrollView)) willBeginDragging {
    self.bWillBeginDragging = [willBeginDragging copy];
    return self;
}
- (instancetype) cc_did_end_dragging : (void (^)(__kindof UIScrollView *scrollView , BOOL decelerate)) didEndDragging {
    self.bDidEndDragging = [didEndDragging copy];
    return self;
}

#pragma mark - ----

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.bDidSelect) {
        if (self.bDidSelect(collectionView , indexPath)) {
            [collectionView deselectItemAtIndexPath:indexPath animated:false];
        }
    }
}
- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.bDidHightedCell) self.bDidHightedCell(collectionView, indexPath);
}
- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.bDidUnhigntedCell) self.bDidUnhigntedCell(collectionView, indexPath);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return self.bMinimumLineSpacingInSection ? self.bMinimumLineSpacingInSection(collectionView , collectionViewLayout , section) : .0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return self.bMinimumInteritemSpacingInSection ? self.bMinimumInteritemSpacingInSection (collectionView , collectionViewLayout , section) : .0f;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return self.bSpacingBetweenSections ? self.bSpacingBetweenSections(collectionView , collectionViewLayout , section) : UIEdgeInsetsZero ;
}

#pragma mark - ----- UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.bDidScroll) self.bDidScroll(scrollView);
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if (self.bWillBeginDecelerating) self.bWillBeginDecelerating(scrollView);
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.bDidEndDecelerating) self.bDidEndDecelerating(scrollView);
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    if (self.bShouldScrollToTop) return self.bShouldScrollToTop(scrollView);
    return YES;
}
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    if (self.bDidScrollToTop) self.bDidScrollToTop(scrollView);
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.bWillBeginDragging) self.bWillBeginDragging(scrollView);
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.bDidEndDragging) self.bDidEndDragging(scrollView, decelerate);
}

_CC_DETECT_DEALLOC_

@end

#pragma mark - -----

@interface CCCollectionExtensionDataSource ()

@property (nonatomic , copy) NSInteger (^bSections)(__kindof UICollectionView *collectionView) ;
@property (nonatomic , copy) NSInteger (^bItemsInSections)(__kindof UICollectionView * collectionView , NSInteger integerSections) ;
@property (nonatomic , copy) NSString *(^bCellIdentifier)(__kindof UICollectionView * collectionView , NSIndexPath * indexPath) ;
@property (nonatomic , copy) UICollectionViewCell *(^bConfigCell)(__kindof UICollectionView * collectionView , UICollectionViewCell * cellConfig , NSIndexPath * indexPath);

@end

@implementation CCCollectionExtensionDataSource

- (id < UICollectionViewDataSource >) init {
    if ((self = [super init])) {
        return self;
    }
    return self;
}
- (instancetype) cc_sections : (NSInteger (^)(__kindof UICollectionView *collectionView)) sections {
    self.bSections = [sections copy];
    return self;
}
- (instancetype) cc_items_in_sections : (NSInteger (^)(__kindof UICollectionView * collectionView ,
                                                    NSInteger iSections)) itemInSections {
    self.bItemsInSections = [itemInSections copy];
    return self;
}
- (instancetype) cc_cell_identifier : (NSString *(^)(__kindof UICollectionView * collectionView ,
                                                   NSIndexPath * indexPath)) identifier {
    self.bCellIdentifier = [identifier copy];
    return self;
}
- (instancetype) cc_configuration : (__kindof UICollectionViewCell *(^)(__kindof UICollectionView * collectionView ,
                                                                       __kindof UICollectionViewCell * cell ,
                                                                       NSIndexPath * indexPath)) configuration {
    self.bConfigCell = [configuration copy];
    return self;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.bSections ? self.bSections(collectionView) : 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.bItemsInSections ? self.bItemsInSections(collectionView , section) : 0;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *stringCellIdentifier = self.bCellIdentifier ? self.bCellIdentifier(collectionView , indexPath) : _CC_COLLECTION_VIEW_HOLDER_ITEM_IDENTIFIER_;
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:stringCellIdentifier
                                                                           forIndexPath:indexPath];
    if (!cell) cell = [[UICollectionViewCell alloc] init];
    return self.bConfigCell ? self.bConfigCell(collectionView , cell , indexPath) : cell;
}

_CC_DETECT_DEALLOC_

@end

#pragma mark - -----

@implementation NSArray (CCExtension_Collection_Refresh)

- (instancetype) cc_reload : (UICollectionView *) collectionView {
    if (self.count) [collectionView cc_reloading:YES];
    else [collectionView reloadData];
    return self;
}
- (instancetype) cc_reload : (UICollectionView *) collectionView
                  sections : (NSIndexSet *) set {
    if (self.count) [collectionView cc_reload_sections:set
                                              animated:YES];
    else [collectionView cc_reload_sections:set
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
- (instancetype) cc_disable_background_mode {
    self.isDisableBackground = YES;
    return self;
}
- (instancetype) cc_prefetch_at : (void (^)(__kindof UICollectionView *collectionView ,
                                          NSArray <NSIndexPath *> *array)) fetch {
    self.prefetching = [fetch copy];
    return self;
}
- (instancetype) cc_cancel_prefetch_at : (void (^)(__kindof UICollectionView *collectionView ,
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


