//
//  UICollectionView+CCExtension.h
//  CCExtensionKit
//
//  Created by 冯明庆 on 2017/4/1.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionView (CCExtension)

/// auto enable prefetchiong if support // 如果支持 , 自动启用 预取 ,
+ (instancetype) cc_common : (CGRect) frame
                    layout : (UICollectionViewFlowLayout *) layout;
- (instancetype) cc_delegate : (id <UICollectionViewDelegateFlowLayout>) delegate ;
- (instancetype) cc_datasource : (id <UICollectionViewDataSource>) dataSource ;

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
/// data source that pre-fetching // 预取的代理
- (instancetype) cc_prefetching : (id <UICollectionViewDataSourcePrefetching>) prefetch ;
#endif

/// requires that nib name is equal to cell's idetifier . // 要求 nib 的名称 和 cell 的标记保持一致
- (instancetype) cc_regist_nib : (NSString *) sNib ;
- (instancetype) cc_regist_nib : (NSString *) sNib
                        bundle : (NSBundle *) bundle ;
/// requires that class name is equal to cell's idetifier . // 要求类名要和 cell 的标记保持一致
- (instancetype) cc_regist_cls : (Class) cls ;

/// for non-animated , only section 0 was available. // 如果是无动画 , 只有分区 0 是有效的
/// note : means reloading without hidden animations . // 意味着 reloading 没有 collectionView 默认动画
/// note : if animated is setting to YES , only section 0 will be reloaded . // 如果动画被设置为 YES , 只有 0 分区起效
/// note : if reloeded muti sections , using "ccReloadSections:animated:" down below // 如果要重载多个分区 , 使用下方的 "ccReloadSections:animated:"
- (instancetype) cc_reloading : (BOOL) isAnimated;
- (instancetype) cc_reload_sections : (NSIndexSet *) set
                           animated : (BOOL) isAnimated ;
- (instancetype) cc_reload_items : (NSArray <NSIndexPath *> *) arrayItems;

/// for cell that register in collection // 针对 注册在 collection 的 cell .
- (__kindof UICollectionViewCell *) cc_deq_cell : (NSString *) sIdentifier
                                      indexPath : (NSIndexPath *) indexPath ;
/// for reusable view // 针对重用 view
- (__kindof UICollectionReusableView *) cc_deq_reuseable_view : (NSString *) sElementKind
                                                   identifier : (NSString *) sIdentifier
                                                    indexPath : (NSIndexPath *) indexPath ;

@end

#pragma mark - -----

@interface UICollectionViewFlowLayout (CCExtension)

+ (instancetype) common ;

/// for default sizes // 默认大小
- (instancetype) cc_item_size : (CGSize) size ;
- (instancetype) cc_sections_insets : (UIEdgeInsets) insets ;
- (instancetype) cc_header_size : (CGSize) size ;

@end

#pragma mark - -----

@interface CCCollectionExtensionDelegate : NSObject < UICollectionViewDelegateFlowLayout >

- (id < UICollectionViewDelegateFlowLayout > ) init;
- (instancetype) cc_did_select : (BOOL (^)(__kindof UICollectionView *collectionView ,
                                           NSIndexPath *indexPath)) didSelect;
- (instancetype) cc_did_highted : (void (^)(__kindof UICollectionView *collectionView ,
                                            NSIndexPath *indexPath)) didHighLighted ;
- (instancetype) cc_did_un_highted : (void (^)(__kindof UICollectionView *collectionView ,
                                            NSIndexPath *indexPath)) didUnHighLighted ;
- (instancetype) cc_minimum_line_spacing_in_section : (CGFloat (^)(__kindof UICollectionView *collectionView ,
                                                                   __kindof UICollectionViewLayout *layout ,
                                                                   NSInteger iSection)) minimumLineSpacingInSection;
- (instancetype) cc_minimum_inter_item_spacing_in_section : (CGFloat (^)(__kindof UICollectionView *collectionView ,
                                                                         __kindof UICollectionViewLayout *layout ,
                                                                         NSInteger iSection)) minimumInteritemSpacingInSection;
