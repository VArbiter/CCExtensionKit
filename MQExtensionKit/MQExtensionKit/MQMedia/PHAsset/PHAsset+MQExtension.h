//
//  PHAsset+MQExtension.h
//  MQExtensionKit
//
//  Created by 冯明庆 on 2018/5/20.
//  Copyright © 2018 冯明庆. All rights reserved.
//

#import <Photos/Photos.h>

@import UIKit;

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0

/*
typedef NS_ENUM(NSInteger , CCPHAssetCacheType) {
    CCPHAssetCacheType_default = 0,
    CCPHAssetCacheType_Normal ,
    CCPHAssetCacheType_High_Quality ,
    CCPHAssetCacheType_Fast
};
 */

typedef NSString * CCPHAssetType;

FOUNDATION_EXPORT CCPHAssetType CCPHAssetType_Unknow ;
FOUNDATION_EXPORT CCPHAssetType CCPHAssetType_Video ;
FOUNDATION_EXPORT CCPHAssetType CCPHAssetType_Photo ;
FOUNDATION_EXPORT CCPHAssetType CCPHAssetType_Audio ;
FOUNDATION_EXPORT CCPHAssetType CCPHAssetType_Live_Photo ;

@interface PHAsset (CCExtension)

@property (readonly) CCPHAssetType type_asset;

/*
@property (nonatomic , strong , readonly) NSMutableDictionary *mq_phasset_dict_normal_cache ;
@property (nonatomic , strong , readonly) NSMutableDictionary *mq_phasset_dict_high_quality_cache ;
@property (nonatomic , strong , readonly) NSMutableDictionary *mq_phasset_dict_fast_cache ;

- (void) mq_cache_image_size : (CGSize) size
                        type : (CCPHAssetCacheType) type
                    complete : (void (^)(UIImage * image ,
                                         PHAsset * asset ,
                                         NSDictionary *dict_info)) mq_complete_block ;

- (void) mq_destory_cache : (CCPHAssetCacheType) type ;
- (void) mq_destory_all_cache ;

 */
@end

#endif

@interface UIImage (CCExtension_Orientation)

// borrowed from : http://www.cnblogs.com/jiangyazhou/archive/2012/03/22/2412343.html ;
/// fix image orientation . for which EXIF info can be lost . // 修复 图片的方向 . 因为 图片的 EXIF 可能丢失 .
- (UIImage *) mq_fix_orientation ;

- (UIImage *) mq_fix_orientation : (UIImageOrientation) orientation ;

@end
