//
//  CCNetworkMoniter.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/27.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "CCNetworkMoniter.h"

#if __has_include(<AFNetworking/AFNetworkReachabilityManager.h>) \
    && __has_include(<AFNetworking/AFNetworkActivityIndicatorManager.h>)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wstrict-prototypes"
    #import <AFNetworking/AFNetworkActivityIndicatorManager.h>
    #import <AFNetworking/AFNetworkReachabilityManager.h>
#pragma clang diagnostic pop

#import <CoreTelephony/CTTelephonyNetworkInfo.h>

static CCNetworkMoniter *_moniter = nil;

NSString * const _CC_NETWORK_STATUS_CHANGE_NOTIFICATION_ = @"_CC_NETWORK_STATUS_CHANGE_NOTIFICATION_";
NSString * const _CC_NETWORK_STATUS_KEY_NEW_ = @"CC_NETWORK_STATUS_KEY_NEW";
NSString * const _CC_NETWORK_STATUS_KEY_OLD_ = @"CC_NETWORK_STATUS_KEY_OLD";

@interface CCNetworkMoniter ()

@property (nonatomic , strong) AFNetworkActivityIndicatorManager *activityManager ;
@property (nonatomic , strong) AFNetworkReachabilityManager *reachabilityManager ;
@property (nonatomic , strong) CTTelephonyNetworkInfo *netwotkInfo ;

@property (nonatomic , strong , readonly) NSArray *arrayString_2G ;
@property (nonatomic , strong , readonly) NSArray *arrayString_3G ;
@property (nonatomic , strong , readonly) NSArray *arrayString_4G ;

- (void) ccReachabilityMoniter ;

- (CCNetworkType) ccCaptureCurrentEnvironment : (AFNetworkReachabilityStatus) status ;

@end

@implementation CCNetworkMoniter

+ (instancetype) shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _moniter = [[CCNetworkMoniter alloc] init];
        [_moniter ccReachabilityMoniter];
    });
    return _moniter;
}

- (void) ccReachabilityMoniter {
    self.activityManager = [AFNetworkActivityIndicatorManager sharedManager];
    self.activityManager.enabled = YES;
    [[NSUserDefaults standardUserDefaults] setInteger:-1 forKey:_CC_NETWORK_STATUS_KEY_NEW_];
    [[NSUserDefaults standardUserDefaults] synchronize];
    _moniter.reachabilityManager = [AFNetworkReachabilityManager sharedManager];
    __weak typeof(self) pSelf = self;
    [_moniter.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        [pSelf ccCaptureCurrentEnvironment:status];
    }];
    [_moniter.reachabilityManager startMonitoring];
}

- (CCNetworkType) ccCaptureCurrentEnvironment : (AFNetworkReachabilityStatus) status {
    NSString *stringAccess = self.netwotkInfo.currentRadioAccessTechnology ;
    CCNetworkType environment = CCNetworkTypeUnknow ;
    if ([[UIDevice currentDevice] systemVersion].floatValue > 7.f) {
        if ([self.arrayString_4G containsObject:stringAccess])
            environment = CCNetworkType4G;
        else if ([self.arrayString_3G containsObject:stringAccess])
            environment = CCNetworkType3G;
        else if ([self.arrayString_2G containsObject:stringAccess])
            environment = CCNetworkType2G;
        
    }
    else environment = (CCNetworkType) status;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:_CC_NETWORK_STATUS_CHANGE_NOTIFICATION_
                                                        object:nil
                                                      userInfo:@{_CC_NETWORK_STATUS_KEY_NEW_ : @(environment),
                                                                 _CC_NETWORK_STATUS_KEY_OLD_ : @([[NSUserDefaults standardUserDefaults] integerForKey:_CC_NETWORK_STATUS_KEY_NEW_])}];
    [[NSUserDefaults standardUserDefaults] setInteger:status
                                               forKey:_CC_NETWORK_STATUS_KEY_NEW_];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return environment;
}

- (CCNetworkEnvironment) cc_environment_type {
    NSInteger integerStatus = [[NSUserDefaults standardUserDefaults] integerForKey:_CC_NETWORK_STATUS_KEY_NEW_];
    if (integerStatus <= 0)
        return CCNetworkEnvironmentNotConnected;
    if (integerStatus == 1 || integerStatus == 3 || integerStatus == 4)
        return CCNetworkEnvironmentWeak;
    if (integerStatus == 2 || integerStatus == 5)
        return CCNetworkEnvironmentStrong;
    return CCNetworkEnvironmentStrong;
}

#pragma mark - Getter
- (CTTelephonyNetworkInfo *)netwotkInfo {
    if (_netwotkInfo) return _netwotkInfo;
    _netwotkInfo = [[CTTelephonyNetworkInfo alloc] init];
    return _netwotkInfo;
}

- (NSArray *)arrayString_2G {
    return @[CTRadioAccessTechnologyEdge,
             CTRadioAccessTechnologyGPRS,
             CTRadioAccessTechnologyCDMA1x];
}
- (NSArray *)arrayString_3G {
    return @[CTRadioAccessTechnologyHSDPA,
             CTRadioAccessTechnologyWCDMA,
             CTRadioAccessTechnologyHSUPA,
             CTRadioAccessTechnologyCDMAEVDORev0,
             CTRadioAccessTechnologyCDMAEVDORevA,
             CTRadioAccessTechnologyCDMAEVDORevB,
             CTRadioAccessTechnologyeHRPD];
}
- (NSArray *)arrayString_4G {
    return @[CTRadioAccessTechnologyLTE];
}

@end

#endif
