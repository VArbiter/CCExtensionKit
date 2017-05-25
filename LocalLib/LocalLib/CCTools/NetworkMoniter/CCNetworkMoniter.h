//
//  CCNetworkMoniter.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/27.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger , CCNetworkEnvironment) {
    CCNetworkEnvironmentUnknow = -1 ,
    CCNetworkEnvironmentFail = 0 ,
    CCNetworkEnvironmentWLAN = 1 ,
    CCNetworkEnvironmentWIFI = 2 ,
    
    CCNetworkEnvironment2G = 3 ,
    CCNetworkEnvironment3G = 4 ,
    CCNetworkEnvironment4G = 5 ,
    // 5G ?
};

typedef NS_ENUM(NSInteger , CCNetworkEnvironmentType) {
    CCNetworkEnvironmentTypeStrong = 0,
    CCNetworkEnvironmentTypeWeak ,
    CCNetworkEnvironmentTypeNotConnected 
};

@interface CCNetworkMoniter : NSObject

+ (instancetype) sharedNetworkMoniter ;

- (CCNetworkEnvironmentType) ccEnvironmentType ;

extern NSString * const _CC_NETWORK_STATUS_CHANGE_NOTIFICATION_ ;
extern NSString * const _CC_NETWORK_STATUS_KEY_NEW_ ;
extern NSString * const _CC_NETWORK_STATUS_KEY_OLD_ ;

@end
