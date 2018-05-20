//
//  CCPhotoManager.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2018/5/20.
//  Copyright © 2018 冯明庆. All rights reserved.
//

#import "CCPhotoManager.h"

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0

@interface CCPhotoManager ()

@end

@implementation CCPhotoManager

@end

#else

@interface CCPhotoManager ()

@property (nonatomic , strong , readwrite) ALAssetsLibrary * assets_library;

@property (nonatomic , strong , readwrite) NSMutableArray <ALAssetsGroup *> * array_groups_image;
@property (nonatomic , strong , readwrite) NSMutableArray <ALAssetsGroup *> * array_groups_videos;

@end

@implementation CCPhotoManager

- (void) cc_create_photo_library : (NSString *) s_title
                        complete : (void (^)(ALAssetsGroup *group , NSError *error)) block_create {
    [self.assets_library addAssetsGroupAlbumWithName:s_title resultBlock:^(ALAssetsGroup *group) {
        if (block_create) block_create(group , nil);
    } failureBlock:^(NSError *error) {
        if (block_create) block_create(nil , error);
    }];
}

- (void) cc_get_all_photo_groups : (void(^)(NSArray <ALAssetsGroup *> *array_group
                                            , NSError *error)) block_group {
    [_array_groups_image removeAllObjects];
    
    __weak typeof(self) weak_self = self;
    [self.assets_library enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            [weak_self.array_groups_image addObject:group];
        }
        if (block_group) block_group([NSArray arrayWithArray:weak_self.array_groups_image] , nil);
    } failureBlock:^(NSError *error) {
        if (block_group) block_group(nil,error);
    }];
}

- (void) cc_get_all_video_groups : (void(^)(NSArray <ALAssetsGroup *> *array_group
                                            , NSError *error)) block_group {
    [_array_groups_videos removeAllObjects];
    __weak typeof(self) weak_self = self;
    [self.assets_library enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            [group setAssetsFilter:[ALAssetsFilter allVideos]];
            [weak_self.array_groups_videos addObject:group];
        }
        if (block_group) block_group([NSArray arrayWithArray:weak_self.array_groups_videos] , nil);
    } failureBlock:^(NSError *error) {
        if (block_group) block_group(nil,error);
    }];
}

- (void) cc_open_group : (ALAssetsGroup *) group
                photos : (void (^)(NSArray <ALAsset *> * group
                                   , NSError *error)) block_images ; {
    NSMutableArray *array = [NSMutableArray array];
    NSURL * url = [group valueForProperty:ALAssetsGroupPropertyURL];
    [self.assets_library groupForURL:url resultBlock:^(ALAssetsGroup *group) {
        
        [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if (!result
                && ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]
                    || [[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo])) {
                    
                    [array addObject:result];
                }
        }];
        block_images(array , nil);
        
    } failureBlock:^(NSError *error) {
        if (block_images)  block_images(nil , error);
    }];
}

- (ALAssetsLibrary *)assets_library {
    if (_assets_library) return _assets_library;
    ALAssetsLibrary *t = [[ALAssetsLibrary alloc] init];
    _assets_library = t;
    return _assets_library;
}

- (NSMutableArray<ALAssetsGroup *> *)array_groups_videos {
    if (_array_groups_videos) return _array_groups_videos;
    NSMutableArray *t = [NSMutableArray array];
    _array_groups_videos = t;
    return _array_groups_videos;
}

- (NSMutableArray<ALAssetsGroup *> *)array_groups_image {
    if (_array_groups_image) return _array_groups_image;
    NSMutableArray *t = [NSMutableArray array];
    _array_groups_image = t;
    return _array_groups_image;
}

@end

#endif
