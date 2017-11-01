//
//  UITableView+CCExtension.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/1.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "UITableView+CCExtension.h"

#ifndef _CC_TABLE_VIEW_HOLDER_CELL_IDENTIFIER_
    #define _CC_TABLE_VIEW_HOLDER_CELL_IDENTIFIER_ @"CC_TABLE_VIEW_HOLDER_CELL_IDENTIFIER"
#endif

@implementation UITableView (CCExtension)

+ (instancetype) common : (CGRect) frame {
    return [self common:frame style:UITableViewStylePlain];
}
+ (instancetype) common : (CGRect) frame
                  style : (UITableViewStyle) style {
    UITableView *v  = [[UITableView alloc] initWithFrame:frame
                                                   style:style];
    v.showsVerticalScrollIndicator = false;
    v.showsHorizontalScrollIndicator = false;
    v.separatorStyle = UITableViewCellSeparatorStyleNone;
    v.backgroundColor = UIColor.clearColor;
    [v registerClass:UITableViewCell.class
forCellReuseIdentifier:_CC_TABLE_VIEW_HOLDER_CELL_IDENTIFIER_];
    
    // for shaking problem under iOS 11 . rewrite them when needed .
    if (UIDevice.currentDevice.systemVersion.floatValue >= 11.f) {
        v.estimatedRowHeight = 0;
        v.estimatedSectionHeaderHeight = 0;
        v.estimatedSectionFooterHeight = 0;
    }
    
    return v;
}

- (instancetype) ccDelegateT : (id) delegate {
    self.delegate = delegate;
    return self;
}
- (instancetype) ccDataSourceT : (id) dataSource {
    self.dataSource = dataSource;
    return self;
}
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
- (instancetype) ccPrefetchingT : (id) prefetch {
    if (UIDevice.currentDevice.systemVersion.floatValue >= 10.f) {
        self.prefetchDataSource = prefetch;
    }
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
forCellReuseIdentifier:sNib];
    return self;
}

- (instancetype) ccRegistCls : (Class) cls {
    [self registerClass:cls
  forCellReuseIdentifier:NSStringFromClass(cls)];
    return self;
}

- (instancetype) ccRegistHeaderFooterNib : (NSString *) sNib {
    return [self ccRegistHeaderFooterNib:sNib bundle:nil];
}
- (instancetype) ccRegistHeaderFooterNib : (NSString *) sNib
                                  bundle : (NSBundle *) bundle {
    if (NSClassFromString(sNib) == UITableViewHeaderFooterView.class
        || [NSClassFromString(sNib) isSubclassOfClass:UITableViewHeaderFooterView.class]) {
        if (!bundle) bundle = NSBundle.mainBundle;
        [self registerNib:[UINib nibWithNibName:sNib
                                         bundle:bundle]
forHeaderFooterViewReuseIdentifier:sNib];
    }
    return self;
}
- (instancetype) ccRegistHeaderFooterCls : (Class) cls {
    if (cls == UITableViewHeaderFooterView.class
        || [cls isSubclassOfClass:UITableViewHeaderFooterView.class]){
        [self registerClass:cls forHeaderFooterViewReuseIdentifier:NSStringFromClass(cls)];
    }
    return self;
}

- (instancetype) ccUpdating : (void (^)(void)) updating {
    if (updating) {
        [self beginUpdates];
        updating();
        [self endUpdates];
    }
    return self;
}

- (instancetype) ccReloading : (UITableViewRowAnimation) animation {
    if ((NSInteger)animation > 0 && animation != UITableViewRowAnimationNone) {
        return [self ccReloadSectionsT:[NSIndexSet indexSetWithIndex:0]
                               animate:animation];
    }
    else [self reloadData];
    return self;
}
- (instancetype) ccReloadSectionsT : (NSIndexSet *) set
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
        
        __weak typeof(self) pSelf = self;
        if ((NSInteger)animation == -2) {
            t(^{
                [pSelf reloadSections:set
                     withRowAnimation:UITableViewRowAnimationNone];
            });
        } else [self reloadSections:set
                   withRowAnimation:UITableViewRowAnimationNone];
    }
    return self;
}
- (instancetype) ccReloadItemsT : (NSArray <NSIndexPath *> *) array
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
            __weak typeof(self) pSelf = self;
            if ((NSInteger)animation == -2) {
                t(^{
                    [pSelf reloadRowsAtIndexPaths:array
                                 withRowAnimation:UITableViewRowAnimationNone];
                });
            } else [self reloadRowsAtIndexPaths:array
                               withRowAnimation:UITableViewRowAnimationNone];
        }
    }
    else [self reloadData];
    return self;
}

- (__kindof UITableViewCell *) ccDeqCell : (NSString *) sIdentifier {
    return [self dequeueReusableCellWithIdentifier:sIdentifier];
}

- (__kindof UITableViewCell *) ccDeqCell : (NSString *) sIdentifier
                               indexPath : (NSIndexPath *) indexPath {
    return [self dequeueReusableCellWithIdentifier:sIdentifier
                                      forIndexPath:indexPath];
}
- (__kindof UITableViewHeaderFooterView *) ccDeqReusableView : (NSString *) sIdentifier {
    return [self dequeueReusableHeaderFooterViewWithIdentifier:sIdentifier];
}

