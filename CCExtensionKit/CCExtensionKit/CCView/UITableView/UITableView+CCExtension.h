//
//  UITableView+CCExtension.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/1.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (CCExtension)

/// default plain.
+ (instancetype) common : (CGRect) frame ;
+ (instancetype) common : (CGRect) frame
                  style : (UITableViewStyle) style ;

- (instancetype) ccDelegateT : (id) delegate ;
- (instancetype) ccDataSourceT : (id) dataSource ;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
/// data source that pre-fetching
- (instancetype) ccPrefetchingT : (id) prefetch ;
#endif

/// requires that nib name is equal to cell's idetifier .
/// default main bundle
- (instancetype) ccRegistNib : (NSString *) sNib ;
- (instancetype) ccRegistNib : (NSString *) sNib
                      bundle : (NSBundle *) bundle ;
/// requires that class name is equal to cell's idetifier .
- (instancetype) ccRegistCls : (Class) cls ;

/// default main bundle
- (instancetype) ccRegistHeaderFooterNib : (NSString *) sNib ;
- (instancetype) ccRegistHeaderFooterNib : (NSString *) sNib
                                  bundle : (NSBundle *) bundle ;
- (instancetype) ccRegistHeaderFooterCls : (Class) cls ;

/// wrapper of "beginUpdates" && "endUpdates"
- (instancetype) ccUpdating : (void (^)()) updating ;

/// for non-animated , only section 0 was available.
/// note : UITableViewRowAnimationNone means reloading without hidden animations .
/// note : if animated is set to -1 , equals to reloadData.
/// note : if reloeded muti sections , using "ccReloadSectionsT:animate:" down below
- (instancetype) ccReloading : (UITableViewRowAnimation) animation ;
- (instancetype) ccReloadSectionsT : (NSIndexSet *) set
                           animate : (UITableViewRowAnimation) animation ;
- (instancetype) ccReloadItemsT : (NSArray <NSIndexPath *> *) array
                        animate : (UITableViewRowAnimation) animation ;

- (__kindof UITableViewCell *) ccDeqCell : (NSString *) sIdentifier ;
/// for cell that register in tableView
- (__kindof UITableViewCell *) ccDeqCell : (NSString *) sIdentifier
                               indexPath : (NSIndexPath *) indexPath ;
- (__kindof UITableViewHeaderFooterView *) ccDeqReusableView : (NSString *) sIdentifier ;

@end
#warning TODO >>>
#pragma mark - CCTableViewDelegate ---------------------------------------------

@interface CCTableViewDelegate : NSObject < UITableViewDelegate >

- (id < UITableViewDelegate > ) init ;

@property (nonatomic , copy) CGFloat (^blockCellHeight)(UITableView * tableView , NSIndexPath *indexPath) ;
@property (nonatomic , copy) CGFloat (^blockSectionHeaderHeight)(UITableView * tableView , NSInteger integerSection) ;
@property (nonatomic , copy) UIView *(^blockSectionHeader)(UITableView *tableView , NSInteger integerSection) ;
@property (nonatomic , copy) CGFloat (^blockSectionFooterHeight)(UITableView * tableView , NSInteger integerSection) ;
@property (nonatomic , copy) UIView *(^blockSectionFooter)(UITableView *tableView , NSInteger integerSection) ;
@property (nonatomic , copy) BOOL (^blockDidSelect)(UITableView *tableView , NSIndexPath *indexPath) ;

@end

#pragma mark - CCTableViewDataSource -------------------------------------------

@interface CCTableViewDataSource : NSObject < UITableViewDataSource >

- (id < UITableViewDataSource >) init ;

@property (nonatomic , copy) NSInteger (^blockSections)(UITableView *tableView);
@property (nonatomic , copy) NSInteger (^blockRowsInSections)(UITableView * tableView , NSInteger integerSection);
@property (nonatomic , copy) NSString * (^blockCellIdentifier)(UITableView *tableView , NSIndexPath *indexPath) ;
@property (nonatomic , copy) UITableViewCell * (^blockConfigCell)(UITableView *tableView , UITableViewCell *cellConfig , NSIndexPath *indexPath) ;

@end
