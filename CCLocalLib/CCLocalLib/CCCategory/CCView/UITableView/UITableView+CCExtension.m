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

#import "CCCommonTools.h"

@implementation UITableView (CCExtension)

+ (instancetype) ccCommon : (CGRect) rectFrame {
    return [self ccCommon:rectFrame
            delegateDataSource:nil];
}
+ (instancetype) ccCommon : (CGRect) rectFrame
       delegateDataSource : (id) delegateDataSource {
    return [self ccCommon:rectFrame
                    style:UITableViewStylePlain
       delegateDataSource:delegateDataSource];
}
+ (instancetype) ccCommon : (CGRect) rectFrame
                 delegate : (id) delegate
               dataSource : (id) dataSource {
    return [self ccCommon:rectFrame
                    style:UITableViewStylePlain
                 delegate:delegate
               dataSource:dataSource];
}
+ (instancetype) ccCommon : (CGRect) rectFrame
                    style : (UITableViewStyle) style
       delegateDataSource : (id) delegateDataSource {
    return [self ccCommon:rectFrame
                    style:style
                 delegate:delegateDataSource
               dataSource:delegateDataSource];
}

+ (instancetype) ccCommon : (CGRect) rectFrame
                    style : (UITableViewStyle) style
                 delegate : (id) delegate
               dataSource : (id) dataSource  {
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

- (void) ccHeaderRefreshing : (CCEndLoadType(^)()) blockRefresh
             footerLoadMore : (CCEndLoadType(^)()) blockLoadMore {
    ccWeakSelf;
    CC_Safe_UI_Operation(blockRefresh, ^{
       CCCustomHeader *header = [CCCustomHeader headerWithRefreshingBlock:^{
           if (blockRefresh() != CCEndLoadTypeManualEnd) {
               [pSelf.mj_header endRefreshing];
           }
       }];
       
       pSelf.mj_header = header ;
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
- (void) ccFooterEndLoadNoMoreData {
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

#pragma mark - CCTableViewDelegate ---------------------------------------------

@implementation CCTableViewDelegate

- (id < UITableViewDelegate >) init {
    if ((self = [super init])) {
        return self;
    }
    return self;
}

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

_CC_DETECT_DEALLOC_

@end

#pragma mark - CCTableViewDataSource -------------------------------------------

@implementation CCTableViewDataSource

- (id < UITableViewDataSource >) init {
    if ((self = [super init])) {
        return self;
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.blockSections ? self.blockSections(tableView) : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.blockRowsInSections ? self.blockRowsInSections(tableView , section) : 0 ;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *stringCellIdentifer = self.blockCellIdentifier ? self.blockCellIdentifier(tableView , indexPath) : @"CELL";
    
    UITableViewCell *cell = nil;
    if (self.blockCellIdentifier) {
        cell = [tableView dequeueReusableCellWithIdentifier:stringCellIdentifer
                                               forIndexPath:indexPath];
        
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:stringCellIdentifer];
    }
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:stringCellIdentifer];
    }
    
    return self.blockConfigCell ? self.blockConfigCell(tableView , cell , indexPath) : cell;
}

_CC_DETECT_DEALLOC_

@end

