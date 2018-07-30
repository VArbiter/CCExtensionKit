//
//  PHFetchResult+MQExtension.m
//  MQExtensionKit
//
//  Created by ElwinFrederick on 21/05/2018.
//  Copyright © 2018 冯明庆. All rights reserved.
//

#import "PHFetchResult+MQExtension.h"

@implementation PHFetchResult (CCExtension)

- (NSArray <PHAsset *> *) mq_filter_type : (PHAssetMediaType) type_media {
    
    if (self.count <= 0 ) return nil;
    NSMutableArray <PHAsset *> *array = [NSMutableArray array];
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (((PHAsset *)obj).mediaType == type_media) {
            [array addObject:obj];
        }
    }];
    return array;
}

- (NSArray *)array_results {
    
    if (self.count <= 0 ) return nil;
    NSMutableArray *array = [NSMutableArray array];
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [array addObject:obj];
    }];
    return array;
}

@end
