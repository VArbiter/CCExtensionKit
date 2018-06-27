//
//  CCPhotoManager.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2018/5/20.
//  Copyright © 2018 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0

#import "PHAsset+CCExtension.h"

@import Photos;

@class CCPhotoManager;

@protocol CCPhotoManagerDelegate < NSObject >

@required

/// notify when delete or add a new image / video . // 当 删除 / 添加 新的 图片 / 视频 时通知.
- (void) cc_photo_manager : (CCPhotoManager *) manager
                   change : (PHChange *) change_instance ;

@end

@interface CCPhotoManager : NSObject

- (instancetype) init_image_size : (CGSize) size
                            type : (BOOL) is_image;
@property (nonatomic , assign) id <CCPhotoManagerDelegate> delegate_t ;

/// photos is ascending or not . // 照片是否升序排列 .
@property (nonatomic , assign) BOOL is_ascending ;

/// return the count of a collections unit . -1 for all (default) . // 返回集合中元素的个数 , -1 返回所有 , 默认 .
@property (nonatomic , assign) NSInteger i_limit_size ;

/// -1 for no pages (default) . limit the page size ; // -1 返回全部 (默认 , 没有分页) , 页面容积 .
@property (nonatomic , assign) NSInteger i_page_size ;

/// mode for resize images . // 重新压缩尺寸大小
@property (nonatomic , assign) PHImageRequestOptionsResizeMode resize_mode ;

/// options for requesting photo . // 请求照片的选择项
@property (nonatomic , strong) PHImageRequestOptions *request_options ;

/// if has the authorization to album . // 是否拥有访问相册的权限
+ (BOOL) cc_has_authorize ;

/// get all asset in album . // 获得相册中所有 PHAsset 的实例
/// is_ascending . YES ascending , NO decending . // YES 正序 , NO 逆序
- (NSMutableArray <PHAsset *> *) cc_get_all_asset_in_album : (BOOL) is_ascending ;
@property (nonatomic , strong , readonly) NSMutableArray <PHAsset *> *array_assests ;

/// loading in pages . // 分页加载
/// NSDictionary contains (@"image" : UIImage *, @"info" : NSDictionary *) .
/// i_page give -1 to get all images . start with "0" (not recommended to give -1 , if library images are too many . it might cause some glitches . )
/// 给 -1 获得 所有的图片 , 从 0 开始 (不推荐给 -1 , 如果图库中的图片太多 , 可能导致 错误)
- (NSMutableArray <NSDictionary <NSString * , id> *> *) cc_get_images_page : (NSInteger) i_page ;

/// get image data for specific asset .// 根据 asset 获得特定 的图片数据
- (void) cc_get_image_data : (PHAsset *) asset
                  complete : (void(^)(NSData *image_data , BOOL is_can_be_used)) cc_complete_block ;

/// get video url data for specific asset .// 根据 asset 获得特定 的视频数据
- (void) cc_get_video_url : (PHAsset *) asset
                 duration : (void(^)(NSString *s_time , NSTimeInterval duration)) cc_duration_block
                 complete : (void(^)(NSURL *url_video , BOOL is_can_be_used , BOOL is_off_limit_times)) cc_complete_block ;

FOUNDATION_EXPORT NSString * cc_photo_manger_image_key ;
FOUNDATION_EXPORT NSString * cc_photo_manger_info_key ;
FOUNDATION_EXPORT NSString * cc_photo_manger_video_key ;
FOUNDATION_EXPORT NSString * cc_photo_manger_unknow_key ;

FOUNDATION_EXPORT NSString * cc_photo_manger_type_key ;
FOUNDATION_EXPORT NSString * cc_photo_manger_asset_key ;

@end

#else

@import AssetsLibrary;

@interface CCPhotoManager : NSObject

@property (nonatomic , strong , readonly) ALAssetsLibrary * assets_library;

@property (nonatomic , strong , readonly) NSMutableArray <ALAssetsGroup *> * array_groups_image;
@property (nonatomic , strong , readonly) NSMutableArray <ALAssetsGroup *> * array_groups_videos;

- (void) cc_create_photo_library : (NSString *) s_title
                        complete : (void (^)(ALAssetsGroup *group , NSError *error)) block_create ;

- (void) cc_get_all_photo_groups : (void(^)(NSArray <ALAssetsGroup *> *array_group
                                            , NSError *error)) block_group ;
- (void) cc_get_all_video_groups : (void(^)(NSArray <ALAssetsGroup *> *array_group
                                            , NSError *error)) block_group ;

- (void) cc_open_group : (ALAssetsGroup *) group
                photos : (void (^)(NSArray <ALAsset *> * group
                                   , NSError *error)) block_images ;
@end

#endif
