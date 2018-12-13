//
//  UITableView+MQExtension.m
//  MQExtensionKit
//
//  Created by 冯明庆 on 2017/4/1.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "UITableView+MQExtension.h"

#ifndef _MQ_TABLE_VIEW_HOLDER_CELL_IDENTIFIER_
    #define _MQ_TABLE_VIEW_HOLDER_CELL_IDENTIFIER_ @"MQ_TABLE_VIEW_HOLDER_CELL_IDENTIFIER"
#endif

@implementation UITableView (MQExtension)

+ (instancetype) mq_common : (CGRect) frame {
    return [self mq_common:frame style:UITableViewStylePlain];
}
+ (instancetype) mq_common : (CGRect) frame
                     style : (UITableViewStyle) style {
    UITableView *v  = [[UITableView alloc] initWithFrame:frame
                                                   style:style];
    v.showsVerticalScrollIndicator = false;
    v.showsHorizontalScrollIndicator = false;
    v.separatorStyle = UITableViewCellSeparatorStyleNone;
    v.backgroundColor = UIColor.clearColor;
    v.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [v registerClass:UITableViewCell.class
forCellReuseIdentifier:_MQ_TABLE_VIEW_HOLDER_CELL_IDENTIFIER_];
    
    // for shaking problem under iOS 11 . rewrite them when needed .
    if (@available(iOS 11.0, *)) {
        v.estimatedRowHeight = 0;
        v.estimatedSectionHeaderHeight = 0;
        v.estimatedSectionFooterHeight = 0;
    }
    
    return v;
}

- (instancetype) mq_delegate : (id) delegate {
    self.delegate = delegate;
    return self;
}
- (instancetype) mq_datasource : (id) data_source {
    self.dataSource = data_source;
    return self;
}
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
- (instancetype) mq_prefetching : (id) prefetch {
    if (UIDevice.currentDevice.systemVersion.floatValue >= 10.f) {
        if (@available(iOS 10.0, *)) {
            self.prefetchDataSource = prefetch;
        } else {
            // Fallback on earlier versions
        }
    }
    return self;
}
#endif

- (instancetype) cc_scroll_to_bottom : (BOOL) animation {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSInteger row = [self numberOfRowsInSection:0] - 1;
        if (row > 0) {
            NSIndexPath *index_path = [NSIndexPath indexPathForRow:row inSection:0];
            [self scrollToRowAtIndexPath:index_path
                        atScrollPosition:UITableViewScrollPositionBottom
                                animated:animation];
        }
    });
    return self;
}

- (instancetype) mq_regist_nib : (NSString *) s_nib {
    return [self mq_regist_nib:s_nib bundle:nil];
}
- (instancetype) mq_regist_nib : (NSString *) s_nib
                      bundle : (NSBundle *) bundle {
    if (!bundle) bundle = NSBundle.mainBundle;
    [self registerNib:[UINib nibWithNibName:s_nib
                                      bundle:bundle]
forCellReuseIdentifier:s_nib];
    return self;
}

- (instancetype) mq_regist_cls : (Class) cls {
    [self registerClass:cls
  forCellReuseIdentifier:NSStringFromClass(cls)];
    return self;
}

- (instancetype) mq_regist_header_footer_nib : (NSString *) s_nib {
    return [self mq_regist_header_footer_nib:s_nib bundle:nil];
}
- (instancetype) mq_regist_header_footer_nib : (NSString *) s_nib
                                      bundle : (NSBundle *) bundle {
    if (NSClassFromString(s_nib) == UITableViewHeaderFooterView.class
        || [NSClassFromString(s_nib) isSubclassOfClass:UITableViewHeaderFooterView.class]) {
        if (!bundle) bundle = NSBundle.mainBundle;
        [self registerNib:[UINib nibWithNibName:s_nib
                                         bundle:bundle]
forHeaderFooterViewReuseIdentifier:s_nib];
    }
    return self;
}
- (instancetype) mq_regist_header_footer_cls : (Class) cls {
    if (cls == UITableViewHeaderFooterView.class
        || [cls isSubclassOfClass:UITableViewHeaderFooterView.class]){
        [self registerClass:cls forHeaderFooterViewReuseIdentifier:NSStringFromClass(cls)];
    }
    return self;
}

