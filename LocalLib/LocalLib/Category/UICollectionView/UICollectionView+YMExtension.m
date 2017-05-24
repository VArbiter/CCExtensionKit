//
//  UICollectionView+YMExtension.m
//  ym_sell_ios
//
//  Created by 冯明庆 on 2017/4/1.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "UICollectionView+YMExtension.h"
#import "YMCommonDefine.h"

#import "UIImageView+YMExtension.h"
#import "YMCustomFooter.h"
#import "YMCustomHeader.h"

#import <objc/runtime.h>

@implementation UICollectionView (YMExtension)

+ (instancetype) ymInitWithFrame : (CGRect)frame
                      withLayout : (UICollectionViewLayout *)layout
          withDelegateDataSource : (id) delegateDatasource {
    return [self ymInitWithFrame:frame
                      withLayout:layout
                    withDelegate:delegateDatasource
                  withDataSource:delegateDatasource];
}

+ (instancetype) ymInitWithFrame : (CGRect)frame
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

- (void) ymRegistNib : (NSString *) stringNib {
    [self registerNib:[UINib nibWithNibName:stringNib
                                     bundle:[NSBundle mainBundle]]
        forCellWithReuseIdentifier:stringNib];
}

- (void) ymRegistClass : (NSString *) stringClazz {
    [self registerClass:NSClassFromString(stringClazz)
        forCellWithReuseIdentifier:stringClazz];
}

- (void) ymHeaderRefreshing : (YMCollectionViewEndLoadType(^)()) blockRefresh
          withFooterLoadMore: (YMCollectionViewEndLoadType(^)()) blockLoadMore {
    ymWeakSelf;
    _YM_Safe_UI_Block_(blockRefresh, ^{
        YMCustomHeader *header = [YMCustomHeader headerWithRefreshingBlock:^{
            if (blockRefresh() != YMCollectionViewEndLoadTypeManualEnd) {
                [pSelf.mj_header endRefreshing];
            }
        }];
//        header.lastUpdatedTimeLabel.hidden = YES;
//        header.stateLabel.hidden = YES;
//        header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        /*
        header.gifView.contentMode = UIViewContentModeScaleAspectFit;
        
        [header setTitle:ymLocalize(@"_YM_PULL_DOWN_TO_REFRESH_", "下拉以刷新")
                forState:MJRefreshStateIdle];
        [header setTitle:ymLocalize(@"_YM_RELEASE_TO_REFRESH_", "松开刷新")
                forState:MJRefreshStatePulling];
        [header setTitle:ymLocalize(@"_YM_IS_REFRESHING_", "正在刷新")
                forState:MJRefreshStateRefreshing];
        [header setTitle:ymLocalize(@"_YM_RELEASE_TO_REFRESH_", "松开刷新")
                forState:MJRefreshStateWillRefresh];
        
        NSArray *array= [NSArray ymRefreshGifImageArray];
        [header setImages:array
                 forState:MJRefreshStateIdle];
        [header setImages:array
                 forState:MJRefreshStatePulling];
        [header setImages:array
                 forState:MJRefreshStateRefreshing];
         */
        
        pSelf.mj_header = header;
    });
    
    _YM_Safe_UI_Block_(blockLoadMore, ^{
        YMCustomFooter *footer = [YMCustomFooter footerWithRefreshingBlock:^{
            switch (blockLoadMore()) {
                case YMCollectionViewEndLoadTypeEnd:{
                    [pSelf.mj_footer endRefreshing];
                }break;
                case YMCollectionViewEndLoadTypeNoMoreData:{
                    [pSelf.mj_footer endRefreshingWithNoMoreData];
                }break;
                case YMCollectionViewEndLoadTypeManualEnd:{
                    
                }break;
                    
                default:{
                    [pSelf.mj_header endRefreshing];
                }break;
            }
        }];

        pSelf.mj_footer = footer;
    });
}

- (void) ymHeaderEndRefreshing {
    [self.mj_header endRefreshing];
}
- (void) ymFooterEndLoadMore {
    [self.mj_footer endRefreshing];
}

- (void) ymEndLoading {
    [self ymHeaderEndRefreshing];
    [self ymFooterEndLoadMore];
}
- (void) ymFooterEndLoadMoreWithNoMoreData {
    [self ymHeaderEndRefreshing];
    if ([self.mj_footer isKindOfClass:[MJRefreshAutoGifFooter class]]) {
        MJRefreshAutoGifFooter *footer = (MJRefreshAutoGifFooter *) self.mj_footer;
        footer.stateLabel.hidden = false;
    }
    [self.mj_footer endRefreshingWithNoMoreData];
}
- (void) ymResetLoadMoreStatus {
    if ([self.mj_footer isKindOfClass:[MJRefreshAutoGifFooter class]]) {
        MJRefreshAutoGifFooter *footer = (MJRefreshAutoGifFooter *) self.mj_footer;
        footer.stateLabel.hidden = false;
    }
    [self.mj_footer resetNoMoreData];
}

- (void) ymReloadData {
    _YM_UI_Operate_block(^{
        ymWeakSelf;
        [UIView setAnimationsEnabled:false];
        [self performBatchUpdates:^{
            [pSelf reloadSections:[NSIndexSet indexSetWithIndex:0]];
        } completion:^(BOOL finished) {
            [UIView setAnimationsEnabled:YES];
        }];
    });
}

@end
