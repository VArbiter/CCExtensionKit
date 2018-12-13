//
//  UICollectionView+MQExtension.m
//  MQExtensionKit
//
//  Created by 冯明庆 on 2017/4/1.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "UICollectionView+MQExtension.h"
#import <objc/runtime.h>

#ifndef _MQ_COLLECTION_VIEW_HOLDER_ITEM_IDENTIFIER_
    #define _MQ_COLLECTION_VIEW_HOLDER_ITEM_IDENTIFIER_ @"MQ_COLLECTION_VIEW_HOLDER_ITEM_IDENTIFIER"
#endif

@implementation UICollectionView (MQExtension)

+ (instancetype) mq_common : (CGRect) frame
                    layout : (UICollectionViewFlowLayout *) layout {
    UICollectionView *c = [[UICollectionView alloc] initWithFrame:frame
                                             collectionViewLayout:layout];
    c.backgroundColor = UIColor.clearColor;
    c.showsVerticalScrollIndicator = false;
    c.showsHorizontalScrollIndicator = false;
    c.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    if (@available(iOS 10.0, *)) {
        c.prefetchingEnabled = YES;
    }
    
    [c registerClass:UICollectionViewCell.class
forCellWithReuseIdentifier:_MQ_COLLECTION_VIEW_HOLDER_ITEM_IDENTIFIER_];
    return c;
}
- (instancetype) mq_delegate : (id <UICollectionViewDelegateFlowLayout>) delegate {
    if (delegate) self.delegate = delegate;
    else self.delegate = nil;
    return self;
}
- (instancetype) mq_datasource : (id <UICollectionViewDataSource>) data_source {
    if (data_source) self.dataSource = data_source;
    else self.dataSource = nil;
    return self;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
- (instancetype) mq_prefetching : (id <UICollectionViewDataSourcePrefetching>) prefetch {
    if (prefetch) {
        if (@available(iOS 10.0, *)) {
            self.prefetchDataSource = prefetch;
        }
    }
    return self;
}
#endif

- (instancetype) mq_regist_nib : (NSString *) s_nib {
    return [self mq_regist_nib:s_nib bundle:nil];
}
- (instancetype) mq_regist_nib : (NSString *) s_nib
                        bundle : (NSBundle *) bundle {
    if (!bundle) bundle = NSBundle.mainBundle;
    [self registerNib:[UINib nibWithNibName:s_nib
                                     bundle:bundle]
forCellWithReuseIdentifier:s_nib];
    return self;
}

- (instancetype) mq_regist_cls : (Class) cls {
    [self registerClass:cls
forCellWithReuseIdentifier:NSStringFromClass(cls)];
    return self;
}

- (instancetype) mq_reloading : (BOOL) is_animated {
    if (is_animated) {
        [self mq_reload_sections:[NSIndexSet indexSetWithIndex:0]
                        animated:is_animated];
    } else [self reloadData];
    return self;
}
- (instancetype) mq_reload_sections : (NSIndexSet *) set
                           animated : (BOOL) is_animated {
    if (is_animated) {
        [self reloadSections:set];
    } else {
        __weak typeof(self) weak_self = self;
        void (^t)(void) = ^ {
            [UIView setAnimationsEnabled:false];
            [self performBatchUpdates:^{
                __strong typeof(weak_self) strong_self = weak_self;
                [strong_self reloadSections:set];
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
- (instancetype) mq_reload_items : (NSArray <NSIndexPath *> *) array_items {
    [self reloadItemsAtIndexPaths:(array_items ? array_items : @[])];
    return self;
}

/// for cell that register in collection
- (__kindof UICollectionViewCell *) mq_deq_cell : (NSString *) s_identifier
                                      indexPath : (NSIndexPath *) index_path {
    if (s_identifier && s_identifier.length && index_path)
        return [self dequeueReusableCellWithReuseIdentifier:s_identifier
                                               forIndexPath:index_path];
    return nil;
}
/// for reusable view
- (__kindof UICollectionReusableView *) mq_deq_reuseable_view : (NSString *) s_element_kind
                                                   identifier : (NSString *) s_identifier
                                                    indexPath : (NSIndexPath *) indexPath {
    if (s_element_kind && s_element_kind.length && s_identifier && s_identifier.length && indexPath)
        return [self dequeueReusableSupplementaryViewOfKind:s_element_kind
                                        withReuseIdentifier:s_identifier
                                               forIndexPath:indexPath];
    return nil;
}

@end

#pragma mark - UICollectionViewFlowLayout --------------------------------------

@implementation UICollectionViewFlowLayout (MQExtension)

+ (instancetype) common {
    return UICollectionViewFlowLayout.alloc.init;
}

/// for default sizes
- (instancetype) mq_item_size : (CGSize) size {
    self.itemSize = size;
    return self;
}
- (instancetype) mq_sections_insets : (UIEdgeInsets) insets {
    self.sectionInset = insets;
    return self;
}
- (instancetype) mq_header_size : (CGSize) size {
    self.headerReferenceSize = size;
    return self;
}

@end

#pragma mark - -----

#import "MQCommon.h"

@interface MQCollectionExtensionDelegate ()

@property (nonatomic , copy) BOOL (^block_did_select)(__kindof UICollectionView * , NSIndexPath *) ;
@property (nonatomic , copy) void (^block_did_highted_cell)(__kindof UICollectionView * , NSIndexPath *) ;
@property (nonatomic , copy) void (^block_did_unhignted_cell)(__kindof UICollectionView * , NSIndexPath *) ;
@property (nonatomic , copy) CGFloat (^block_minimum_line_spacing_in_section)(__kindof UICollectionView * ,__kindof  UICollectionViewLayout * , NSInteger ) ;
@property (nonatomic , copy) CGFloat (^block_minimum_inter_item_spacing_in_section)(__kindof UICollectionView * ,__kindof  UICollectionViewLayout * , NSInteger ) ;
@property (nonatomic , copy) UIEdgeInsets (^block_spacing_between_sections)(__kindof UICollectionView * ,__kindof  UICollectionViewLayout * , NSInteger ) ;

@property (nonatomic , copy) void (^block_did_scroll)(__kindof UIScrollView *);
@property (nonatomic , copy) void (^block_will_begin_decelerating)(__kindof UIScrollView *);
@property (nonatomic , copy) void (^block_did_end_decelerating)(__kindof UIScrollView *);
@property (nonatomic , copy) BOOL (^block_should_scroll_to_top)(__kindof UIScrollView *);
@property (nonatomic , copy) void (^block_did_scroll_to_top)(__kindof UIScrollView *);
@property (nonatomic , copy) void (^block_will_begin_dragging)(__kindof UIScrollView *);
@property (nonatomic , copy) void (^block_did_end_dragging)(__kindof UIScrollView * , BOOL );

@end

@implementation MQCollectionExtensionDelegate

- (id < UICollectionViewDelegateFlowLayout > ) init {
    if (self = [super init]) {
        return self;
    }
    return self;
}

- (instancetype) mq_did_select : (BOOL (^)(__kindof UICollectionView *collection_view ,
                                         NSIndexPath *index_path)) did_select {
    self.block_did_select = [did_select copy];
    return self;
}
- (instancetype) mq_did_highted : (void (^)(__kindof UICollectionView *collection_view ,
                                          NSIndexPath *index_path)) did_highlighted {
    self.block_did_highted_cell = [did_highlighted copy];
    return self;
}
- (instancetype) mq_did_un_highted : (void (^)(__kindof UICollectionView *collectionView ,
                                            NSIndexPath *indexPath)) did_Unhighlighted {
    self.block_did_unhignted_cell = [did_Unhighlighted copy];
    return self;
}
- (instancetype) mq_minimum_line_spacing_in_section : (CGFloat (^)(__kindof UICollectionView *collection_view ,
                                                                   __kindof UICollectionViewLayout *layout ,
                                                                   NSInteger i_section)) minimum_line_spacing_in_section {
    self.block_minimum_line_spacing_in_section = [minimum_line_spacing_in_section copy];
    return self;
}
- (instancetype) mq_minimum_inter_item_spacing_in_section : (CGFloat (^)(__kindof UICollectionView *collection_view ,
                                                                         __kindof UICollectionViewLayout *layout ,
                                                                         NSInteger i_section)) minimum_inter_item_spacing_in_section {
    self.block_minimum_inter_item_spacing_in_section = [minimum_inter_item_spacing_in_section copy];
    return self;
}
- (instancetype) mq_spacing_between_sections : (UIEdgeInsets(^)(__kindof UICollectionView *collection_view ,
                                                                __kindof UICollectionViewLayout *layout ,
                                                                NSInteger i_section)) spacing_between_sections {
    self.block_spacing_between_sections = [spacing_between_sections copy];
    return self;
}

- (instancetype) mq_did_scroll : (void (^)(__kindof UIScrollView *scroll_view)) did_scroll {
    self.block_did_scroll = [did_scroll copy];
    return self;
}
- (instancetype) mq_will_begin_decelerating : (void (^)(__kindof UIScrollView *scroll_view)) will_begin_decelerating {
    self.block_will_begin_decelerating = [will_begin_decelerating copy];
    return self;
}
- (instancetype) mq_did_end_decelerating : (void (^)(__kindof UIScrollView *scroll_view)) did_end_decelerating {
    self.block_did_end_decelerating = [did_end_decelerating copy];
    return self;
}
- (instancetype) mq_should_scroll_to_top : (BOOL (^)(__kindof UIScrollView *scroll_view)) should_scroll_to_top {
    self.block_should_scroll_to_top = [should_scroll_to_top copy];
    return self;
}
- (instancetype) mq_did_scroll_to_top : (void (^)(__kindof UIScrollView *scroll_view)) did_scroll_to_top {
    self.block_did_scroll_to_top = [did_scroll_to_top copy];
    return self;
}
- (instancetype) mq_will_begin_dragging : (void (^)(__kindof UIScrollView *scroll_view)) will_begin_dragging {
    self.block_will_begin_dragging = [will_begin_dragging copy];
    return self;
}
- (instancetype) mq_did_end_dragging : (void (^)(__kindof UIScrollView *scroll_view , BOOL decelerate)) did_end_dragging {
    self.block_did_end_dragging = [did_end_dragging copy];
    return self;
}

#pragma mark - ----

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.block_did_select) {
        if (self.block_did_select(collectionView , indexPath)) {
            [collectionView deselectItemAtIndexPath:indexPath animated:false];
        }
    }
}
- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.block_did_highted_cell) self.block_did_highted_cell(collectionView, indexPath);
}
- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.block_did_unhignted_cell) self.block_did_unhignted_cell(collectionView, indexPath);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return self.block_minimum_line_spacing_in_section ? self.block_minimum_line_spacing_in_section(collectionView , collectionViewLayout , section) : .0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return self.block_minimum_inter_item_spacing_in_section ? self.block_minimum_inter_item_spacing_in_section(collectionView , collectionViewLayout , section) : .0f;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return self.block_spacing_between_sections ? self.block_spacing_between_sections(collectionView , collectionViewLayout , section) : UIEdgeInsetsZero ;
}