@end

#pragma mark - -----

@interface CCTableExtensionDelegate ()

@property (nonatomic , copy) CGFloat (^bCellHeight)(__kindof UITableView * tableView , NSIndexPath *indexPath) ;
@property (nonatomic , copy) CGFloat (^bSectionHeaderHeight)(__kindof UITableView * tableView , NSInteger integerSection) ;
@property (nonatomic , copy) UIView *(^bSectionHeader)(__kindof UITableView *tableView , NSInteger integerSection) ;
@property (nonatomic , copy) CGFloat (^bSectionFooterHeight)(__kindof UITableView * tableView , NSInteger integerSection) ;
@property (nonatomic , copy) UIView *(^bSectionFooter)(__kindof UITableView *tableView , NSInteger integerSection) ;
@property (nonatomic , copy) BOOL (^bDidSelect)(__kindof UITableView *tableView , NSIndexPath *indexPath) ;

@property (nonatomic , copy) void (^bDidScroll)(__kindof UIScrollView *scrollView);
@property (nonatomic , copy) void (^bWillBeginDecelerating)(__kindof UIScrollView *scrollView);
@property (nonatomic , copy) void (^bDidEndDecelerating)(__kindof UIScrollView *scrollView);
@property (nonatomic , copy) BOOL (^bShouldScrollToTop)(__kindof UIScrollView *scrollView);
@property (nonatomic , copy) void (^bDidScrollToTop)(__kindof UIScrollView *scrollView);

@end

@implementation CCTableExtensionDelegate

- (id < UITableViewDelegate >) init {
    if ((self = [super init])) {
        return self;
    }
    return self;
}

- (instancetype) ccCellHeight : (CGFloat (^)(__kindof UITableView * tableView , NSIndexPath *indexPath)) cellHeight {
    self.bCellHeight = [cellHeight copy];
    return self;
}
- (instancetype) ccSectionHeaderHeight : (CGFloat (^)(__kindof UITableView * tableView , NSInteger iSection)) sectionHeaderHeight {
    self.bSectionHeaderHeight = [sectionHeaderHeight copy];
    return self;
}
- (instancetype) ccSectionHeader : (UIView *(^)(__kindof UITableView *tableView , NSInteger iSection)) sectionHeader {
    self.bSectionHeader = [sectionHeader copy];
    return self;
}
- (instancetype) ccSectionFooterHeight : (CGFloat (^)(__kindof UITableView * tableView , NSInteger iSection)) sectionFooterHeight {
    self.bSectionFooterHeight = [sectionFooterHeight copy];
    return self;
}
- (instancetype) ccSectionFooter : (UIView *(^)(__kindof UITableView *tableView , NSInteger iSection)) sectionFooter {
    self.bSectionFooter = [sectionFooter copy];
    return self;
}
- (instancetype) ccDidSelect : (BOOL (^)(__kindof UITableView *tableView , NSIndexPath *indexPath)) didSelect {
    self.bDidSelect = [didSelect copy];
    return self;
}

- (instancetype) ccDidScroll : (void (^)(__kindof UIScrollView *scrollView)) didScroll {
    self.bDidScroll = [didScroll copy];
    return self;
}
- (instancetype) ccWillBeginDecelerating : (void (^)(__kindof UIScrollView *scrollView)) willBeginDecelerating {
    self.bWillBeginDecelerating = [willBeginDecelerating copy];
    return self;
}
- (instancetype) ccDidEndDecelerating : (void (^)(__kindof UIScrollView *scrollView)) didEndDecelerating {
    self.bDidEndDecelerating = [didEndDecelerating copy];
    return self;
}
- (instancetype) ccShouldScrollToTop : (BOOL (^)(__kindof UIScrollView *scrollView)) shouldScrollToTop {
    self.bShouldScrollToTop = [shouldScrollToTop copy];
    return self;
}
- (instancetype) ccDidScrollToTop : (void (^)(__kindof UIScrollView *scrollView)) didScrollToTop {
    self.bDidScrollToTop = [didScrollToTop copy];
    return self;
}

#pragma mark - ---

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.bCellHeight ? self.bCellHeight(tableView , indexPath) : 45.f ;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.bSectionHeaderHeight ? self.bSectionHeaderHeight(tableView , section) : .0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.bSectionHeader ? self.bSectionHeader(tableView , section) : nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return self.bSectionFooter ? self.bSectionFooter(tableView , section) : nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return self.bSectionFooterHeight ? self.bSectionFooterHeight(tableView , section) : .01f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.bDidSelect) {
        if (self.bDidSelect(tableView , indexPath)) {
            [tableView deselectRowAtIndexPath:indexPath animated:false];
        }
    }
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

- (void)dealloc {
#if DEBUG
    NSLog(@"_CC_%@_DEALLOC_" , NSStringFromClass(self.class));
#endif
}

@end

#pragma mark - -----

@interface CCTableExtensionDataSource ()

