//
//  YMCollectionViewDelegateDataSource.h
//  ym_sell_ios
//
//  Created by 冯明庆 on 2017/4/22.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface YMCollectionViewDelegate : NSObject < UICollectionViewDelegate >

- (id < UICollectionViewDelegate >) initWithDefaultSettings ;

@property (nonatomic , copy) BOOL (^blockDidSelect)(UICollectionView *collectionView , NSIndexPath *indexPath) ;
@property (nonatomic , copy) void (^blockDidHightedCell)(UICollectionView *collectionView , NSIndexPath *indexPath) ;
@property (nonatomic , copy) void (^blockDidUnhigntedCell)(UICollectionView *collectionView , NSIndexPath *indexPath) ;
@property (nonatomic , copy) CGFloat (^blockMinimumLineSpacingInSection)(UICollectionView *collectionView , UICollectionViewLayout *layout , NSInteger integerSection) ;
@property (nonatomic , copy) CGFloat (^blockMinimumInteritemSpacingInSection)(UICollectionView *collectionView , UICollectionViewLayout *layout , NSInteger integerSection) ;
@property (nonatomic , copy) UIEdgeInsets (^blockSpacingBetweenSections)(UICollectionView *collectionView , UICollectionViewLayout *layout , NSInteger integerSection) ;
@end

#pragma mark - -----------------------------------------------------------------

@interface YMCollectionViewDataSource : NSObject < UICollectionViewDataSource >

- (id < UICollectionViewDataSource >) initWithDefaultSettings ;

@property (nonatomic , copy) NSInteger (^blockSections)(UICollectionView *collectionView) ;
@property (nonatomic , copy) NSInteger (^blockItemsInSections)(UICollectionView * collectionView , NSInteger integerSections) ;
@property (nonatomic , copy) NSString *(^blockCellIdentifier)(UICollectionView * collectionView , NSIndexPath * indexPath) ;
@property (nonatomic , copy) UICollectionViewCell *(^blockConfigCell)(UICollectionView * collectionView , UICollectionViewCell * cellConfig , NSIndexPath * indexPath);

@end
