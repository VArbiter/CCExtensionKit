//
//  MQNetworkMoniter.h
//  MQExtensionKit
//
//  Created by 冯明庆 on 2017/4/27.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

#if __has_include(<AFNetworking/AFNetworkReachabilityManager.h>) \
    && __has_include(<AFNetworking/AFNetworkActivityIndicatorManager.h>)

typedef NS_ENUM(NSInteger , MQNetworkType) {
    MQNetworkTypeUnknow = -1 ,
    MQNetworkTypeFail = 0 ,
    MQNetworkTypeWLAN = 1 ,
    MQNetworkTypeWIFI = 2 ,
    
    MQNetworkType2G = 3 ,
    MQNetworkType3G = 4 ,
    MQNetworkType4G = 5 ,
    // 5G ?
};

typedef NS_ENUM(NSInteger , MQNetworkEnvironment) {
    MQNetworkEnvironmentStrong = 0,
    MQNetworkEnvironmentWeak ,
    MQNetworkEnvironmentNotConnected
};

@interface MQNetworkMoniter : NSObject

+ (instancetype) mq_shared;

- (MQNetworkEnvironment) mq_environment_type ;

extern NSString * const _MQ_NETWORK_STATUS_CHANGE_NOTIFICATION_ ;
extern NSString * const _MQ_NETWORK_STATUS_KEY_NEW_ ;
extern NSString * const _MQ_NETWORK_STATUS_KEY_OLD_ ;

@end

#endif
