//
//  UICollectionView+CCChain.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 08/08/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "UICollectionView+CCChain.h"

@implementation UICollectionView (CCChain)

+ (UICollectionView *(^)(CCRect, UICollectionViewFlowLayout *))commonS {
    return ^UICollectionView *(CCRect r, UICollectionViewFlowLayout *l) {
        return self.commonC(CGMakeRectFrom(r), l);
    };
}

+ (UICollectionView *(^)(CGRect, UICollectionViewFlowLayout *))commonC {
    return ^UICollectionView *(CGRect r , UICollectionViewFlowLayout *l) {
        UICollectionView *c = [[UICollectionView alloc] initWithFrame:r
                                                 collectionViewLayout:l];
        c.backgroundColor = UIColor.clearColor;
        c.showsVerticalScrollIndicator = false;
        c.showsHorizontalScrollIndicator = false;
        return c;
    };
}

- (UICollectionView *(^)(id))delegateT {
    __weak typeof(self) pSelf = self;
    return ^UICollectionView *(id v) {
        if (v) pSelf.delegate = v;
        return pSelf;
    };
}

- (UICollectionView *(^)(id))dataSourceT {
    __weak typeof(self) pSelf = self;
    return ^UICollectionView *(id v) {
        if (v) pSelf.dataSource = v;
        return pSelf;
    };
}

- (UICollectionView *(^)(NSString *, NSBundle *))registN {
    __weak typeof(self) pSelf = self;
    return ^UICollectionView *(NSString *s , NSBundle *b) {
        if (!b) b = NSBundle.mainBundle;
        [pSelf registerNib:[UINib nibWithNibName:s
                                          bundle:b]
forCellWithReuseIdentifier:s];
        return pSelf;
    };
}

- (UICollectionView *(^)(__unsafe_unretained Class))registC {
    __weak typeof(self) pSelf = self;
    return ^UICollectionView *(Class c) {
        [pSelf registerClass:c
  forCellWithReuseIdentifier:NSStringFromClass(c)];
        return pSelf;
    };
}

- (UICollectionView *(^)(BOOL))reload {
    __weak typeof(self) pSelf = self;
    return ^UICollectionView *(BOOL b) {
        if (b) {
            pSelf.reloadS([NSIndexSet indexSetWithIndex:0], b);
        } else [pSelf reloadData];
        return pSelf;
    };
}

- (UICollectionView *(^)(NSIndexSet *, BOOL))reloadS {
    __weak typeof(self) pSelf = self;
    return ^UICollectionView *(NSIndexSet *s , BOOL b) {
        if (b) {
            [pSelf reloadSections:s];
        } else {
            void (^t)() = ^ {
                [UIView setAnimationsEnabled:false];
                [pSelf performBatchUpdates:^{
                    [pSelf reloadSections:s];
                } completion:^(BOOL finished) {
                    [UIView setAnimationsEnabled:YES];
                }];
            };
            if (NSThread.isMainThread) t();
            else dispatch_sync(dispatch_get_main_queue(), ^{
                t();
            });
        }
        return pSelf;
    };
}

- (UICollectionView *(^)(NSArray<NSIndexPath *> *))reloadI {
    __weak typeof(self) pSelf = self;
    return ^UICollectionView *(NSArray<NSIndexPath *> *a) {
        [pSelf reloadItemsAtIndexPaths:(a ? a : @[])];
        return pSelf;
    };
}

@end

#pragma mark - -----

@implementation UICollectionViewFlowLayout (CCChain)

+ (UICollectionViewFlowLayout *(^)())common {
    return ^UICollectionViewFlowLayout * {
        return UICollectionViewFlowLayout.alloc.init;
    };
}

- (UICollectionViewFlowLayout *(^)(CCSize))itemSizeS {
    __weak typeof(self) pSelf = self;
    return ^UICollectionViewFlowLayout *(CCSize s) {
        return pSelf.itemSizeC(CGMakeSizeFrom(s));
    };
}
- (UICollectionViewFlowLayout *(^)(CGSize))itemSizeC {
    __weak typeof(self) pSelf = self;
    return ^UICollectionViewFlowLayout *(CGSize s) {
        pSelf.itemSize = s;
        return pSelf;
    };
}

- (UICollectionViewFlowLayout *(^)(CCEdgeInsets))sectionInsetS {
    __weak typeof(self) pSelf = self;
    return ^UICollectionViewFlowLayout *(CCEdgeInsets s) {
        return pSelf.sectionInsetC(UIMakeEdgeInsetsFrom(s));
    };
}
- (UICollectionViewFlowLayout *(^)(UIEdgeInsets))sectionInsetC {
    __weak typeof(self) pSelf = self;
    return ^UICollectionViewFlowLayout *(UIEdgeInsets s) {
        pSelf.sectionInset = s;
        return pSelf;
    };
}