#pragma mark - ----- UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.block_did_scroll) self.block_did_scroll(scrollView);
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if (self.block_will_begin_decelerating) self.block_will_begin_decelerating(scrollView);
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.block_did_end_decelerating) self.block_did_end_decelerating(scrollView);
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    if (self.block_should_scroll_to_top) return self.block_should_scroll_to_top(scrollView);
    return YES;
}
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    if (self.block_did_scroll_to_top) self.block_did_scroll_to_top(scrollView);
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.block_will_begin_dragging) self.block_will_begin_dragging(scrollView);
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.block_did_end_dragging) self.block_did_end_dragging(scrollView, decelerate);
}

#if DEBUG
- (void)dealloc {
    NSLog(@"MQ_%@_DEALLOC" , NSStringFromClass(self.class));
}
#endif

@end

#pragma mark - -----

@interface MQCollectionExtensionDataSource ()

@property (nonatomic , copy) NSInteger (^block_sections)(__kindof UICollectionView *) ;
@property (nonatomic , copy) NSInteger (^block_items_in_sections)(__kindof UICollectionView *  , NSInteger ) ;
@property (nonatomic , copy) NSString *(^block_cell_identifier)(__kindof UICollectionView *  , NSIndexPath * ) ;
@property (nonatomic , copy) UICollectionViewCell *(^block_config_cell)(__kindof UICollectionView *  , UICollectionViewCell * , NSIndexPath * );

