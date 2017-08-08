//
//  UICollectionView+CCChain.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 08/08/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+CCChain.h"

@interface UICollectionView (CCChain)

@property (nonatomic , class , copy , readonly) UICollectionView *(^commonS)(CCRect frame, UICollectionViewFlowLayout *layout);
@property (nonatomic , class , copy , readonly) UICollectionView *(^commonC)(CGRect frame, UICollectionViewFlowLayout *layout);

@property (nonatomic , copy , readonly) UICollectionView *(^delegateT)(id delegate);
@property (nonatomic , copy , readonly) UICollectionView *(^dataSourceT)(id dataSource);

/// requires that nib name is equal to cell's idetifier .
@property (nonatomic , copy , readonly) UICollectionView *(^registN)(NSString *sNib , NSBundle *bundle);
/// requires that class name is equal to cell's idetifier .
@property (nonatomic , copy , readonly) UICollectionView *(^registC)(Class clazz);

/// for non-animated , only section 0 was available.
@property (nonatomic , copy , readonly) UICollectionView *(^reload)(BOOL animated);
@property (nonatomic , copy , readonly) UICollectionView *(^reloadS)(NSIndexSet *set , BOOL animated);
@property (nonatomic , copy , readonly) UICollectionView *(^reloadI)(NSArray <NSIndexPath *> *array);

@end

#pragma mark - -----

@interface UICollectionViewFlowLayout (CCChain)

@property (nonatomic , class , copy , readonly) UICollectionViewFlowLayout *(^common)();

/// for default sizes
@property (nonatomic , copy , readonly) UICollectionViewFlowLayout *(^itemSizeS)(CCSize size);
@property (nonatomic , copy , readonly) UICollectionViewFlowLayout *(^itemSizeC)(CGSize size);
@property (nonatomic , copy , readonly) UICollectionViewFlowLayout *(^sectionInsetS)(CCEdgeInsets insets);
@property (nonatomic , copy , readonly) UICollectionViewFlowLayout *(^sectionInsetC)(UIEdgeInsets insets);
@property (nonatomic , copy , readonly) UICollectionViewFlowLayout *(^headerSizeS)(CCSize insets);
@property (nonatomic , copy , readonly) UICollectionViewFlowLayout *(^headerSizeC)(CGSize insets);

@end
