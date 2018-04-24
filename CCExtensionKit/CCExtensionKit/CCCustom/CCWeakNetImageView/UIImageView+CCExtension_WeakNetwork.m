//
//  UIImageView+CCExtension_WeakNetwork.m
//  CCLocalLibrary
//
//  Created by Elwinfrederick on 14/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "UIImageView+CCExtension_WeakNetwork.h"

#if __has_include(<SDWebImage/UIImageView+WebCache.h>)

#import "CCNetworkMoniter.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wstrict-prototypes"
    @import SDWebImage;
#pragma clang diagnostic pop

static BOOL __isEnableLoading = YES;

@implementation UIImageView (CCExtension_WeakNetwork)

- (instancetype) cc_weak_image : (NSURL *) url
                        holder : (UIImage *) imageHolder {
    BOOL isStrong = CCNetworkMoniter.shared.cc_environment_type == CCNetworkEnvironmentStrong;
    if (isStrong && __isEnableLoading) {
        [self sd_setImageWithURL:url
                placeholderImage:imageHolder
                         options:SDWebImageRetryFailed | SDWebImageAllowInvalidSSLCertificates | SDWebImageScaleDownLargeImages];
    };
    return self;
}

+ (void) cc_enable_loading : (BOOL) isEnable {
    __isEnableLoading = isEnable;
}

@end

#endif