@end

@implementation MQCollectionExtensionDataSource

- (id < UICollectionViewDataSource >) init {
    if ((self = [super init])) {
        return self;
    }
    return self;
}
- (instancetype) mq_sections : (NSInteger (^)(__kindof UICollectionView *collectionView)) sections {
    self.block_sections = [sections copy];
    return self;
}
- (instancetype) mq_items_in_sections : (NSInteger (^)(__kindof UICollectionView * collectionView ,
                                                    NSInteger iSections)) item_in_sections {
    self.block_items_in_sections = [item_in_sections copy];
    return self;
}
- (instancetype) mq_cell_identifier : (NSString *(^)(__kindof UICollectionView * collectionView ,
                                                   NSIndexPath * indexPath)) identifier {
    self.block_cell_identifier = [identifier copy];
    return self;
}
- (instancetype) mq_configuration : (__kindof UICollectionViewCell *(^)(__kindof UICollectionView * collectionView ,
                                                                       __kindof UICollectionViewCell * cell ,
                                                                       NSIndexPath * indexPath)) configuration {
    self.block_config_cell = [configuration copy];
    return self;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.block_sections ? self.block_sections(collectionView) : 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.block_items_in_sections ? self.block_items_in_sections(collectionView , section) : 0;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *s_identifier = self.block_cell_identifier ? self.block_cell_identifier(collectionView , indexPath) : _MQ_COLLECTION_VIEW_HOLDER_ITEM_IDENTIFIER_;
    UICollectionViewCell *cell = [collectionView
                                  dequeueReusableCellWithReuseIdentifier:s_identifier
                                  forIndexPath:indexPath];
    if (!cell) cell = [[UICollectionViewCell alloc] init];
    return self.block_config_cell ? self.block_config_cell(collectionView , cell , indexPath) : cell;
}