- (instancetype) mq_updating : (void (^)(void)) updating {
    if (updating) {
        [self beginUpdates];
        updating();
        [self endUpdates];
    }
    return self;
}

- (instancetype) mq_reloading : (UITableViewRowAnimation) animation {
    if ((NSInteger)animation > 0 && animation != UITableViewRowAnimationNone) {
        return [self mq_reload_sections:[NSIndexSet indexSetWithIndex:0]
                                animate:animation];
    }
    else [self reloadData];
    return self;
}
- (instancetype) mq_reload_sections : (NSIndexSet *) set
                            animate : (UITableViewRowAnimation) animation {
    if (!set) return self;
    if ((NSInteger)animation > 0 && animation != UITableViewRowAnimationNone) {
        [self reloadSections:set
            withRowAnimation:animation];
    } else {
        
        void (^t)(void (^)(void)) = ^(void (^e)(void)) {
            if (e) {
                [UIView setAnimationsEnabled:false];
                e();
                [UIView setAnimationsEnabled:YES];
            }
        };
        
        __weak typeof(self) weak_self = self;
        if ((NSInteger)animation == -2) {
            t(^{
                [weak_self reloadSections:set
                     withRowAnimation:UITableViewRowAnimationNone];
            });
        } else [self reloadSections:set
                   withRowAnimation:UITableViewRowAnimationNone];
    }
    return self;
}
- (instancetype) mq_reload_items : (NSArray <NSIndexPath *> *) array
                         animate : (UITableViewRowAnimation) animation {
    if (array && array.count) {
        if ((NSInteger)animation > 0 && animation != UITableViewRowAnimationNone) {
            [self reloadRowsAtIndexPaths:array
                        withRowAnimation:animation];
        } else {
            
            void (^t)(void (^)(void)) = ^(void (^e)(void)) {
                if (e) {
                    [UIView setAnimationsEnabled:false];
                    e();
                    [UIView setAnimationsEnabled:YES];
                }
            };
            __weak typeof(self) weak_self = self;
            if ((NSInteger)animation == -2) {
                t(^{
                    [weak_self reloadRowsAtIndexPaths:array
                                 withRowAnimation:UITableViewRowAnimationNone];
                });
            } else [self reloadRowsAtIndexPaths:array
                               withRowAnimation:UITableViewRowAnimationNone];
        }
    }
    else [self reloadData];
    return self;
}

- (__kindof UITableViewCell *) mq_deq_cell : (NSString *) s_identifier {
    return [self dequeueReusableCellWithIdentifier:s_identifier];
}

- (__kindof UITableViewCell *) mq_deq_cell : (NSString *) s_identifier
                                 indexPath : (NSIndexPath *) index_path {
    return [self dequeueReusableCellWithIdentifier:s_identifier
                                      forIndexPath:index_path];
}
- (__kindof UITableViewHeaderFooterView *) mq_deq_reusable_view : (NSString *) s_identifier {
    return [self dequeueReusableHeaderFooterViewWithIdentifier:s_identifier];
}

@end

#pragma mark - -----

@interface MQTableExtensionDelegate ()

@property (nonatomic , copy) CGFloat (^block_cell_height)(__kindof UITableView * , NSIndexPath *) ;
@property (nonatomic , copy) CGFloat (^block_section_header_height)(__kindof UITableView * , NSInteger) ;
@property (nonatomic , copy) UIView *(^block_section_header)(__kindof UITableView * , NSInteger) ;
@property (nonatomic , copy) CGFloat (^block_section_footer_height)(__kindof UITableView * , NSInteger) ;
@property (nonatomic , copy) UIView *(^block_section_footer)(__kindof UITableView * , NSInteger) ;
@property (nonatomic , copy) BOOL (^block_did_select)(__kindof UITableView * , NSIndexPath *) ;

