//
//  PHImageRequestOptions+CCExtension.m
//  CCExtensionKit
//
//  Created by 冯明庆 on 2018/5/20.
//  Copyright © 2018 冯明庆. All rights reserved.
//

#import "PHImageRequestOptions+CCExtension.h"

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0

@implementation PHImageRequestOptions (CCExtension)

+ (instancetype) cc_common : (PHImageRequestOptionsDeliveryMode) mode_delivery {
    PHImageRequestOptions * t = [[PHImageRequestOptions alloc] init];
    t.deliveryMode = mode_delivery;
    return t;
}

@end

#endif
