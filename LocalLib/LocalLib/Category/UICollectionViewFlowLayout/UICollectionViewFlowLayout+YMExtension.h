//
//  UICollectionViewFlowLayout+YMExtension.h
//  ym_sell_ios
//
//  Created by 冯明庆 on 2017/4/1.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionViewFlowLayout (YMExtension)

+ (instancetype) ymCollectionLayoutWithItemSize : (CGSize) sizeItem ;

+ (instancetype) ymCollectionLayoutWithItemSize : (CGSize) sizeItem
                               withSectionInset : (UIEdgeInsets) edgeInsets ;

+ (instancetype) ymCollectionLayoutWithItemSize : (CGSize) sizeItem
                               withSectionInset : (UIEdgeInsets) edgeInsets
                                 withHeaderSize : (CGSize) sizeHeader ;

@end