#if DEBUG
- (void)dealloc {
    NSLog(@"MQ_%@_DEALLOC" , NSStringFromClass(self.class));
}
#endif

@end

#pragma mark - -----

@implementation NSArray (MQExtension_Collection_Refresh)

- (instancetype) mq_reload : (UICollectionView *) collectionView {
    if (self.count) [collectionView mq_reloading:YES];
    else [collectionView reloadData];
    return self;
}
- (instancetype) mq_reload : (UICollectionView *) collectionView
                  sections : (NSIndexSet *) set {
    if (self.count) [collectionView mq_reload_sections:set
                                              animated:YES];
    else [collectionView mq_reload_sections:set
                                   animated:false];
    return self;
}

@end

#pragma mark - -----

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0

#import <objc/runtime.h>

@interface MQCollectionExtensionDataPrefetching ()

@property (nonatomic , assign) BOOL is_disable_background ;
@property (nonatomic , copy) void (^prefetching)(__kindof UICollectionView *, NSArray<NSIndexPath *> *);
@property (nonatomic , copy) void (^canceling)(__kindof UICollectionView *, NSArray<NSIndexPath *> *);

@property (nonatomic) dispatch_queue_t queue ;

@end

@implementation MQCollectionExtensionDataPrefetching

- (id <UICollectionViewDataSourcePrefetching> ) init {
    if ((self = [super init])) {
        
    }
    return self;
}
- (instancetype) mq_disable_background_mode {
    self.is_disable_background = YES;
    return self;
}
- (instancetype) mq_prefetch_at : (void (^)(__kindof UICollectionView *collectionView ,
                                          NSArray <NSIndexPath *> *array)) fetch {
    self.prefetching = [fetch copy];
    return self;
}
- (instancetype) mq_cancel_prefetch_at : (void (^)(__kindof UICollectionView *collectionView ,
                                                NSArray <NSIndexPath *> *array)) cancel {
    self.canceling = [cancel copy];
    return self;
}

- (void)collectionView:(UICollectionView *)collectionView prefetchItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths NS_AVAILABLE_IOS(10_0) {
    if (!self.queue && !self.is_disable_background) {
        if (UIDevice.currentDevice.systemVersion.floatValue >= 8.f) {
            self.queue = dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0);
        }
        else self.queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    }
    
    if (!self.is_disable_background) {
        __weak typeof(self) weak_self = self;
        dispatch_async(self.queue, ^{
            __strong typeof(weak_self) strong_self = weak_self;
            if (strong_self.prefetching) strong_self.prefetching(collectionView, indexPaths);
        });
    }
    else if (self.prefetching) self.prefetching(collectionView, indexPaths);
}

- (void)collectionView:(UICollectionView *)collectionView cancelPrefetchingForItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths  NS_AVAILABLE_IOS(10_0) {
    if (self.canceling) self.canceling(collectionView , indexPaths);
}

@end

#endif