- (instancetype) cc_spacing_between_sections : (UIEdgeInsets(^)(__kindof UICollectionView *collectionView ,
                                                                __kindof UICollectionViewLayout *layout ,
                                                                NSInteger iSection)) spacingBetweenSections;

- (instancetype) cc_did_scroll : (void (^)(__kindof UIScrollView *scrollView)) didScroll ;
- (instancetype) cc_will_begin_decelerating : (void (^)(__kindof UIScrollView *scrollView)) willBeginDecelerating;
- (instancetype) cc_did_end_decelerating : (void (^)(__kindof UIScrollView *scrollView)) didEndDecelerating;
- (instancetype) cc_should_scroll_to_top : (BOOL (^)(__kindof UIScrollView *scrollView)) shouldScrollToTop;
- (instancetype) cc_did_scroll_to_top : (void (^)(__kindof UIScrollView *scrollView)) didScrollToTop;
- (instancetype) cc_will_begin_dragging : (void (^)(__kindof UIScrollView *scrollView)) willBeginDragging;
- (instancetype) cc_did_end_dragging : (void (^)(__kindof UIScrollView *scrollView , BOOL decelerate)) didEndDragging;

@end

#pragma mark - -----

@interface CCCollectionExtensionDataSource : NSObject < UICollectionViewDataSource >

- (id < UICollectionViewDataSource >) init ;
- (instancetype) cc_sections : (NSInteger (^)(__kindof UICollectionView *collectionView)) sections ;
- (instancetype) cc_items_in_sections : (NSInteger (^)(__kindof UICollectionView * collectionView ,
                                                       NSInteger iSections)) itemInSections ;
- (instancetype) cc_cell_identifier : (NSString *(^)(__kindof UICollectionView * collectionView ,
                                                     NSIndexPath * indexPath)) identifier ;
- (instancetype) cc_configuration : (__kindof UICollectionViewCell *(^)(__kindof UICollectionView * collectionView ,
                                                                        __kindof UICollectionViewCell * cell ,
                                                                        NSIndexPath * indexPath)) configuration ;

@end

#pragma mark - -----

@interface NSArray (CCExtension_Collection_Refresh)

- (instancetype) cc_reload : (__kindof UICollectionView *) collectionView ;
- (instancetype) cc_reload : (__kindof UICollectionView *) collectionView
                  sections : (NSIndexSet *) set ;

@end

#pragma mark - -----

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0

/// pre-fetching // 预取
/// note: highly recommended to put prefetching in background thread , in other word , must // 建议把预取放在后台线程 , 换句话说 , 必须
/// note: pre-fetch is sort-of auto fit technics , therefore , these method (for delegate it self) // 预取是一种自适应技术 , 所以 , 这些方法(代理)
///     will not recalls for every time the collection view shows it cells . // 不会在每次都展示 cell 的时候调用
/// note: that is , if users scrolling slowly or stop to scroll , it will goes pre-fetch // 指的是 , 如果用户缓慢滑动 , 或者停止滑动 , 才会预取
///     if fast , goes not . //  如果滑动速度快 , 不会
/// note: for canceling , when users interested in sth , or reverse it scroll directions , // 对于取消 , 当用户对某些东西感兴趣 , 或者翻转了滑动方向
///     or press to make system reponse an event , then , canceling was active . // 或者按下了必须要系统响应的时间 , 这时 , 取消动作生效
/// note: sometimes canceling was not used in actual. // 不过有时候 , 取消并不被真正的使用
/// note: when canceling has recall values , maybe it's a subset of 'cc_prefetch_at:' // 如果取消有了回调值 , 可能这个回调值是 'cc_prefetch_at:' 的一个子集

@interface CCCollectionExtensionDataPrefetching : NSObject < UICollectionViewDataSourcePrefetching >

/// auto enable prefetch in background thread
- (id <UICollectionViewDataSourcePrefetching> ) init ;
- (instancetype) cc_disable_background_mode;
- (instancetype) cc_prefetch_at : (void (^)(__kindof UICollectionView *collectionView ,
                                            NSArray <NSIndexPath *> *array)) fetch ;
- (instancetype) cc_cancel_prefetch_at : (void (^)(__kindof UICollectionView *collectionView ,
                                                   NSArray <NSIndexPath *> *array)) cancel ;

@end

#endif

