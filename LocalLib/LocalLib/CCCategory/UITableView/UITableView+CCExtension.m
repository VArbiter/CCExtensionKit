//
//  UITableView+CCExtension.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/1.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "UITableView+CCExtension.h"
#import "UIImageView+CCExtension.h"

#import "CCCustomFooter.h"
#import "CCCustomHeader.h"

#import "CCCommonDefine.h"

@implementation UITableView (CCExtension)

+ (instancetype) ccInitWithFrame : (CGRect) rectFrame {
    return [self ccInitWithFrame:rectFrame withDelegateDataSource:nil];
}
+ (instancetype) ccInitWithFrame : (CGRect) rectFrame
          withDelegateDataSource : (id) delegateDataSource {
    return [self ccInitWithFrame:rectFrame
                       withStyle:UITableViewStylePlain
          withDelegateDataSource:delegateDataSource];
}
+ (instancetype) ccInitWithFrame : (CGRect) rectFrame
                    withDelegate : (id) delegate
                  withDataSource : (id) dataSource {
    return [self ccInitWithFrame:rectFrame
                       withStyle:UITableViewStylePlain
                    withDelegate:delegate
                  withDataSource:dataSource];
}
+ (instancetype) ccInitWithFrame : (CGRect) rectFrame
                       withStyle : (UITableViewStyle) style
          withDelegateDataSource : (id) delegateDataSource {
    return [self ccInitWithFrame:rectFrame
                       withStyle:style
                    withDelegate:delegateDataSource
                  withDataSource:delegateDataSource];
}

+ (instancetype) ccInitWithFrame : (CGRect) rectFrame
                       withStyle : (UITableViewStyle) style
                    withDelegate : (id) delegate
                  withDataSource : (id) dataSource  {
    UITableView *tableView  = [[UITableView alloc] initWithFrame:rectFrame
                                                           style:style];
    if (delegate) 
        tableView.delegate = delegate;
    if (dataSource)
        tableView.dataSource = dataSource;
    tableView.showsVerticalScrollIndicator = false;
    tableView.showsHorizontalScrollIndicator = false;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.bounces = YES;
    return tableView;
}

- (void) ccRegistNib : (NSString *) stringNib {
    [self registerNib:[UINib nibWithNibName:stringNib
                                    bundle:[NSBundle mainBundle]]
                     forCellReuseIdentifier:stringNib];
}
- (void) ccRegistClass : (NSString *) stringClazz{
    [self registerClass:NSClassFromString(stringClazz)
 forCellReuseIdentifier:stringClazz];
}

- (void) ccHeaderRefreshing : (CCTableViewEndLoadType(^)()) blockRefresh
          withFooterLoadMore: (CCTableViewEndLoadType(^)()) blockLoadMore {
    ccWeakSelf;
   _CC_Safe_UI_Block_(blockRefresh, ^{
       CCCustomHeader *header = [CCCustomHeader headerWithRefreshingBlock:^{
           if (blockRefresh() != CCTableViewEndLoadTypeManualEnd) {
               [pSelf.mj_header endRefreshing];
           }
       }];
       /*
       header.lastUpdatedTimeLabel.hidden = YES;
       header.stateLabel.hidden = YES;
       header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
       */
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
       
       pSelf.mj_header = header ;
   });
    
    _CC_Safe_UI_Block_(blockLoadMore, ^{
        CCCustomFooter *footer = [CCCustomFooter footerWithRefreshingBlock:^{
            switch (blockLoadMore()) {
                case CCTableViewEndLoadTypeEnd:{
                    [pSelf.mj_footer endRefreshing];
                }break;
                case CCTableViewEndLoadTypeNoMoreData:{
                    [pSelf.mj_footer endRefreshingWithNoMoreData];
                }break;
                case CCTableViewEndLoadTypeManualEnd:{
                    
                }break;
                    
                default:{
                    [pSelf.mj_header endRefreshing];
                }break;
            }
        }];
        
        pSelf.mj_footer = footer;
    });
}

- (void) ccUpdateing : (dispatch_block_t) block {
    [self beginUpdates];
    if (block) {
        block();
    }
    [self endUpdates];
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

@end
