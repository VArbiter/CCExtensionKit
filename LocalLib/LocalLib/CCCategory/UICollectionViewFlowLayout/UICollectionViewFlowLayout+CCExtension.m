//
//  UICollectionViewFlowLayout+CCExtension.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/1.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "UICollectionViewFlowLayout+CCExtension.h"

@implementation UICollectionViewFlowLayout (CCExtension)

+ (instancetype) ccCollectionLayoutWithItemSize : (CGSize) sizeItem {
    return [self ccCollectionLayoutWithItemSize:sizeItem
                               withSectionInset:UIEdgeInsetsZero
                                 withHeaderSize:CGSizeZero];
}

+ (instancetype) ccCollectionLayoutWithItemSize : (CGSize) sizeItem
                               withSectionInset : (UIEdgeInsets) edgeInsets {
    return [self ccCollectionLayoutWithItemSize:sizeItem
                               withSectionInset:edgeInsets
                                 withHeaderSize:CGSizeZero];
}

+ (instancetype) ccCollectionLayoutWithItemSize : (CGSize) sizeItem
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

