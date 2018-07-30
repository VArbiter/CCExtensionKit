//
//  UIImageView+MQExtension_WeakNetwork.m
//  MQExtensionKit
//
//  Created by Elwinfrederick on 14/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "UIImageView+MQExtension_WeakNetwork.h"

#if __has_include(<SDWebImage/UIImageView+WebCache.h>)

#import "MQNetworkMoniter.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wstrict-prototypes"
    @import SDWebImage;
#pragma clang diagnostic pop

static BOOL __isEnableLoading = YES;

@implementation UIImageView (MQExtension_WeakNetwork)

- (instancetype) mq_weak_image : (NSURL *) url
                        holder : (UIImage *) image_holder {
    BOOL isStrong = MQNetworkMoniter.mq_shared.mq_environment_type == MQNetworkEnvironmentStrong;
    if (isStrong && __isEnableLoading) {
        [self sd_setImageWithURL:url
                placeholderImage:imageHolder
                         options:SDWebImageRetryFailed | SDWebImageAllowInvalidSSLCertificates | SDWebImageScaleDownLargeImages];
    };
    return self;
}

+ (void) mq_enable_loading : (BOOL) is_enable {
    __isEnableLoading = is_enable;
}

@end

#endif