- (UICollectionViewFlowLayout *(^)(CCSize))headerSizeS{
    __weak typeof(self) pSelf = self;
    return ^UICollectionViewFlowLayout *(CCSize s) {
        return pSelf.headerSizeC(CGMakeSizeFrom(s));
    };
}
- (UICollectionViewFlowLayout *(^)(CGSize))headerSizeC {
    __weak typeof(self) pSelf = self;
    return ^UICollectionViewFlowLayout *(CGSize s) {
        pSelf.headerReferenceSize = s;
        return pSelf;
    };
}

@end

#pragma mark - -----

@interface CCCollectionChainDelegate ()

@property (nonatomic , copy) BOOL (^blockDidSelect)(UICollectionView *collectionView , NSIndexPath *indexPath) ;
@property (nonatomic , copy) void (^blockDidHightedCell)(UICollectionView *collectionView , NSIndexPath *indexPath) ;
@property (nonatomic , copy) void (^blockDidUnhigntedCell)(UICollectionView *collectionView , NSIndexPath *indexPath) ;
@property (nonatomic , copy) CGFloat (^blockMinimumLineSpacingInSection)(UICollectionView *collectionView , UICollectionViewLayout *layout , NSInteger integerSection) ;
@property (nonatomic , copy) CGFloat (^blockMinimumInterItemSpacingInSection)(UICollectionView *collectionView , UICollectionViewLayout *layout , NSInteger integerSection) ;
@property (nonatomic , copy) UIEdgeInsets (^blockSpacingBetweenSections)(UICollectionView *collectionView , UICollectionViewLayout *layout , NSInteger integerSection) ;

@end

@implementation CCCollectionChainDelegate

+ (CCCollectionChainDelegate<UICollectionViewDelegateFlowLayout> *(^)())common {
    return ^ CCCollectionChainDelegate<UICollectionViewDelegateFlowLayout> * {
        return CCCollectionChainDelegate.alloc.init;
    };
}

- (CCCollectionChainDelegate *(^)(BOOL (^)(UICollectionView *, NSIndexPath *)))didSelect {
    __weak typeof(self) pSelf = self;
    return ^CCCollectionChainDelegate *(BOOL (^t)(UICollectionView *, NSIndexPath *)) {
        if (t) pSelf.blockDidSelect = [t copy];
        return pSelf;
    };
}

- (CCCollectionChainDelegate *(^)(void (^)(UICollectionView *, NSIndexPath *)))didHightedCell {
    __weak typeof(self) pSelf = self;
    return ^CCCollectionChainDelegate *(void (^t)(UICollectionView *, NSIndexPath *)) {
        if (t) pSelf.blockDidHightedCell = [t copy];
        return pSelf;
    };
}

- (CCCollectionChainDelegate *(^)(void (^)(UICollectionView *, NSIndexPath *)))didUnhigntedCell {
    __weak typeof(self) pSelf = self;
    return ^CCCollectionChainDelegate *(void (^t)(UICollectionView *, NSIndexPath *)) {
        if (t) pSelf.blockDidUnhigntedCell = [t copy];
        return pSelf;
    };
}

- (CCCollectionChainDelegate *(^)(CGFloat (^)(UICollectionView *, UICollectionViewLayout *, NSInteger)))minimumLineSpacingInSection {
    __weak typeof(self) pSelf = self;
    return ^CCCollectionChainDelegate *(CGFloat (^t)(UICollectionView *, UICollectionViewLayout *, NSInteger)) {
        if (t) pSelf.blockMinimumLineSpacingInSection = [t copy];
        return pSelf;
    };
}

- (CCCollectionChainDelegate *(^)(CGFloat (^)(UICollectionView *, UICollectionViewLayout *, NSInteger)))minimumInterItemSpacingInSection {
    __weak typeof(self) pSelf = self;
    return ^CCCollectionChainDelegate *(CGFloat (^t)(UICollectionView *, UICollectionViewLayout *, NSInteger)) {
        if (t) pSelf.blockMinimumInterItemSpacingInSection = [t copy];
        return pSelf;
    };
}

