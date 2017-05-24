//
//  UICollectionViewFlowLayout+YMExtension.m
//  ym_sell_ios
//
//  Created by 冯明庆 on 2017/4/1.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "UICollectionViewFlowLayout+YMExtension.h"

@implementation UICollectionViewFlowLayout (YMExtension)

+ (instancetype) ymCollectionLayoutWithItemSize : (CGSize) sizeItem {
    return [self ymCollectionLayoutWithItemSize:sizeItem
                               withSectionInset:UIEdgeInsetsZero
                                 withHeaderSize:CGSizeZero];
}

+ (instancetype) ymCollectionLayoutWithItemSize : (CGSize) sizeItem
                               withSectionInset : (UIEdgeInsets) edgeInsets {
    return [self ymCollectionLayoutWithItemSize:sizeItem
                               withSectionInset:edgeInsets
                                 withHeaderSize:CGSizeZero];
}

+ (instancetype) ymCollectionLayoutWithItemSize : (CGSize) sizeItem
                               withSectionInset : (UIEdgeInsets) edgeInsets
                                 withHeaderSize : (CGSize) sizeHeader {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = sizeItem;
    if (!UIEdgeInsetsEqualToEdgeInsets(edgeInsets, UIEdgeInsetsZero)) {
        layout.sectionInset = edgeInsets;
    }
    layout.sectionInset = edgeInsets;
    if (!CGSizeEqualToSize(sizeHeader, CGSizeZero)) {
        layout.headerReferenceSize = sizeHeader;
    }
    return layout;
}

@end

