//
//  UICollectionViewFlowLayout+CCExtension.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/1.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionViewFlowLayout (CCExtension)

+ (instancetype) ccCollectionLayoutWithItemSize : (CGSize) sizeItem ;

+ (instancetype) ccCollectionLayoutWithItemSize : (CGSize) sizeItem
                               withSectionInset : (UIEdgeInsets) edgeInsets ;

+ (instancetype) ccCollectionLayoutWithItemSize : (CGSize) sizeItem
                               withSectionInset : (UIEdgeInsets) edgeInsets
                                 withHeaderSize : (CGSize) sizeHeader ;

@end
