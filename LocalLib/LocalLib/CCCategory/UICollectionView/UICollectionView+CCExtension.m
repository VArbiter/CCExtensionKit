//
//  UICollectionView+CCExtension.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/1.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "UICollectionView+CCExtension.h"
#import "CCCommonDefine.h"

#import "UIImageView+CCExtension.h"
#import "CCCustomFooter.h"
#import "CCCustomHeader.h"

#import <objc/runtime.h>

@implementation UICollectionView (CCExtension)

+ (instancetype) ccInitWithFrame : (CGRect)frame
                      withLayout : (UICollectionViewLayout *)layout
          withDelegateDataSource : (id) delegateDatasource {
    return [self ccInitWithFrame:frame
                      withLayout:layout
                    withDelegate:delegateDatasource
                  withDataSource:delegateDatasource];
}

+ (instancetype) ccInitWithFrame : (CGRect)frame
                      withLayout : (UICollectionViewLayout *)layout
                    withDelegate : (id) delegate
                  withDataSource : (id) datasource {
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

- (void) ccHeaderRefreshing : (CCCollectionViewEndLoadType(^)()) blockRefresh
          withFooterLoadMore: (CCCollectionViewEndLoadType(^)()) blockLoadMore {
    ccWeakSelf;
    _CC_Safe_UI_Block_(blockRefresh, ^{
        CCCustomHeader *header = [CCCustomHeader headerWithRefreshingBlock:^{
            if (blockRefresh() != CCCollectionViewEndLoadTypeManualEnd) {
                [pSelf.mj_header endRefreshing];
            }
        }];
//        header.lastUpdatedTimeLabel.hidden = YES;
//        header.stateLabel.hidden = YES;
//        header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        /*
        header.gifView.contentMode = UIViewContentModeScaleAspectFit;
        
        [header setTitle:ccLocalize(@"_CC_PULL_DOWN_TO_REFRESH_", "下拉以刷新")
                forState:MJRefreshStateIdle];
        [header setTitle:ccLocalize(@"_CC_RELEASE_TO_REFRESH_", "松开刷新")
                forState:MJRefreshStatePulling];
        [header setTitle:ccLocalize(@"_CC_IS_REFRESHING_", "正在刷新")
                forState:MJRefreshStateRefreshing];
        [header setTitle:ccLocalize(@"_CC_RELEASE_TO_REFRESH_", "松开刷新")
                forState:MJRefreshStateWillRefresh];
        
        NSArray *array= [NSArray ccRefreshGifImageArray];
        [header setImages:array
                 forState:MJRefreshStateIdle];
        [header setImages:array
                 forState:MJRefreshStatePulling];
        [header setImages:array
                 forState:MJRefreshStateRefreshing];
         */
        
        pSelf.mj_header = header;
    });
    
    _CC_Safe_UI_Block_(blockLoadMore, ^{
        CCCustomFooter *footer = [CCCustomFooter footerWithRefreshingBlock:^{
            switch (blockLoadMore()) {
                case CCCollectionViewEndLoadTypeEnd:{
                    [pSelf.mj_footer endRefreshing];
                }break;
                case CCCollectionViewEndLoadTypeNoMoreData:{
                    [pSelf.mj_footer endRefreshingWithNoMoreData];
                }break;
                case CCCollectionViewEndLoadTypeManualEnd:{
                    
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
    _CC_UI_Operate_block(^{
        ccWeakSelf;
        [UIView setAnimationsEnabled:false];
        [self performBatchUpdates:^{
            [pSelf reloadSections:[NSIndexSet indexSetWithIndex:0]];
        } completion:^(BOOL finished) {
            [UIView setAnimationsEnabled:YES];
        }];
    });
}

@end
