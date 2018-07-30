//
//  CCPhotoManager.m
//  MQExtensionKit
//
//  Created by 冯明庆 on 2018/5/20.
//  Copyright © 2018 冯明庆. All rights reserved.
//

#import "CCPhotoManager.h"

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0

@interface CCPhotoManager () < PHPhotoLibraryChangeObserver >

@property (nonatomic , assign) CGSize size_image ;
@property (nonatomic , assign) BOOL is_image ;

@property (nonatomic , strong , readwrite) NSMutableArray <PHAsset *> *array_assests ;

@end

@implementation CCPhotoManager

NSString * mq_photo_manger_image_key = @"image";
NSString * mq_photo_manger_info_key = @"info";
NSString * mq_photo_manger_video_key = @"video";
NSString * mq_photo_manger_unknow_key = @"unknow";

NSString * mq_photo_manger_type_key = @"type" ;
NSString * mq_photo_manger_asset_key = @"asset" ;

- (instancetype) init_image_size : (CGSize) size
                            type : (BOOL) is_image {
    if ((self = [super init])) {
        self.size_image = size ;
        self.is_image = is_image;
        [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
        self.is_ascending = false;
        self.i_page_size = -1;
        self.i_page_size = -1;
    }
    return self;
}

- (void)setI_page_size:(NSInteger)i_page_size {
    _i_page_size = i_page_size < 0 ? NSIntegerMax : i_page_size;
}
- (void)setI_limit_size:(NSInteger)i_limit_size {
    _i_limit_size = i_limit_size < 0 ? NSIntegerMax : i_limit_size;
}

+ (BOOL) mq_has_authorize {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted ||
        status == PHAuthorizationStatusDenied) {
        return false;
    }
    return YES;
}

- (NSMutableArray <PHAsset *> *) mq_get_all_asset_in_album : (BOOL) is_ascending {
    NSMutableArray <PHAsset *> *assets = [NSMutableArray array];
    
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate"
                                                             ascending:is_ascending]];
    
    __block NSInteger i_count = 0;
    __weak typeof(self) pSelf = self;
    
    if (self.is_image) {
        PHFetchResult *result_image = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage
                                                                options:option];
        [result_image enumerateObjectsUsingBlock:^(id  _Nonnull obj,
                                                   NSUInteger idx,
                                                   BOOL * _Nonnull stop) {
            if (++ i_count >= pSelf.i_limit_size) return ;
            
            PHAsset *asset = (PHAsset *)obj;
            [assets addObject:asset];
        }];
    }
    else {
        PHFetchResult *result_video = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeVideo
                                                                options:option];
        [result_video enumerateObjectsUsingBlock:^(id  _Nonnull obj,
                                                   NSUInteger idx,
                                                   BOOL * _Nonnull stop) {
            if (++ i_count >= pSelf.i_limit_size) return ;
            
            PHAsset *asset = (PHAsset *)obj;
            [assets addObject:asset];
        }];
    }
    
    return assets;
}

- (NSMutableArray <NSDictionary *> *) mq_get_images_page : (NSInteger) i_page {
    
    NSArray <PHAsset *> *array_temp = nil;
    if (i_page < 0 || self.i_page_size <= 0) {
        array_temp = self.array_assests;
    }
    else {
        i_page = (i_page - 1) < 0 ? 0 : i_page - 1 ;
        NSInteger i_location = i_page * self.i_page_size,
        i_length = self.i_page_size,
        i_count = self.i_page_size - 1;
        if (i_location + i_count >= self.array_assests.count - 1) { // array bounds
            i_length = self.array_assests.count - i_location;
        }
        array_temp = [self.array_assests subarrayWithRange:(NSRange){i_page,i_length}];
    }
    
    NSMutableArray *array_images = [NSMutableArray array];
    PHImageRequestOptions *option = nil;
    if (!self.request_options) {
        option = [[PHImageRequestOptions alloc] init];
        option.resizeMode = PHImageRequestOptionsResizeModeFast;
        option.networkAccessAllowed = YES;
    }
    else {
        option = self.request_options;
    }
    
    __weak typeof(self) pSelf = self;
    [array_temp enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj,
                                                  NSUInteger idx,
                                                  BOOL * _Nonnull stop) {
        NSString *s_type = nil;
        if (obj.mediaType == PHAssetMediaTypeImage) {
            s_type = mq_photo_manger_image_key;
        }
        else if (obj.mediaType == PHAssetMediaTypeVideo){
            s_type = mq_photo_manger_video_key;
        }
        else s_type = mq_photo_manger_unknow_key;
        
        NSMutableDictionary *dict_info = [NSMutableDictionary dictionary];
        [dict_info setValue:s_type forKey:mq_photo_manger_type_key];
        [dict_info setValue:obj forKey:mq_photo_manger_asset_key];
        
        __block BOOL is_need_added = YES;
        
        [[PHCachingImageManager defaultManager] requestImageForAsset:obj
                                                          targetSize:pSelf.size_image
                                                         contentMode:PHImageContentModeAspectFit
                                                             options:option
                                                       resultHandler:^(UIImage * _Nullable image,
                                                                       NSDictionary * _Nullable info) {
                                                           
               if (image) {
                   [dict_info setValue:image forKey:mq_photo_manger_image_key];
                   [dict_info setValue:info forKey:mq_photo_manger_info_key];
               } else {
                   is_need_added = false;
               }
           }];
        
        if (is_need_added) {
            [array_images addObject:dict_info];
        }
    }];
    
    return array_images;
}

