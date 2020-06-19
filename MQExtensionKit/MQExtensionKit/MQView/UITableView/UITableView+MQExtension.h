//
//  UITableView+MQExtension.h
//  MQExtensionKit
//
//  Created by 冯明庆 on 2017/4/1.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (MQExtension)

/// default plain. // 默认为 plain
+ (instancetype) mq_common : (CGRect) frame ;
+ (instancetype) mq_common : (CGRect) frame
                     style : (UITableViewStyle) style ;

- (instancetype) mq_delegate : (id) delegate ;
- (instancetype) mq_datasource : (id) data_source ;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
/// data source that pre-fetching // 预取的代理
- (instancetype) mq_prefetching : (id) prefetch ;
#endif

/// an easy way to scroll it to bottom . // 一个滚动到底部的简便方法 .
- (instancetype) cc_scroll_to_bottom : (BOOL) animation ;

/// requires that nib name is equal to cell's idetifier . // 要求 nib 文件的名称必须和 cell 的唯一标识符相同
/// default main bundle // 默认是 main bundle
- (instancetype) mq_regist_nib : (NSString *) s_nib ;
- (instancetype) mq_regist_nib : (NSString *) s_nib
                        bundle : (NSBundle *) bundle ;
/// requires that class name is equal to cell's idetifier . // 要求类名必须和 cell 的唯一标识符相同
- (instancetype) mq_regist_cls : (Class) cls ;

/// default main bundle // 默认是 main bundle
- (instancetype) mq_regist_header_footer_nib : (NSString *) s_nib ;
- (instancetype) mq_regist_header_footer_nib : (NSString *) s_nib
                                      bundle : (NSBundle *) bundle ;
- (instancetype) mq_regist_header_footer_cls : (Class) cls ;

/// wrapper of "beginUpdates" && "endUpdates" // 对于 "beginUpdates" && "endUpdates" 的包裹
- (instancetype) mq_updating : (void (^)(void)) updating ;

/// for non-animated , only section 0 was available. // 对于无动画来说 , 仅仅是 0 分区有效
/// note : UITableViewRowAnimationNone means reloading without hidden animations . // UITableViewRowAnimationNone 意味着没有隐式动画
/// note : if animated is set to -1 , equals to reloadData. // 如果 将 animated 设置为 -1 , 效果等同于 reloadData
/// note : if reloeded muti sections , using "mq_reload_sections:animate:" down below // 如果要重载多个分区 , 使用下方的 "mq_reload_sections:animate:"
- (instancetype) mq_reloading : (UITableViewRowAnimation) animation ;
- (instancetype) mq_reload_sections : (NSIndexSet *) set
                            animate : (UITableViewRowAnimation) animation ;
- (instancetype) mq_reload_items : (NSArray <NSIndexPath *> *) array
                         animate : (UITableViewRowAnimation) animation ;

- (__kindof UITableViewCell *) mq_deq_cell : (NSString *) s_identifier ;
/// for cell that register in tableView
- (__kindof UITableViewCell *) mq_deq_cell : (NSString *) s_identifier
                                 indexPath : (NSIndexPath *) index_path ;
- (__kindof UITableViewHeaderFooterView *) mq_deq_reusable_view : (NSString *) s_identifier ;

@end

#pragma mark - -----

@interface MQTableExtensionDelegate : NSObject < UITableViewDelegate >

- (id < UITableViewDelegate > ) init ;

- (instancetype) mq_cell_height : (CGFloat (^)(__kindof UITableView * table_view , NSIndexPath *indexPath)) cell_height ;
- (instancetype) mq_section_header_height : (CGFloat (^)(__kindof UITableView * table_view , NSInteger i_section)) section_header_height ;
- (instancetype) mq_section_header : (UIView *(^)(__kindof UITableView *table_view , NSInteger i_section)) section_header ;
- (instancetype) mq_section_footer_height : (CGFloat (^)(__kindof UITableView * table_view , NSInteger i_section)) section_footer_height ;
- (instancetype) mq_section_footer : (UIView *(^)(__kindof UITableView *table_view , NSInteger i_section)) section_footer ;
- (instancetype) mq_did_select : (BOOL (^)(__kindof UITableView *table_view , NSIndexPath *index_path)) did_select;

- (instancetype) mq_did_scroll : (void (^)(__kindof UIScrollView *scroll_view)) did_scroll ;
- (instancetype) mq_will_begin_decelerating : (void (^)(__kindof UIScrollView *scroll_view)) will_begin_decelerating;
- (instancetype) mq_did_end_decelerating : (void (^)(__kindof UIScrollView *scroll_view)) did_end_decelerating;
- (instancetype) mq_should_scroll_to_top : (BOOL (^)(__kindof UIScrollView *scroll_view)) should_scroll_to_top;
- (instancetype) mq_did_scroll_to_top : (void (^)(__kindof UIScrollView *scroll_view)) did_scroll_to_top;
- (instancetype) mq_will_begin_dragging : (void (^)(__kindof UIScrollView *scroll_view)) will_begin_dragging;
- (instancetype) mq_did_end_dragging : (void (^)(__kindof UIScrollView *scroll_view , BOOL decelerate)) did_end_dragging;

@end

#pragma mark - -----

@interface MQTableExtensionDataSource : NSObject < UITableViewDataSource >

- (id < UITableViewDataSource >) init ;

- (instancetype) mq_sections : (NSInteger (^)(__kindof UITableView *table_view)) sections ;
- (instancetype) mq_rows_in_sections : (NSInteger (^)(__kindof UITableView * table_view , NSInteger i_section)) rows_in_sections ;
- (instancetype) mq_cell_identifier : (NSString *(^)(__kindof UITableView *table_view , NSIndexPath *index_path)) cell_identifier ;
- (instancetype) mq_configuration : (__kindof UITableViewCell *(^)(__kindof UITableView *table_view , __kindof UITableViewCell *cell , NSIndexPath *index_path)) configuration ;

@end

#pragma mark - -----

/// instructions && notes are the same with 'NSArray+MQExtension_Collection_Refresh' in 'UICollectionView+MQExtension'
// 说明详见 'UICollectionView+MQExtension' 文件中的 'NSArray+MQExtension_Collection_Refresh' , 因为是相同的

@interface NSArray (MQExtension_Table_Refresh)

- (instancetype) mq_reload_tableview : (__kindof UITableView *) table_view ;
- (instancetype) mq_reload_tableview : (__kindof UITableView *) table_view
                            sections : (NSIndexSet *) set ;

@end

#pragma mark - -----

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0

/// instructions && notes are the same with 'MQCollectionExtensionDataPrefetching' in 'UICollectionView+MQExtension'
// 说明详见 'UICollectionView+MQExtension' 文件中的 'MQCollectionExtensionDataPrefetching'  , 因为是相同的

@interface MQTableExtensionDataPrefetching : NSObject < UITableViewDataSourcePrefetching >

/// auto enable prefetch in background thread // 已在后台线程启用
- (id < UITableViewDataSourcePrefetching >) init ;

- (instancetype) mq_disable_background_mode ;
- (instancetype) mq_prefetch_at : (void (^)(__kindof UITableView *table_view , NSArray <NSIndexPath *> *array)) prefetch_at ;
- (instancetype) mq_cancel_prefetch_at : (void (^)(__kindof UITableView *table_view , NSArray <NSIndexPath *> *array)) cancel_prefetch_at;

@end

#endif