@property (nonatomic , copy) void (^block_did_scroll)(__kindof UIScrollView *);
@property (nonatomic , copy) void (^block_will_begin_decelerating)(__kindof UIScrollView *);
@property (nonatomic , copy) void (^block_did_end_decelerating)(__kindof UIScrollView *);
@property (nonatomic , copy) BOOL (^block_should_scroll_to_top)(__kindof UIScrollView *);
@property (nonatomic , copy) void (^block_did_scroll_to_top)(__kindof UIScrollView *);
@property (nonatomic , copy) void (^block_will_begin_dragging)(__kindof UIScrollView *);
@property (nonatomic , copy) void (^block_did_end_dragging)(__kindof UIScrollView * , BOOL );

@end

@implementation MQTableExtensionDelegate

- (id < UITableViewDelegate >) init {
    if ((self = [super init])) {
        return self;
    }
    return self;
}

- (instancetype) mq_cell_height : (CGFloat (^)(__kindof UITableView * table_view , NSIndexPath *index_path)) cell_height {
    self.block_cell_height = [cell_height copy];
    return self;
}
- (instancetype) mq_section_header_height : (CGFloat (^)(__kindof UITableView * table_view , NSInteger i_section)) section_header_height {
    self.block_section_header_height = [section_header_height copy];
    return self;
}
- (instancetype) mq_section_header : (UIView *(^)(__kindof UITableView *table_view , NSInteger i_section)) section_header {
    self.block_section_header = [section_header copy];
    return self;
}
- (instancetype) mq_section_footer_height : (CGFloat (^)(__kindof UITableView * table_view , NSInteger i_section)) section_footer_height {
    self.block_section_footer_height = [section_footer_height copy];
    return self;
}
- (instancetype) mq_section_footer : (UIView *(^)(__kindof UITableView *table_view , NSInteger i_section)) section_footer {
    self.block_section_footer = [section_footer copy];
    return self;
}
- (instancetype) mq_did_select : (BOOL (^)(__kindof UITableView *table_view , NSIndexPath *index_path)) did_select {
    self.block_did_select = [did_select copy];
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

#pragma mark - ---

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.block_cell_height ? self.block_cell_height(tableView , indexPath) : 45.f ;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.block_section_header_height ? self.block_section_header_height(tableView , section) : .0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return self.block_section_footer_height ? self.block_section_footer_height(tableView , section) : .01f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.block_section_header ? self.block_section_header(tableView , section) : nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return self.block_section_footer ? self.block_section_footer(tableView , section) : nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.block_did_select) {
        if (self.block_did_select(tableView , indexPath)) {
            [tableView deselectRowAtIndexPath:indexPath animated:false];
        }
    }
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

@interface MQTableExtensionDataSource ()

@property (nonatomic , copy) NSInteger (^block_sections)(__kindof UITableView *);
@property (nonatomic , copy) NSInteger (^block_rows_in_sections)(__kindof UITableView * , NSInteger);
@property (nonatomic , copy) NSString * (^block_cell_identifier)(__kindof UITableView * , NSIndexPath *) ;
@property (nonatomic , copy) UITableViewCell * (^block_config_cell)(__kindof UITableView * , UITableViewCell * , NSIndexPath *) ;

@end

@implementation MQTableExtensionDataSource

- (id < UITableViewDataSource >) init {
    if ((self = [super init])) {
        return self;
    }
    return self;
}

