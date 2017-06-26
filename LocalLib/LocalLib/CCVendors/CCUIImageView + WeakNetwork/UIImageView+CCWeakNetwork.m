//
//  UIImageView+CCWeakNetwork.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/27.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "UIImageView+CCWeakNetwork.h"

#import "CCCommonTools.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import "CCNetworkMoniter.h"

@implementation UIImageView (CCWeakNetwork)

- (void) ccSDImage : (NSString *) stringLik
       holderImage : (NSString *) stringImageName {
    if ([CCNetworkMoniter sharedNetworkMoniter].ccEnvironmentType == CCNetworkEnvironmentStrong) {
        [self sd_setImageWithURL:ccURL(stringLik, false)
                placeholderImage:ccImage(stringImageName, YES)];
    }
}

@end
