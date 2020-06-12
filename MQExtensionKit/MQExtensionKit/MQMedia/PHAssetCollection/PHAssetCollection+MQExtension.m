//
//  PHAssetCollection+MQExtension.m
//  MQExtensionKit
//
//  Created by 冯明庆 on 2018/5/20.
//  Copyright © 2018 冯明庆. All rights reserved.
//

#import "PHAssetCollection+MQExtension.h"
#import <UIKit/UIKit.h>

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0

@implementation PHAssetCollection (MQExtension)

- (void) mq_thumbnail_with_size : (CGSize) size
                       complete : (void (^)(NSString * s_title ,
                                            NSUInteger i_count ,
                                            UIImage * image)) block_complete {
    [self mq_thumbnail_with_size:size
                            mode:PHImageRequestOptionsDeliveryModeOpportunistic
                        complete:block_complete];
}
- (void) mq_thumbnail_with_size : (CGSize) size
                           mode : (PHImageRequestOptionsDeliveryMode) mode
                       complete : (void (^)(NSString * s_title ,
                                            NSUInteger i_count ,
                                            UIImage * image)) block_complete {
    
    PHFetchResult * asset_result = [PHAsset fetchAssetsInAssetCollection:self options:nil];
    NSUInteger i_count = asset_result.count;
    
    if (!asset_result.count) {
        block_complete(self.localizedTitle , 0 , nil);
        return;
    }
    
    CGFloat f_scale = [UIScreen mainScreen].scale;
    CGSize size_scale = CGSizeMake(size.width * f_scale, size.height * f_scale);
    
    PHImageRequestOptions * t_options = [[PHImageRequestOptions alloc] init];
    t_options.deliveryMode = mode;
    
    [PHCachingImageManager.defaultManager requestImageForAsset:asset_result.lastObject
                                                    targetSize:size_scale
                                                   contentMode:PHImageContentModeAspectFill
                                                       options:t_options
                                                 resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                        
        if (block_complete) block_complete(self.localizedTitle , i_count , result);
    }];
}

@end

#endif
