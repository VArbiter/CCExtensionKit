//
//  UICollectionView+CCExtension.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/1.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "UICollectionView+CCExtension.h"

#import "CCCommonTools.h"

#import "UIImageView+CCExtension.h"
#import "CCCustomFooter.h"
#import "CCCustomHeader.h"

#import <objc/runtime.h>

@implementation UICollectionView (CCExtension)

+ (instancetype) ccCommon : (CGRect)frame
                   layout : (UICollectionViewLayout *)layout
       delegateDataSource : (id) delegateDatasource {
    return [self ccCommon:frame
                   layout:layout
                 delegate:delegateDatasource
               dataSource:delegateDatasource];
}

+ (instancetype) ccCommon : (CGRect)frame
                   layout : (UICollectionViewLayout *)layout
                 delegate : (id) delegate
               dataSource : (id) datasource {
    UICollectionView * collectionView = [[UICollectionView alloc] initWithFrame:frame
                                                           collectionViewLayout:layout];
    if (delegate) 
        collectionView.delegate = delegate;
    if (datasource)
        collectionView.dataSource = datasource;
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.showsVerticalScrollIndicator = false;
    collectionView.showsHorizontalScrollIndicator = false;
    return collectionView;
}

- (void) ccRegistNib : (NSString *) stringNib {
    [self registerNib:[UINib nibWithNibName:stringNib
                                     bundle:[NSBundle mainBundle]]
        forCellWithReuseIdentifier:stringNib];
}

- (void) ccRegistClass : (NSString *) stringClazz {
    [self registerClass:NSClassFromString(stringClazz)
        forCellWithReuseIdentifier:stringClazz];
}

- (void) ccHeaderRefreshing : (CCEndLoadType(^)()) blockRefresh
          footerLoadMore: (CCEndLoadType(^)()) blockLoadMore {
    ccWeakSelf;
    CC_Safe_UI_Operation(blockRefresh, ^{
        CCCustomHeader *header = [CCCustomHeader headerWithRefreshingBlock:^{
            if (blockRefresh() != CCEndLoadTypeManualEnd) {
                [pSelf.mj_header endRefreshing];
            }
        }];
//        header.lastUpdatedTimeLabel.hidden = YES;
//        header.stateLabel.hidden = YES;
//        header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        
        pSelf.mj_header = header;
    });
    
    CC_Safe_UI_Operation(blockLoadMore, ^{
        CCCustomFooter *footer = [CCCustomFooter footerWithRefreshingBlock:^{
            switch (blockLoadMore()) {
                case CCEndLoadTypeEnd:{
                    [pSelf.mj_footer endRefreshing];
                }break;
                case CCEndLoadTypeNoMoreData:{
                    [pSelf.mj_footer endRefreshingWithNoMoreData];
                }break;
                case CCEndLoadTypeManualEnd:{
                    
                }break;
                    
                default:{
                    [pSelf.mj_header endRefreshing];
                }break;
            }
        }];

        pSelf.mj_footer = footer;
    });
}

- (void) ccHeaderEndRefreshing {
    [self.mj_header endRefreshing];
}
- (void) ccFooterEndLoadMore {
    [self.mj_footer endRefreshing];
}

- (void) ccEndLoading {
    [self ccHeaderEndRefreshing];
    [self ccFooterEndLoadMore];
}
- (void) ccFooterEndLoadMoreWithNoMoreData {
    [self ccHeaderEndRefreshing];
    if ([self.mj_footer isKindOfClass:[MJRefreshAutoGifFooter class]]) {
        MJRefreshAutoGifFooter *footer = (MJRefreshAutoGifFooter *) self.mj_footer;
        footer.stateLabel.hidden = false;
    }
    [self.mj_footer endRefreshingWithNoMoreData];
}
- (void) ccResetLoadMoreStatus {
    if ([self.mj_footer isKindOfClass:[MJRefreshAutoGifFooter class]]) {
        MJRefreshAutoGifFooter *footer = (MJRefreshAutoGifFooter *) self.mj_footer;
        footer.stateLabel.hidden = false;
    }
    [self.mj_footer resetNoMoreData];
}

- (void) ccReloadData {
    [self ccReloadSections:[NSIndexSet indexSetWithIndex:0]];
}

- (void) ccReloadSections : (NSIndexSet *) indexSet {
    if (!indexSet) return;
    CC_Main_Queue_Operation(^{
        ccWeakSelf;
        [UIView setAnimationsEnabled:false];
        [self performBatchUpdates:^{
            [pSelf reloadSections:indexSet];
        } completion:^(BOOL finished) {
            [UIView setAnimationsEnabled:YES];
        }];
    });
}

@end

#pragma mark - UICollectionViewFlowLayout --------------------------------------

@implementation UICollectionViewFlowLayout (CCExtension)

+ (instancetype) ccCollectionLayout : (CGSize) sizeItem {
    return [self ccCollectionLayout:sizeItem
                       sectionInset:UIEdgeInsetsZero
                         headerSize:CGSizeZero];
}

+ (instancetype) ccCollectionLayout : (CGSize) sizeItem
                       sectionInset : (UIEdgeInsets) edgeInsets {
    return [self ccCollectionLayout:sizeItem
                       sectionInset:edgeInsets
                         headerSize:CGSizeZero];
}

+ (instancetype) ccCollectionLayout : (CGSize) sizeItem
                       sectionInset : (UIEdgeInsets) edgeInsets
                         headerSize : (CGSize) sizeHeader {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = sizeItem;
    if (!UIEdgeInsetsEqualToEdgeInsets(edgeInsets, UIEdgeInsetsZero)) {
        layout.sectionInset = edgeInsets;
    }
    layout.sectionInset = edgeInsets;
    if (!CGSizeEqualToSize(sizeHeader, CGSizeZero)) {
        layout.headerReferenceSize = sizeHeader;
    }
    return layout;
}

@end

#pragma mark - CCCollectionViewDelegate ----------------------------------------

@implementation CCCollectionViewDelegate

- (id < UICollectionViewDelegateFlowLayout > ) init {
    if (self = [super init]) {
        return self;
    }
    return self;
}

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
    return self.blockMinimumInteritemSpacingInSection ? self.blockMinimumInteritemSpacingInSection (collectionView , collectionViewLayout , section) : .0f;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return self.blockSpacingBetweenSections ? self.blockSpacingBetweenSections(collectionView , collectionViewLayout , section) : UIEdgeInsetsZero ;
}

_CC_DETECT_DEALLOC_

@end


#pragma mark - CCCollectionViewDataSource --------------------------------------

@implementation CCCollectionViewDataSource

- (id < UICollectionViewDataSource >) init {
    if ((self = [super init])) {
        return self;
    }
    return self;
}

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

_CC_DETECT_DEALLOC_

@end


