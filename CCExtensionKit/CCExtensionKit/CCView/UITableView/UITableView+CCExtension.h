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

- (instancetype) ccDelegateT : (id) delegate ;
- (instancetype) ccDataSourceT : (id) dataSource ;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
/// data source that pre-fetching // 预取的代理
- (instancetype) ccPrefetchingT : (id) prefetch ;
#endif

/// requires that nib name is equal to cell's idetifier . // 要求 nib 文件的名称必须和 cell 的唯一标识符相同
/// default main bundle // 默认是 main bundle
- (instancetype) ccRegistNib : (NSString *) sNib ;
- (instancetype) ccRegistNib : (NSString *) sNib
                      bundle : (NSBundle *) bundle ;
/// requires that class name is equal to cell's idetifier . // 要求类名必须和 cell 的唯一标识符相同
- (instancetype) ccRegistCls : (Class) cls ;

/// default main bundle // 默认是 main bundle
- (instancetype) ccRegistHeaderFooterNib : (NSString *) sNib ;
- (instancetype) ccRegistHeaderFooterNib : (NSString *) sNib
                                  bundle : (NSBundle *) bundle ;
- (instancetype) ccRegistHeaderFooterCls : (Class) cls ;

/// wrapper of "beginUpdates" && "endUpdates" // 对于 "beginUpdates" && "endUpdates" 的包裹
- (instancetype) ccUpdating : (void (^)(void)) updating ;

/// for non-animated , only section 0 was available. // 对于无动画来说 , 仅仅是 0 分区有效
/// note : UITableViewRowAnimationNone means reloading without hidden animations . // UITableViewRowAnimationNone 意味着没有隐式动画
/// note : if animated is set to -1 , equals to reloadData. // 如果 将 animated 设置为 -1 , 效果等同于 reloadData
/// note : if reloeded muti sections , using "ccReloadSectionsT:animate:" down below // 如果要重载多个分区 , 使用下方的 "ccReloadSectionsT:animate:"
- (instancetype) ccReloading : (UITableViewRowAnimation) animation ;
- (instancetype) ccReloadSectionsT : (NSIndexSet *) set
                           animate : (UITableViewRowAnimation) animation ;
- (instancetype) ccReloadItemsT : (NSArray <NSIndexPath *> *) array
                        animate : (UITableViewRowAnimation) animation ;

- (__kindof UITableViewCell *) ccDeqCell : (NSString *) sIdentifier ;
/// for cell that register in tableView
- (__kindof UITableViewCell *) ccDeqCell : (NSString *) sIdentifier
                               indexPath : (NSIndexPath *) indexPath ;
- (__kindof UITableViewHeaderFooterView *) ccDeqReusableView : (NSString *) sIdentifier ;

@end

#pragma mark - -----

@interface CCTableExtensionDelegate : NSObject < UITableViewDelegate >

- (id < UITableViewDelegate > ) init ;

- (instancetype) ccCellHeight : (CGFloat (^)(__kindof UITableView * tableView , NSIndexPath *indexPath)) cellHeight ;
- (instancetype) ccSectionHeaderHeight : (CGFloat (^)(__kindof UITableView * tableView , NSInteger iSection)) sectionHeaderHeight ;
- (instancetype) ccSectionHeader : (UIView *(^)(__kindof UITableView *tableView , NSInteger iSection)) sectionHeader ;
- (instancetype) ccSectionFooterHeight : (CGFloat (^)(__kindof UITableView * tableView , NSInteger iSection)) sectionFooterHeight ;
- (instancetype) ccSectionFooter : (UIView *(^)(__kindof UITableView *tableView , NSInteger iSection)) sectionFooter ;
- (instancetype) ccDidSelect : (BOOL (^)(__kindof UITableView *tableView , NSIndexPath *indexPath)) didSelect;

- (instancetype) ccDidScroll : (void (^)(__kindof UIScrollView *scrollView)) didScroll ;
- (instancetype) ccWillBeginDecelerating : (void (^)(__kindof UIScrollView *scrollView)) willBeginDecelerating;
- (instancetype) ccDidEndDecelerating : (void (^)(__kindof UIScrollView *scrollView)) didEndDecelerating;
- (instancetype) ccShouldScrollToTop : (BOOL (^)(__kindof UIScrollView *scrollView)) shouldScrollToTop;
- (instancetype) ccDidScrollToTop : (void (^)(__kindof UIScrollView *scrollView)) didScrollToTop;
- (instancetype) ccWillBeginDragging : (void (^)(__kindof UIScrollView *scrollView)) willBeginDragging;
- (instancetype) ccDidEndDragging : (void (^)(__kindof UIScrollView *scrollView , BOOL decelerate)) didEndDragging;

@end

#pragma mark - -----

@interface CCTableExtensionDataSource : NSObject < UITableViewDataSource >

- (id < UITableViewDataSource >) init ;

- (instancetype) ccSections : (NSInteger (^)(__kindof UITableView *tableView)) sections ;
- (instancetype) ccRowsInSections : (NSInteger (^)(__kindof UITableView * tableView , NSInteger iSection)) rowsInSections ;
- (instancetype) ccCellIdentifier : (NSString *(^)(__kindof UITableView *tableView , NSIndexPath *indexPath)) cellIdentifier ;
- (instancetype) ccConfiguration : (__kindof UITableViewCell *(^)(__kindof UITableView *tableView , __kindof UITableViewCell *cell , NSIndexPath *indexPath)) configuration ;

@end

#pragma mark - -----

/// instructions && notes are the same with 'NSArray+CCExtension_Collection_Refresh' in 'UICollectionView+CCExtension'
// 说明详见 'UICollectionView+CCExtension' 文件中的 'NSArray+CCExtension_Collection_Refresh' , 因为是相同的

@interface NSArray (CCExtension_Table_Refresh)

- (instancetype) ccReload : (__kindof UITableView *) tableView ;
- (instancetype) ccReload : (__kindof UITableView *) tableView
                 sections : (NSIndexSet *) set ;

@end

#pragma mark - -----

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0

/// instructions && notes are the same with 'CCCollectionExtensionDataPrefetching' in 'UICollectionView+CCExtension'
// 说明详见 'UICollectionView+CCExtension' 文件中的 'CCCollectionExtensionDataPrefetching'  , 因为是相同的

@interface CCTableExtensionDataPrefetching : NSObject < UITableViewDataSourcePrefetching >

/// auto enable prefetch in background thread // 已在后台线程启用
- (id < UITableViewDataSourcePrefetching >) init ;

- (instancetype) ccDisableBackgroundMode ;
- (instancetype) ccPrefetchAt : (void (^)(__kindof UITableView *tableView , NSArray <NSIndexPath *> *array)) prefetchAt ;
- (instancetype) ccCancelPrefetchAt : (void (^)(__kindof UITableView *tableView , NSArray <NSIndexPath *> *array)) cancelPrefetchAt;

@end

#endif