@property (nonatomic , copy) NSInteger (^bSections)(__kindof UITableView *tableView);
@property (nonatomic , copy) NSInteger (^bRowsInSections)(__kindof UITableView * tableView , NSInteger integerSection);
@property (nonatomic , copy) NSString * (^bCellIdentifier)(__kindof UITableView *tableView , NSIndexPath *indexPath) ;
@property (nonatomic , copy) UITableViewCell * (^bConfigCell)(__kindof UITableView *tableView , UITableViewCell *cellConfig , NSIndexPath *indexPath) ;

@end

@implementation CCTableExtensionDataSource

- (id < UITableViewDataSource >) init {
    if ((self = [super init])) {
        return self;
    }
    return self;
}

- (instancetype) ccSections : (NSInteger (^)(__kindof UITableView *tableView)) sections {
    self.bSections = [sections copy];
    return self;
}
- (instancetype) ccRowsInSections : (NSInteger (^)(__kindof UITableView * tableView , NSInteger iSection)) rowsInSections {
    self.bRowsInSections = [rowsInSections copy];
    return self;
}
- (instancetype) ccCellIdentifier : (NSString *(^)(__kindof UITableView *tableView , NSIndexPath *indexPath)) cellIdentifier {
    self.bCellIdentifier = [cellIdentifier copy];
    return self;
}
- (instancetype) ccConfiguration : (__kindof UITableViewCell *(^)(__kindof UITableView *tableView , __kindof UITableViewCell *tCell , NSIndexPath *indexPath)) configuration {
    self.bConfigCell = [configuration copy];
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.bSections ? self.bSections(tableView) : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.bRowsInSections ? self.bRowsInSections(tableView , section) : 0 ;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *stringCellIdentifer = self.bCellIdentifier ? self.bCellIdentifier(tableView , indexPath) : _CC_TABLE_VIEW_HOLDER_CELL_IDENTIFIER_;
    
    UITableViewCell *cell = nil;
    if (self.bCellIdentifier) cell = [tableView dequeueReusableCellWithIdentifier:stringCellIdentifer
                                                                         forIndexPath:indexPath];
    else cell = [tableView dequeueReusableCellWithIdentifier:stringCellIdentifer];
    if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                             reuseIdentifier:stringCellIdentifer];
    return self.bConfigCell ? self.bConfigCell(tableView , cell , indexPath) : cell;
}

- (void)dealloc {
#if DEBUG
    NSLog(@"_CC_%@_DEALLOC_" , NSStringFromClass(self.class));
#endif
}

@end

#pragma mark - -----

@implementation NSArray (CCExtension_Table_Refresh)

- (instancetype) ccReload : (__kindof UITableView *) tableView {
    if (self.count) [tableView ccReloading:UITableViewRowAnimationFade];
    else [tableView reloadData];
    return self;
}
- (instancetype) ccReload : (__kindof UITableView *) tableView
                 sections : (NSIndexSet *) set {
    if (self.count) [tableView ccReloadSectionsT:set animate:UITableViewRowAnimationFade];
    else [tableView ccReloadSectionsT:set animate:UITableViewRowAnimationNone];
    return self;
}

@end

#pragma mark - -----

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0

@interface CCTableExtensionDataPrefetching ()

@property (nonatomic , assign) BOOL isDisableBackground ;
@property (nonatomic , copy) void (^prefetching)(__kindof UITableView *, NSArray<NSIndexPath *> *);
@property (nonatomic , copy) void (^canceling)(__kindof UITableView *, NSArray<NSIndexPath *> *);

@property (nonatomic) dispatch_queue_t queue ;

@end

@implementation CCTableExtensionDataPrefetching

- (id < UITableViewDataSourcePrefetching >) init {
    if ((self = [super init])) {
        
    }
    return self;
}

- (instancetype) ccDisableBackgroundMode {
    self.isDisableBackground = YES;
    return self;
}
- (instancetype) ccPrefetchAt : (void (^)(__kindof UITableView *tableView , NSArray <NSIndexPath *> *array)) prefetchAt {
    self.prefetching = [prefetchAt copy];
    return self;
}
- (instancetype) ccCancelPrefetchAt : (void (^)(__kindof UITableView *tableView , NSArray <NSIndexPath *> *array)) cancelPrefetchAt {
    self.canceling = [cancelPrefetchAt copy];
    return self;
}

- (void)tableView:(UITableView *)tableView prefetchRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    if (!self.queue && !self.isDisableBackground) {
        if (UIDevice.currentDevice.systemVersion.floatValue >= 8.f) {
            self.queue = dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0);
        }
        else self.queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    }
    
    if (!self.isDisableBackground) {
        __weak typeof(self) pSelf = self;
        dispatch_async(self.queue, ^{
            if (pSelf.prefetching) pSelf.prefetching(tableView, indexPaths);
        });
    }
    else if (self.prefetching) self.prefetching(tableView, indexPaths);
}
- (void)tableView:(UITableView *)tableView cancelPrefetchingForRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    if (self.canceling) self.canceling(tableView, indexPaths);
}

- (void)dealloc {
#if DEBUG
    NSLog(@"_CC_%@_DEALLOC_" , NSStringFromClass(self.class));
#endif
}

@end

#endif

