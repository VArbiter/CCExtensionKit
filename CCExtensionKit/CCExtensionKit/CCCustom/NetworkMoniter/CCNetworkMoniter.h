//
//  CCNetworkMoniter.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/27.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

#if __has_include(<AFNetworking/AFNetworkReachabilityManager.h>) \
    && __has_include(<AFNetworking/AFNetworkActivityIndicatorManager.h>)

typedef NS_ENUM(NSInteger , CCNetworkType) {
    CCNetworkTypeUnknow = -1 ,
    CCNetworkTypeFail = 0 ,
    CCNetworkTypeWLAN = 1 ,
    CCNetworkTypeWIFI = 2 ,
    
    CCNetworkType2G = 3 ,
    CCNetworkType3G = 4 ,
    CCNetworkType4G = 5 ,
    // 5G ?
};

typedef NS_ENUM(NSInteger , CCNetworkEnvironment) {
    CCNetworkEnvironmentStrong = 0,
    CCNetworkEnvironmentWeak ,
    CCNetworkEnvironmentNotConnected
};

@interface CCNetworkMoniter : NSObject

+ (instancetype) shared;

- (CCNetworkEnvironment) ccEnvironmentType ;

extern NSString * const _CC_NETWORK_STATUS_CHANGE_NOTIFICATION_ ;
extern NSString * const _CC_NETWORK_STATUS_KEY_NEW_ ;
extern NSString * const _CC_NETWORK_STATUS_KEY_OLD_ ;

@end

#endif