- (CCCollectionChainDelegate *(^)(UIEdgeInsets (^)(UICollectionView *, UICollectionViewLayout *, NSInteger)))spacingBetweenSections {
    __weak typeof(self) pSelf = self;
    return ^CCCollectionChainDelegate *(UIEdgeInsets (^t)(UICollectionView *, UICollectionViewLayout *, NSInteger)) {
        if (t) pSelf.spacingBetweenSections = [t copy];
        return pSelf;
    };
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.blockDidSelect) {
        if (self.blockDidSelect(collectionView , indexPath)) {
            [collectionView deselectItemAtIndexPath:indexPath animated:false];
        }
    }
}
- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.blockDidHightedCell)
        self.blockDidHightedCell(collectionView, indexPath);
}
- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.blockDidUnhigntedCell)
        self.blockDidUnhigntedCell(collectionView, indexPath);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return self.blockMinimumLineSpacingInSection ? self.blockMinimumLineSpacingInSection(collectionView , collectionViewLayout , section) : .0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return self.blockMinimumInterItemSpacingInSection ? self.blockMinimumInterItemSpacingInSection (collectionView , collectionViewLayout , section) : .0f;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return self.blockSpacingBetweenSections ? self.blockSpacingBetweenSections(collectionView , collectionViewLayout , section) : UIEdgeInsetsZero ;
}

- (void)dealloc {
#if DEBUG
    NSLog(@"_CC_%@_DEALLOC_" , NSStringFromClass(self.class));
#endif
}

@end

#pragma mark - -----

@interface CCCollectionChainDataSource ()

@property (nonatomic , copy) NSInteger (^blockSections)(UICollectionView *collectionView) ;
@property (nonatomic , copy) NSInteger (^blockItemsInSections)(UICollectionView * collectionView , NSInteger integerSections) ;
@property (nonatomic , copy) NSString *(^blockCellIdentifier)(UICollectionView * collectionView , NSIndexPath * indexPath) ;
@property (nonatomic , copy) UICollectionViewCell *(^blockConfigCell)(UICollectionView * collectionView , UICollectionViewCell * cellConfig , NSIndexPath * indexPath);

@end

@implementation CCCollectionChainDataSource

+ (CCCollectionChainDataSource<UICollectionViewDataSource> *(^)())common {
    return ^ CCCollectionChainDataSource<UICollectionViewDataSource> * {
        return CCCollectionChainDataSource.alloc.init;
    };
}

- (CCCollectionChainDataSource *(^)(NSInteger (^)(UICollectionView *)))sections {
    __weak typeof(self) pSelf = self;
    return ^CCCollectionChainDataSource *(NSInteger (^t)(UICollectionView *)) {
        if (t) pSelf.blockSections = [t copy];
        return pSelf;
    };
}

- (CCCollectionChainDataSource *(^)(NSInteger (^)(UICollectionView *, NSInteger)))itemsInSections {
    __weak typeof(self) pSelf = self;
    return ^CCCollectionChainDataSource *(NSInteger (^t)(UICollectionView *, NSInteger)) {
        if (t) pSelf.blockItemsInSections = [t copy];
        return pSelf;
    };
}

- (CCCollectionChainDataSource *(^)(NSString *(^)(UICollectionView *, NSIndexPath *)))identifierS {
    __weak typeof(self) pSelf = self;
    return ^CCCollectionChainDataSource *(NSString *(^t)(UICollectionView *, NSIndexPath *)) {
        if (t) pSelf.blockCellIdentifier = [t copy];
        return pSelf;
    };
}

- (CCCollectionChainDataSource *(^)(UICollectionViewCell *(^)(UICollectionView *, UICollectionViewCell *, NSIndexPath *)))configCell {
    __weak typeof(self) pSelf = self;
    return ^CCCollectionChainDataSource *(UICollectionViewCell *(^t)(UICollectionView *, UICollectionViewCell *, NSIndexPath *)) {
        if (t) pSelf.blockConfigCell = [t copy];
        return pSelf;
    };
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.blockSections ? self.blockSections(collectionView) : 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.blockItemsInSections ? self.blockItemsInSections(collectionView , section) : 0;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *stringCellIdentifier = self.blockCellIdentifier ? self.blockCellIdentifier(collectionView , indexPath) : @"CELL";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:stringCellIdentifier
                                                                           forIndexPath:indexPath];
    if (!cell) {
        cell = [[UICollectionViewCell alloc] init];
    }
    
    return self.blockConfigCell ? self.blockConfigCell(collectionView , cell , indexPath) : cell;
}

- (void)dealloc {
#if DEBUG
    NSLog(@"_CC_%@_DEALLOC_" , NSStringFromClass(self.class));
#endif
}

@end
