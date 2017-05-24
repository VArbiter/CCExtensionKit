//
//  YMTableViewDelegateDataSource.h
//  ym_sell_ios
//
//  Created by 冯明庆 on 2017/4/22.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface YMTableViewDelegate : NSObject < UITableViewDelegate >

- (id < UITableViewDelegate >) initWithDefaultSettings ;

@property (nonatomic , copy) CGFloat (^blockCellHeight)(UITableView * tableView , NSIndexPath *indexPath) ;
@property (nonatomic , copy) CGFloat (^blockSectionHeaderHeight)(UITableView * tableView , NSInteger integerSection) ;
@property (nonatomic , copy) UIView *(^blockSectionHeader)(UITableView *tableView , NSInteger integerSection) ;
@property (nonatomic , copy) BOOL (^blockDidSelect)(UITableView *tableView , NSIndexPath *indexPath) ;

@end

#pragma mark - -----------------------------------------------------------------

@interface YMTableViewDataSource : NSObject < UITableViewDataSource >

- (id < UITableViewDataSource >) initWithDefaultSettings ;

@property (nonatomic , copy) NSInteger (^blockSections)(UITableView *tableView);
@property (nonatomic , copy) NSInteger (^blockRowsInSections)(UITableView * tableView , NSInteger integerSection);
@property (nonatomic , copy) NSString * (^blockCellIdentifier)(UITableView *tableView , NSIndexPath *indexPath) ;
@property (nonatomic , copy) UITableViewCell * (^blockConfigCell)(UITableView *tableView , UITableViewCell *cellConfig , NSIndexPath *indexPath) ;

@end