- (instancetype) mq_sections : (NSInteger (^)(__kindof UITableView *table_view)) sections {
    self.block_sections = [sections copy];
    return self;
}
- (instancetype) mq_rows_in_sections : (NSInteger (^)(__kindof UITableView * table_view , NSInteger i_section)) rows_in_sections {
    self.block_rows_in_sections = [rows_in_sections copy];
    return self;
}
- (instancetype) mq_cell_identifier : (NSString *(^)(__kindof UITableView *table_view , NSIndexPath *index_path)) cell_identifier {
    self.block_cell_identifier = [cell_identifier copy];
    return self;
}
- (instancetype) mq_configuration : (__kindof UITableViewCell *(^)(__kindof UITableView *table_view , __kindof UITableViewCell *cell , NSIndexPath *index_path)) configuration {
    self.block_config_cell = [configuration copy];
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.block_sections ? self.block_sections(tableView) : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.block_rows_in_sections ? self.block_rows_in_sections(tableView , section) : 0 ;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *s_identifer = self.block_cell_identifier ? self.block_cell_identifier(tableView , indexPath) : _MQ_TABLE_VIEW_HOLDER_CELL_IDENTIFIER_;
    
    UITableViewCell *cell = nil;
    if (self.block_cell_identifier) cell = [tableView dequeueReusableCellWithIdentifier:s_identifer
                                                                         forIndexPath:indexPath];
    else cell = [tableView dequeueReusableCellWithIdentifier:s_identifer];
    if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                             reuseIdentifier:s_identifer];
    return self.block_config_cell ? self.block_config_cell(tableView , cell , indexPath) : cell;
}

- (void)dealloc {
#if DEBUG
    NSLog(@"_MQ_%@_DEALLOC_" , NSStringFromClass(self.class));
#endif
}

@end

#pragma mark - -----

@implementation NSArray (MQExtension_Table_Refresh)

- (instancetype) mq_reload : (__kindof UITableView *) table_view {
    if (self.count) [table_view mq_reloading:UITableViewRowAnimationFade];
    else [table_view reloadData];
    return self;
}
- (instancetype) mq_reload : (__kindof UITableView *) table_view
                  sections : (NSIndexSet *) set {
    if (self.count) [table_view mq_reload_sections:set animate:UITableViewRowAnimationFade];
    else [table_view mq_reload_sections:set animate:UITableViewRowAnimationNone];
    return self;
}

@end

#pragma mark - -----

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0

@interface MQTableExtensionDataPrefetching ()

@property (nonatomic , assign) BOOL is_disable_background ;
@property (nonatomic , copy) void (^prefetching)(__kindof UITableView *, NSArray<NSIndexPath *> *);
@property (nonatomic , copy) void (^canceling)(__kindof UITableView *, NSArray<NSIndexPath *> *);

@property (nonatomic) dispatch_queue_t queue ;

@end

@implementation MQTableExtensionDataPrefetching

- (id < UITableViewDataSourcePrefetching >) init {
    if ((self = [super init])) {
        
    }
    return self;
}

- (instancetype) mq_disable_background_mode {
    self.is_disable_background = YES;
    return self;
}
- (instancetype) mq_prefetch_at : (void (^)(__kindof UITableView *table_view , NSArray <NSIndexPath *> *array)) prefetch_at {
    self.prefetching = [prefetch_at copy];
    return self;
}
- (instancetype) mq_cancel_prefetch_at : (void (^)(__kindof UITableView *table_view , NSArray <NSIndexPath *> *array)) cancel_prefetch_at {
    self.canceling = [cancel_prefetch_at copy];
    return self;
}

- (void)tableView:(UITableView *)tableView prefetchRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    if (!self.queue && !self.is_disable_background) {
        if (UIDevice.currentDevice.systemVersion.floatValue >= 8.f) {
            self.queue = dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0);
        }
        else self.queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    }
    
    if (!self.is_disable_background) {
        __weak typeof(self) weak_self = self;
        dispatch_async(self.queue, ^{
            if (weak_self.prefetching) weak_self.prefetching(tableView, indexPaths);
        });
    }
    else if (self.prefetching) self.prefetching(tableView, indexPaths);
}
- (void)tableView:(UITableView *)tableView cancelPrefetchingForRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    if (self.canceling) self.canceling(tableView, indexPaths);
}

- (void)dealloc {
#if DEBUG
    NSLog(@"_MQ_%@_DEALLOC_" , NSStringFromClass(self.class));
#endif
}

@end

#endif

