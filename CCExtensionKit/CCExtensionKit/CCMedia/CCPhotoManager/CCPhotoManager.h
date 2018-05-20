//
//  CCPhotoManager.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2018/5/20.
//  Copyright © 2018 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0

@import Photos;

@interface CCPhotoManager : NSObject

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
