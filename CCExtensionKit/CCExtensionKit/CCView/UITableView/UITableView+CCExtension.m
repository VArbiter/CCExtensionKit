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

- (instancetype) ccUpdating : (void (^)()) updating {
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
        
        void (^t)(void (^)()) = ^(void (^e)()) {
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
            
            void (^t)(void (^)()) = ^(void (^e)()) {
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

@property (nonatomic , copy) CGFloat (^blockCellHeight)(UITableView * tableView , NSIndexPath *indexPath) ;
@property (nonatomic , copy) CGFloat (^blockSectionHeaderHeight)(UITableView * tableView , NSInteger integerSection) ;
@property (nonatomic , copy) UIView *(^blockSectionHeader)(UITableView *tableView , NSInteger integerSection) ;
@property (nonatomic , copy) CGFloat (^blockSectionFooterHeight)(UITableView * tableView , NSInteger integerSection) ;
@property (nonatomic , copy) UIView *(^blockSectionFooter)(UITableView *tableView , NSInteger integerSection) ;
@property (nonatomic , copy) BOOL (^blockDidSelect)(UITableView *tableView , NSIndexPath *indexPath) ;

@end

@implementation CCTableExtensionDelegate

- (id < UITableViewDelegate >) init {
    if ((self = [super init])) {
        return self;
    }
    return self;
}

- (instancetype) ccCellHeight : (CGFloat (^)(UITableView * tableView , NSIndexPath *indexPath)) cellHeight {
    self.blockCellHeight = [cellHeight copy];
    return self;
}
- (instancetype) ccSectionHeaderHeight : (CGFloat (^)(UITableView * tableView , NSInteger iSection)) sectionHeaderHeight {
    self.blockSectionHeaderHeight = [sectionHeaderHeight copy];
    return self;
}
- (instancetype) ccSectionHeader : (UIView *(^)(UITableView *tableView , NSInteger iSection)) sectionHeader {
    self.blockSectionHeader = [sectionHeader copy];
    return self;
}
- (instancetype) ccSectionFooterHeight : (CGFloat (^)(UITableView * tableView , NSInteger iSection)) sectionFooterHeight {
    self.blockSectionFooterHeight = [sectionFooterHeight copy];
    return self;
}
- (instancetype) ccSectionFooter : (UIView *(^)(UITableView *tableView , NSInteger iSection)) sectionFooter {
    self.blockSectionFooter = [sectionFooter copy];
    return self;
}
- (instancetype) ccDidSelect : (BOOL (^)(UITableView *tableView , NSIndexPath *indexPath)) didSelect {
    self.blockDidSelect = [didSelect copy];
    return self;
}

#pragma mark - ---

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.blockCellHeight ? self.blockCellHeight(tableView , indexPath) : 45.f ;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.blockSectionHeaderHeight ? self.blockSectionHeaderHeight(tableView , section) : .0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.blockSectionHeader ? self.blockSectionHeader(tableView , section) : nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return self.blockSectionFooter ? self.blockSectionFooter(tableView , section) : nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return self.blockSectionFooterHeight ? self.blockSectionFooterHeight(tableView , section) : .01f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.blockDidSelect) {
        if (self.blockDidSelect(tableView , indexPath)) {
            [tableView deselectRowAtIndexPath:indexPath animated:false];
        }
    }
}

- (void)dealloc {
#if DEBUG
    NSLog(@"_CC_%@_DEALLOC_" , NSStringFromClass(self.class));
#endif
}

@end

#pragma mark - -----

@interface CCTableExtensionDataSource ()

@property (nonatomic , copy) NSInteger (^blockSections)(UITableView *tableView);
@property (nonatomic , copy) NSInteger (^blockRowsInSections)(UITableView * tableView , NSInteger integerSection);
@property (nonatomic , copy) NSString * (^blockCellIdentifier)(UITableView *tableView , NSIndexPath *indexPath) ;
@property (nonatomic , copy) UITableViewCell * (^blockConfigCell)(UITableView *tableView , UITableViewCell *cellConfig , NSIndexPath *indexPath) ;

@end

@implementation CCTableExtensionDataSource

- (id < UITableViewDataSource >) init {
    if ((self = [super init])) {
        return self;
    }
    return self;
}

- (instancetype) ccSections : (NSInteger (^)(UITableView *tableView)) sections {
    self.blockSections = [sections copy];
    return self;
}
- (instancetype) ccRowsInSections : (NSInteger (^)(UITableView * tableView , NSInteger iSection)) rowsInSections {
    self.blockRowsInSections = [rowsInSections copy];
    return self;
}
- (instancetype) ccCellIdentifier : (NSString *(^)(UITableView *tableView , NSIndexPath *indexPath)) cellIdentifier {
    self.blockCellIdentifier = [cellIdentifier copy];
    return self;
}
- (instancetype) ccConfiguration : (__kindof UITableViewCell *(^)(UITableView *tableView , __kindof UITableViewCell *tCell , NSIndexPath *indexPath)) configuration {
    self.blockConfigCell = [configuration copy];
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.blockSections ? self.blockSections(tableView) : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.blockRowsInSections ? self.blockRowsInSections(tableView , section) : 0 ;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *stringCellIdentifer = self.blockCellIdentifier ? self.blockCellIdentifier(tableView , indexPath) : _CC_TABLE_VIEW_HOLDER_CELL_IDENTIFIER_;
    
    UITableViewCell *cell = nil;
    if (self.blockCellIdentifier) cell = [tableView dequeueReusableCellWithIdentifier:stringCellIdentifer
                                                                         forIndexPath:indexPath];
    else cell = [tableView dequeueReusableCellWithIdentifier:stringCellIdentifer];
    if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                             reuseIdentifier:stringCellIdentifer];
    return self.blockConfigCell ? self.blockConfigCell(tableView , cell , indexPath) : cell;
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
- (instancetype) ccPrefetchAt : (void (^)(__kindof UITableView *collectionView , NSArray <NSIndexPath *> *array)) prefetchAt {
    self.prefetching = [prefetchAt copy];
    return self;
}
- (instancetype) ccCancelPrefetchAt : (void (^)(__kindof UITableView *collectionView , NSArray <NSIndexPath *> *array)) cancelPrefetchAt {
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

