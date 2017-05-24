//
//  UIImageView+YMWeakNetwork.m
//  ym_sell_ios
//
//  Created by 冯明庆 on 2017/4/27.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "UIImageView+YMWeakNetwork.h"
#import "YMCommonDefine.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import "YMNetworkMoniter.h"

@implementation UIImageView (YMWeakNetwork)

- (void) ymSDImageWithLink : (NSString *) stringLik
           withHolderImage : (NSString *) stringImageName {
    if ([YMNetworkMoniter sharedNetworkMoniter].ymEnvironmentType == YMNetworkEnvironmentTypeStrong) {
        [self sd_setImageWithURL:ymURL(stringLik, false)
                placeholderImage:ymImage(stringImageName, YES)];
    }
}

@end
