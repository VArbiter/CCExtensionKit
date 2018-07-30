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
- (instancetype) mq_datasource : (id) dataSource ;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
/// data source that pre-fetching // 预取的代理
- (instancetype) mq_prefetching : (id) prefetch ;
#endif

/// requires that nib name is equal to cell's idetifier . // 要求 nib 文件的名称必须和 cell 的唯一标识符相同
/// default main bundle // 默认是 main bundle
- (instancetype) mq_regist_nib : (NSString *) sNib ;
- (instancetype) mq_regist_nib : (NSString *) sNib
                        bundle : (NSBundle *) bundle ;
/// requires that class name is equal to cell's idetifier . // 要求类名必须和 cell 的唯一标识符相同
- (instancetype) mq_regist_cls : (Class) cls ;

/// default main bundle // 默认是 main bundle
- (instancetype) mq_regist_header_footer_nib : (NSString *) sNib ;
- (instancetype) mq_regist_header_footer_nib : (NSString *) sNib
                                      bundle : (NSBundle *) bundle ;
- (instancetype) mq_regist_header_footer_cls : (Class) cls ;

/// wrapper of "beginUpdates" && "endUpdates" // 对于 "beginUpdates" && "endUpdates" 的包裹
- (instancetype) mq_updating : (void (^)(void)) updating ;

/// for non-animated , only section 0 was available. // 对于无动画来说 , 仅仅是 0 分区有效
/// note : UITableViewRowAnimationNone means reloading without hidden animations . // UITableViewRowAnimationNone 意味着没有隐式动画
/// note : if animated is set to -1 , equals to reloadData. // 如果 将 animated 设置为 -1 , 效果等同于 reloadData
/// note : if reloeded muti sections , using "ccReloadSectionsT:animate:" down below // 如果要重载多个分区 , 使用下方的 "ccReloadSectionsT:animate:"
- (instancetype) mq_reloading : (UITableViewRowAnimation) animation ;
- (instancetype) mq_reload_sections : (NSIndexSet *) set
                            animate : (UITableViewRowAnimation) animation ;
- (instancetype) mq_reload_items : (NSArray <NSIndexPath *> *) array
                         animate : (UITableViewRowAnimation) animation ;

- (__kindof UITableViewCell *) mq_deq_cell : (NSString *) sIdentifier ;
/// for cell that register in tableView
- (__kindof UITableViewCell *) mq_deq_cell : (NSString *) sIdentifier
                                 indexPath : (NSIndexPath *) indexPath ;
- (__kindof UITableViewHeaderFooterView *) mq_deq_reusable_view : (NSString *) sIdentifier ;

@end

#pragma mark - -----

@interface MQTableExtensionDelegate : NSObject < UITableViewDelegate >

- (id < UITableViewDelegate > ) init ;

- (instancetype) mq_cell_height : (CGFloat (^)(__kindof UITableView * tableView , NSIndexPath *indexPath)) cellHeight ;
- (instancetype) mq_section_header_height : (CGFloat (^)(__kindof UITableView * tableView , NSInteger iSection)) sectionHeaderHeight ;
- (instancetype) mq_section_header : (UIView *(^)(__kindof UITableView *tableView , NSInteger iSection)) sectionHeader ;
- (instancetype) mq_section_footer_height : (CGFloat (^)(__kindof UITableView * tableView , NSInteger iSection)) sectionFooterHeight ;
- (instancetype) mq_section_footer : (UIView *(^)(__kindof UITableView *tableView , NSInteger iSection)) sectionFooter ;
- (instancetype) mq_did_select : (BOOL (^)(__kindof UITableView *tableView , NSIndexPath *indexPath)) didSelect;

- (instancetype) mq_did_scroll : (void (^)(__kindof UIScrollView *scrollView)) didScroll ;
- (instancetype) mq_will_begin_decelerating : (void (^)(__kindof UIScrollView *scrollView)) willBeginDecelerating;
- (instancetype) mq_did_end_decelerating : (void (^)(__kindof UIScrollView *scrollView)) didEndDecelerating;
- (instancetype) mq_should_scroll_to_top : (BOOL (^)(__kindof UIScrollView *scrollView)) shouldScrollToTop;
- (instancetype) mq_did_scroll_to_top : (void (^)(__kindof UIScrollView *scrollView)) didScrollToTop;
- (instancetype) mq_will_begin_dragging : (void (^)(__kindof UIScrollView *scrollView)) willBeginDragging;
- (instancetype) mq_did_end_dragging : (void (^)(__kindof UIScrollView *scrollView , BOOL decelerate)) didEndDragging;

@end

#pragma mark - -----

@interface MQTableExtensionDataSource : NSObject < UITableViewDataSource >

- (id < UITableViewDataSource >) init ;

- (instancetype) mq_sections : (NSInteger (^)(__kindof UITableView *tableView)) sections ;
- (instancetype) mq_rows_in_sections : (NSInteger (^)(__kindof UITableView * tableView , NSInteger iSection)) rowsInSections ;
- (instancetype) mq_cell_identifier : (NSString *(^)(__kindof UITableView *tableView , NSIndexPath *indexPath)) cellIdentifier ;
- (instancetype) mq_configuration : (__kindof UITableViewCell *(^)(__kindof UITableView *tableView , __kindof UITableViewCell *cell , NSIndexPath *indexPath)) configuration ;

@end

#pragma mark - -----

/// instructions && notes are the same with 'NSArray+MQExtension_Collection_Refresh' in 'UICollectionView+MQExtension'
// 说明详见 'UICollectionView+MQExtension' 文件中的 'NSArray+MQExtension_Collection_Refresh' , 因为是相同的

@interface NSArray (MQExtension_Table_Refresh)

- (instancetype) mq_reload : (__kindof UITableView *) tableView ;
- (instancetype) mq_reload : (__kindof UITableView *) tableView
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
- (instancetype) mq_prefetch_at : (void (^)(__kindof UITableView *tableView , NSArray <NSIndexPath *> *array)) prefetchAt ;
- (instancetype) mq_cancel_prefetch_at : (void (^)(__kindof UITableView *tableView , NSArray <NSIndexPath *> *array)) cancelPrefetchAt;

@end

#endif
