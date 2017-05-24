//
//  UITableView+YMExtension.m
//  ym_sell_ios
//
//  Created by 冯明庆 on 2017/4/1.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "UITableView+YMExtension.h"
#import "UIImageView+YMExtension.h"

#import "YMCustomFooter.h"
#import "YMCustomHeader.h"

#import "YMCommonDefine.h"

@implementation UITableView (YMExtension)

+ (instancetype) ymInitWithFrame : (CGRect) rectFrame {
    return [self ymInitWithFrame:rectFrame withDelegateDataSource:nil];
}
+ (instancetype) ymInitWithFrame : (CGRect) rectFrame
          withDelegateDataSource : (id) delegateDataSource {
    return [self ymInitWithFrame:rectFrame
                       withStyle:UITableViewStylePlain
          withDelegateDataSource:delegateDataSource];
}
+ (instancetype) ymInitWithFrame : (CGRect) rectFrame
                    withDelegate : (id) delegate
                  withDataSource : (id) dataSource {
    return [self ymInitWithFrame:rectFrame
                       withStyle:UITableViewStylePlain
                    withDelegate:delegate
                  withDataSource:dataSource];
}
+ (instancetype) ymInitWithFrame : (CGRect) rectFrame
                       withStyle : (UITableViewStyle) style
          withDelegateDataSource : (id) delegateDataSource {
    return [self ymInitWithFrame:rectFrame
                       withStyle:style
                    withDelegate:delegateDataSource
                  withDataSource:delegateDataSource];
}

+ (instancetype) ymInitWithFrame : (CGRect) rectFrame
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

- (void) ymRegistNib : (NSString *) stringNib {
    [self registerNib:[UINib nibWithNibName:stringNib
                                    bundle:[NSBundle mainBundle]]
                     forCellReuseIdentifier:stringNib];
}
- (void) ymRegistClass : (NSString *) stringClazz{
    [self registerClass:NSClassFromString(stringClazz)
 forCellReuseIdentifier:stringClazz];
}

- (void) ymHeaderRefreshing : (YMTableViewEndLoadType(^)()) blockRefresh
          withFooterLoadMore: (YMTableViewEndLoadType(^)()) blockLoadMore {
    ymWeakSelf;
   _YM_Safe_UI_Block_(blockRefresh, ^{
       YMCustomHeader *header = [YMCustomHeader headerWithRefreshingBlock:^{
           if (blockRefresh() != YMTableViewEndLoadTypeManualEnd) {
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
       
       pSelf.mj_header = header ;
   });
    
    _YM_Safe_UI_Block_(blockLoadMore, ^{
        YMCustomFooter *footer = [YMCustomFooter footerWithRefreshingBlock:^{
            switch (blockLoadMore()) {
                case YMTableViewEndLoadTypeEnd:{
                    [pSelf.mj_footer endRefreshing];
                }break;
                case YMTableViewEndLoadTypeNoMoreData:{
                    [pSelf.mj_footer endRefreshingWithNoMoreData];
                }break;
                case YMTableViewEndLoadTypeManualEnd:{
                    
                }break;
                    
                default:{
                    [pSelf.mj_header endRefreshing];
                }break;
            }
        }];
        
        pSelf.mj_footer = footer;
    });
}

- (void) ymUpdateing : (dispatch_block_t) block {
    [self beginUpdates];
    if (block) {
        block();
    }
    [self endUpdates];
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

@end
