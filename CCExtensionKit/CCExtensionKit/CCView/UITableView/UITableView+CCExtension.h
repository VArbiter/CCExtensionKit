//
//  UITableView+CCExtension.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/1.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (CCExtension)

/// default plain. // 默认为 plain
+ (instancetype) common : (CGRect) frame ;
+ (instancetype) common : (CGRect) frame
                  style : (UITableViewStyle) style ;

- (instancetype) cc_delegate : (id) delegate ;
- (instancetype) cc_datasource : (id) dataSource ;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
/// data source that pre-fetching // 预取的代理
- (instancetype) cc_prefetching : (id) prefetch ;
#endif

/// requires that nib name is equal to cell's idetifier . // 要求 nib 文件的名称必须和 cell 的唯一标识符相同
/// default main bundle // 默认是 main bundle
- (instancetype) cc_regist_nib : (NSString *) sNib ;
- (instancetype) cc_regist_nib : (NSString *) sNib
                        bundle : (NSBundle *) bundle ;
/// requires that class name is equal to cell's idetifier . // 要求类名必须和 cell 的唯一标识符相同
- (instancetype) cc_regist_cls : (Class) cls ;

/// default main bundle // 默认是 main bundle
- (instancetype) cc_regist_header_footer_nib : (NSString *) sNib ;
- (instancetype) cc_regist_header_footer_nib : (NSString *) sNib
                                      bundle : (NSBundle *) bundle ;
- (instancetype) cc_regist_header_footer_cls : (Class) cls ;

/// wrapper of "beginUpdates" && "endUpdates" // 对于 "beginUpdates" && "endUpdates" 的包裹
- (instancetype) cc_updating : (void (^)(void)) updating ;

/// for non-animated , only section 0 was available. // 对于无动画来说 , 仅仅是 0 分区有效
/// note : UITableViewRowAnimationNone means reloading without hidden animations . // UITableViewRowAnimationNone 意味着没有隐式动画
/// note : if animated is set to -1 , equals to reloadData. // 如果 将 animated 设置为 -1 , 效果等同于 reloadData
/// note : if reloeded muti sections , using "ccReloadSectionsT:animate:" down below // 如果要重载多个分区 , 使用下方的 "ccReloadSectionsT:animate:"
- (instancetype) cc_reloading : (UITableViewRowAnimation) animation ;
- (instancetype) cc_reload_sections : (NSIndexSet *) set
                            animate : (UITableViewRowAnimation) animation ;
- (instancetype) cc_reload_items : (NSArray <NSIndexPath *> *) array
                         animate : (UITableViewRowAnimation) animation ;

- (__kindof UITableViewCell *) cc_deq_cell : (NSString *) sIdentifier ;
/// for cell that register in tableView
- (__kindof UITableViewCell *) cc_deq_cell : (NSString *) sIdentifier
                                 indexPath : (NSIndexPath *) indexPath ;
- (__kindof UITableViewHeaderFooterView *) cc_deq_reusable_view : (NSString *) sIdentifier ;

@end

#pragma mark - -----

@interface CCTableExtensionDelegate : NSObject < UITableViewDelegate >

- (id < UITableViewDelegate > ) init ;

- (instancetype) cc_cell_height : (CGFloat (^)(__kindof UITableView * tableView , NSIndexPath *indexPath)) cellHeight ;
- (instancetype) cc_section_header_height : (CGFloat (^)(__kindof UITableView * tableView , NSInteger iSection)) sectionHeaderHeight ;
- (instancetype) cc_section_header : (UIView *(^)(__kindof UITableView *tableView , NSInteger iSection)) sectionHeader ;
- (instancetype) cc_section_footer_height : (CGFloat (^)(__kindof UITableView * tableView , NSInteger iSection)) sectionFooterHeight ;
- (instancetype) cc_section_footer : (UIView *(^)(__kindof UITableView *tableView , NSInteger iSection)) sectionFooter ;
- (instancetype) cc_did_select : (BOOL (^)(__kindof UITableView *tableView , NSIndexPath *indexPath)) didSelect;

- (instancetype) cc_did_scroll : (void (^)(__kindof UIScrollView *scrollView)) didScroll ;
- (instancetype) cc_will_begin_decelerating : (void (^)(__kindof UIScrollView *scrollView)) willBeginDecelerating;
- (instancetype) cc_did_end_decelerating : (void (^)(__kindof UIScrollView *scrollView)) didEndDecelerating;
- (instancetype) cc_should_scroll_to_top : (BOOL (^)(__kindof UIScrollView *scrollView)) shouldScrollToTop;
- (instancetype) cc_did_scroll_to_top : (void (^)(__kindof UIScrollView *scrollView)) didScrollToTop;
- (instancetype) cc_will_begin_dragging : (void (^)(__kindof UIScrollView *scrollView)) willBeginDragging;
- (instancetype) cc_did_end_dragging : (void (^)(__kindof UIScrollView *scrollView , BOOL decelerate)) didEndDragging;

@end

#pragma mark - -----

@interface CCTableExtensionDataSource : NSObject < UITableViewDataSource >

- (id < UITableViewDataSource >) init ;

- (instancetype) cc_sections : (NSInteger (^)(__kindof UITableView *tableView)) sections ;
- (instancetype) cc_rows_in_sections : (NSInteger (^)(__kindof UITableView * tableView , NSInteger iSection)) rowsInSections ;
- (instancetype) cc_cell_identifier : (NSString *(^)(__kindof UITableView *tableView , NSIndexPath *indexPath)) cellIdentifier ;
- (instancetype) cc_configuration : (__kindof UITableViewCell *(^)(__kindof UITableView *tableView , __kindof UITableViewCell *cell , NSIndexPath *indexPath)) configuration ;

@end

#pragma mark - -----

/// instructions && notes are the same with 'NSArray+CCExtension_Collection_Refresh' in 'UICollectionView+CCExtension'
// 说明详见 'UICollectionView+CCExtension' 文件中的 'NSArray+CCExtension_Collection_Refresh' , 因为是相同的

@interface NSArray (CCExtension_Table_Refresh)

- (instancetype) cc_reload : (__kindof UITableView *) tableView ;
- (instancetype) cc_reload : (__kindof UITableView *) tableView
                  sections : (NSIndexSet *) set ;

@end

#pragma mark - -----

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0

/// instructions && notes are the same with 'CCCollectionExtensionDataPrefetching' in 'UICollectionView+CCExtension'
// 说明详见 'UICollectionView+CCExtension' 文件中的 'CCCollectionExtensionDataPrefetching'  , 因为是相同的

@interface CCTableExtensionDataPrefetching : NSObject < UITableViewDataSourcePrefetching >

/// auto enable prefetch in background thread // 已在后台线程启用
- (id < UITableViewDataSourcePrefetching >) init ;

- (instancetype) cc_disable_background_mode ;
- (instancetype) cc_prefetch_at : (void (^)(__kindof UITableView *tableView , NSArray <NSIndexPath *> *array)) prefetchAt ;
- (instancetype) cc_cancel_prefetch_at : (void (^)(__kindof UITableView *tableView , NSArray <NSIndexPath *> *array)) cancelPrefetchAt;

@end

#endif
