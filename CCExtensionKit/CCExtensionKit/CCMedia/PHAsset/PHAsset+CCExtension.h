//
//  PHAsset+CCExtension.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2018/5/20.
//  Copyright © 2018 冯明庆. All rights reserved.
//

#import <Photos/Photos.h>

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0

typedef NS_ENUM(NSInteger , CCPHAssetCacheType) {
    CCPHAssetCacheType_default = 0,
    CCPHAssetCacheType_Normal ,
    CCPHAssetCacheType_High_Quality ,
    CCPHAssetCacheType_Fast
};

@interface PHAsset (CCExtension)

@property (nonatomic , strong , readonly) NSMutableDictionary *cc_phasset_dict_normal_cache ;
@property (nonatomic , strong , readonly) NSMutableDictionary *cc_phasset_dict_high_quality_cache ;
@property (nonatomic , strong , readonly) NSMutableDictionary *cc_phasset_dict_fast_cache ;

- (void) cc_cache_image_size : (CGSize) size
                        type : (CCPHAssetCacheType) type
                    complete : (void (^)(UIImage * image ,
                                         PHAsset * asset ,
                                         NSDictionary *dict_info)) cc_complete_block ;

- (void) cc_destory_cache : (CCPHAssetCacheType) type ;
- (void) cc_destory_all_cache ;

@end

#endif