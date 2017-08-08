//
//  UICollectionView+CCChain.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 08/08/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "UICollectionView+CCChain.h"

@implementation UICollectionView (CCChain)

+ (UICollectionView *(^)(CCRect, UICollectionViewFlowLayout *))commonS {
    return ^UICollectionView *(CCRect r, UICollectionViewFlowLayout *l) {
        return self.commonC(CGMakeRectFrom(r), l);
    };
}

+ (UICollectionView *(^)(CGRect, UICollectionViewFlowLayout *))commonC {
    return ^UICollectionView *(CGRect r , UICollectionViewFlowLayout *l) {
        UICollectionView *c = [[UICollectionView alloc] initWithFrame:r
                                                 collectionViewLayout:l];
        c.backgroundColor = UIColor.clearColor;
        c.showsVerticalScrollIndicator = false;
        c.showsHorizontalScrollIndicator = false;
        return c;
    };
}

- (UICollectionView *(^)(id))delegateT {
    __weak typeof(self) pSelf = self;
    return ^UICollectionView *(id v) {
        if (v) pSelf.delegate = v;
        return pSelf;
    };
}

- (UICollectionView *(^)(id))dataSourceT {
    __weak typeof(self) pSelf = self;
    return ^UICollectionView *(id v) {
        if (v) pSelf.dataSource = v;
        return pSelf;
    };
}

- (UICollectionView *(^)(NSString *, NSBundle *))registN {
    __weak typeof(self) pSelf = self;
    return ^UICollectionView *(NSString *s , NSBundle *b) {
        if (!b) b = NSBundle.mainBundle;
        [pSelf registerNib:[UINib nibWithNibName:s
                                          bundle:b]
forCellWithReuseIdentifier:s];
        return pSelf;
    };
}

- (UICollectionView *(^)(__unsafe_unretained Class))registC {
    __weak typeof(self) pSelf = self;
    return ^UICollectionView *(Class c) {
        [pSelf registerClass:c
  forCellWithReuseIdentifier:NSStringFromClass(c)];
        return pSelf;
    };
}

- (UICollectionView *(^)(BOOL))reload {
    __weak typeof(self) pSelf = self;
    return ^UICollectionView *(BOOL b) {
        if (b) {
            pSelf.reloadS([NSIndexSet indexSetWithIndex:0], b);
        } else [pSelf reloadData];
        return pSelf;
    };
}

- (UICollectionView *(^)(NSIndexSet *, BOOL))reloadS {
    __weak typeof(self) pSelf = self;
    return ^UICollectionView *(NSIndexSet *s , BOOL b) {
        if (b) {
            [pSelf reloadSections:s];
        } else {
            void (^t)() = ^ {
                [UIView setAnimationsEnabled:false];
                [pSelf performBatchUpdates:^{
                    [pSelf reloadSections:s];
                } completion:^(BOOL finished) {
                    [UIView setAnimationsEnabled:YES];
                }];
            };
            if (NSThread.isMainThread) t();
            else dispatch_sync(dispatch_get_main_queue(), ^{
                t();
            });
        }
        return pSelf;
    };
}

- (UICollectionView *(^)(NSArray<NSIndexPath *> *))reloadI {
    __weak typeof(self) pSelf = self;
    return ^UICollectionView *(NSArray<NSIndexPath *> *a) {
        [pSelf reloadItemsAtIndexPaths:(a ? a : @[])];
        return pSelf;
    };
}

@end

#pragma mark - -----

@implementation UICollectionViewFlowLayout (CCChain)

+ (UICollectionViewFlowLayout *(^)())common {
    return ^UICollectionViewFlowLayout * {
        return UICollectionViewFlowLayout.alloc.init;
    };
}

- (UICollectionViewFlowLayout *(^)(CCSize))itemSizeS {
    __weak typeof(self) pSelf = self;
    return ^UICollectionViewFlowLayout *(CCSize s) {
        return pSelf.itemSizeC(CGMakeSizeFrom(s));
    };
}
- (UICollectionViewFlowLayout *(^)(CGSize))itemSizeC {
    __weak typeof(self) pSelf = self;
    return ^UICollectionViewFlowLayout *(CGSize s) {
        pSelf.itemSize = s;
        return pSelf;
    };
}

- (UICollectionViewFlowLayout *(^)(CCEdgeInsets))sectionInsetS {
    __weak typeof(self) pSelf = self;
    return ^UICollectionViewFlowLayout *(CCEdgeInsets s) {
        return pSelf.sectionInsetC(UIMakeEdgeInsetsFrom(s));
    };
}
- (UICollectionViewFlowLayout *(^)(UIEdgeInsets))sectionInsetC {
    __weak typeof(self) pSelf = self;
    return ^UICollectionViewFlowLayout *(UIEdgeInsets s) {
        pSelf.sectionInset = s;
        return pSelf;
    };
}

- (UICollectionViewFlowLayout *(^)(CCSize))headerSizeS{
    __weak typeof(self) pSelf = self;
    return ^UICollectionViewFlowLayout *(CCSize s) {
        return pSelf.headerSizeC(CGMakeSizeFrom(s));
    };
}
- (UICollectionViewFlowLayout *(^)(CGSize))headerSizeC {
    __weak typeof(self) pSelf = self;
    return ^UICollectionViewFlowLayout *(CGSize s) {
        pSelf.headerReferenceSize = s;
        return pSelf;
    };
}
@end