- (void) mq_get_image_data : (PHAsset *) asset
                  complete : (void(^)(NSData *image_data ,
                                      BOOL is_can_be_used)) mq_complete_block {
    [[PHCachingImageManager defaultManager] requestImageDataForAsset:asset
                                                             options:nil
                                                       resultHandler:^(NSData * _Nullable imageData,
                                                                       NSString * _Nullable dataUTI,
                                                                       UIImageOrientation orientation,
                                                                       NSDictionary * _Nullable info) {
           if (imageData) {
               UIImage *t_image = [UIImage imageWithData:imageData].mq_fix_orientation;
               NSData *data_new_image = UIImageJPEGRepresentation(t_image, .5f);
               if (data_new_image) {
                   
                   if ([NSThread isMainThread]) {
                       if (mq_complete_block) mq_complete_block(data_new_image , YES);
                   }
                   else dispatch_sync(dispatch_get_main_queue(), ^{
                       if (mq_complete_block) mq_complete_block(data_new_image , YES);
                   });
               }
               else if (mq_complete_block) mq_complete_block(nil , false);
           }
           else if (mq_complete_block) mq_complete_block(nil , false);
       }];
}

- (void) mq_get_video_url :  (PHAsset *) asset
                 duration : (void(^)(NSString *s_time , NSTimeInterval duration)) mq_duration_block
                 complete : (void(^)(NSURL *url_video , BOOL is_can_be_used , BOOL is_off_limit_times)) mq_complete_block {
    if (asset.mediaType != PHAssetMediaTypeVideo) {
        if (mq_complete_block) mq_complete_block(nil , false , YES);
        return;
    }
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    options.version = PHImageRequestOptionsVersionCurrent;
    options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
    
    PHImageManager *manager = [PHImageManager defaultManager];
    [manager requestAVAssetForVideo:asset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
        
        AVURLAsset *url_asset = (AVURLAsset *)asset;
        NSTimeInterval f_time_seconds = url_asset.duration.value / url_asset.duration.timescale ;
        
        if (mq_duration_block) {
            NSString *s_time = [NSString stringWithFormat:@"%02ld:%02ld"
                                ,(NSUInteger)(f_time_seconds / 60)
                                ,((NSUInteger)f_time_seconds % 60)];
            mq_duration_block(s_time , f_time_seconds);
        }
        
        if (mq_complete_block) {
            BOOL is_off_limit_times = f_time_seconds > 60.f;
            mq_complete_block(url_asset.URL, YES , is_off_limit_times);
        }
        
    }];
}

#pragma mark - -----
- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    if (self.delegate_t
        && [self.delegate_t respondsToSelector:@selector(mq_photo_manager:change:)]) {
        [self.delegate_t mq_photo_manager:self change:changeInstance];
    }
}

#pragma mark - -----

- (NSMutableArray<PHAsset *> *)array_assests {
    if (_array_assests) return _array_assests;
    _array_assests = [self mq_get_all_asset_in_album:self.is_ascending];
    return _array_assests;
}

@end

#else

@interface CCPhotoManager ()

@property (nonatomic , strong , readwrite) ALAssetsLibrary * assets_library;

@property (nonatomic , strong , readwrite) NSMutableArray <ALAssetsGroup *> * array_groups_image;
@property (nonatomic , strong , readwrite) NSMutableArray <ALAssetsGroup *> * array_groups_videos;

@end

@implementation CCPhotoManager

- (void) mq_create_photo_library : (NSString *) s_title
                        complete : (void (^)(ALAssetsGroup *group , NSError *error)) block_create {
    [self.assets_library addAssetsGroupAlbumWithName:s_title resultBlock:^(ALAssetsGroup *group) {
        if (block_create) block_create(group , nil);
    } failureBlock:^(NSError *error) {
        if (block_create) block_create(nil , error);
    }];
}

- (void) mq_get_all_photo_groups : (void(^)(NSArray <ALAssetsGroup *> *array_group
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

- (void) mq_get_all_video_groups : (void(^)(NSArray <ALAssetsGroup *> *array_group
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

- (void) mq_open_group : (ALAssetsGroup *) group
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
