//
//  YMNetworkMoniter.h
//  ym_sell_ios
//
//  Created by 冯明庆 on 2017/4/27.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger , YMNetworkEnvironment) {
    YMNetworkEnvironmentUnknow = -1 ,
    YMNetworkEnvironmentFail = 0 ,
    YMNetworkEnvironmentWLAN = 1 ,
    YMNetworkEnvironmentWIFI = 2 ,
    
    YMNetworkEnvironment2G = 3 ,
    YMNetworkEnvironment3G = 4 ,
    YMNetworkEnvironment4G = 5 ,
    // 5G ?
};

typedef NS_ENUM(NSInteger , YMNetworkEnvironmentType) {
    YMNetworkEnvironmentTypeStrong = 0,
    YMNetworkEnvironmentTypeWeak ,
    YMNetworkEnvironmentTypeNotConnected 
};

@interface YMNetworkMoniter : NSObject

+ (instancetype) sharedNetworkMoniter ;

- (YMNetworkEnvironmentType) ymEnvironmentType ;

extern NSString * const _YM_NETWORK_STATUS_CHANGE_NOTIFICATION_ ;
extern NSString * const _YM_NETWORK_STATUS_KEY_NEW_ ;
extern NSString * const _YM_NETWORK_STATUS_KEY_OLD_ ;

@end
