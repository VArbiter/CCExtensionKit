//
//  YMNetworkMoniter.m
//  ym_sell_ios
//
//  Created by 冯明庆 on 2017/4/27.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "YMNetworkMoniter.h"

#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>
#import <AFNetworking/AFNetworkReachabilityManager.h>

#import <CoreTelephony/CTTelephonyNetworkInfo.h>

static YMNetworkMoniter *_moniter = nil;

NSString * const _YM_NETWORK_STATUS_CHANGE_NOTIFICATION_ = @"_YM_NETWORK_STATUS_CHANGE_NOTIFICATION_";
NSString * const _YM_NETWORK_STATUS_KEY_NEW_ = @"YM_NETWORK_STATUS_KEY_NEW";
NSString * const _YM_NETWORK_STATUS_KEY_OLD_ = @"YM_NETWORK_STATUS_KEY_OLD";

@interface YMNetworkMoniter ()

@property (nonatomic , strong) AFNetworkActivityIndicatorManager *activityManager ;
@property (nonatomic , strong) AFNetworkReachabilityManager *reachabilityManager ;
@property (nonatomic , strong) CTTelephonyNetworkInfo *netwotkInfo ;

@property (nonatomic , strong , readonly) NSArray *arrayString_2G ;
@property (nonatomic , strong , readonly) NSArray *arrayString_3G ;
@property (nonatomic , strong , readonly) NSArray *arrayString_4G ;

- (void) ymReachabilityMoniter ;

- (YMNetworkEnvironment) ymCaptureCurrentEnvironmentWithStatus : (AFNetworkReachabilityStatus) status ;

@end

@implementation YMNetworkMoniter

+ (instancetype) sharedNetworkMoniter {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _moniter = [[YMNetworkMoniter alloc] init];
        [_moniter ymReachabilityMoniter];
    });
    return _moniter;
}

- (void) ymReachabilityMoniter {
    self.activityManager = [AFNetworkActivityIndicatorManager sharedManager];
    self.activityManager.enabled = YES;
    [[NSUserDefaults standardUserDefaults] setInteger:-1 forKey:_YM_NETWORK_STATUS_KEY_OLD_];
    [[NSUserDefaults standardUserDefaults] synchronize];
    _moniter.reachabilityManager = [AFNetworkReachabilityManager sharedManager];
    __weak typeof(self) pSelf = self;
    [_moniter.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        [pSelf ymCaptureCurrentEnvironmentWithStatus:status];
    }];
    [_moniter.reachabilityManager startMonitoring];
}

- (YMNetworkEnvironment) ymCaptureCurrentEnvironmentWithStatus : (AFNetworkReachabilityStatus) status {
    NSString *stringAccess = self.netwotkInfo.currentRadioAccessTechnology ;
    YMNetworkEnvironment environment = YMNetworkEnvironmentUnknow ;
    if ([[UIDevice currentDevice] systemVersion].floatValue > 7.f) {
        if ([self.arrayString_4G containsObject:stringAccess])
            environment = YMNetworkEnvironment4G;
        else if ([self.arrayString_3G containsObject:stringAccess])
            environment = YMNetworkEnvironment3G;
        else if ([self.arrayString_2G containsObject:stringAccess])
            environment = YMNetworkEnvironment2G;
        
    }
    else environment = (YMNetworkEnvironment) status;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:_YM_NETWORK_STATUS_CHANGE_NOTIFICATION_
                                                        object:nil
                                                      userInfo:@{_YM_NETWORK_STATUS_KEY_NEW_ : @(status),
                                                                 _YM_NETWORK_STATUS_KEY_OLD_ : @([[NSUserDefaults standardUserDefaults] integerForKey:_YM_NETWORK_STATUS_KEY_OLD_])}];
    [[NSUserDefaults standardUserDefaults] setInteger:status
                                               forKey:_YM_NETWORK_STATUS_KEY_NEW_];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return environment;
}

- (YMNetworkEnvironmentType) ymEnvironmentType {
    NSInteger integerStatus = [[NSUserDefaults standardUserDefaults] integerForKey:_YM_NETWORK_STATUS_KEY_NEW_];
    if (integerStatus <= 0)
        return YMNetworkEnvironmentTypeNotConnected;
    if (integerStatus == 1 || integerStatus == 3 || integerStatus == 4)
        return YMNetworkEnvironmentTypeWeak;
    if (integerStatus == 2 || integerStatus == 5)
        return YMNetworkEnvironmentTypeStrong;
    return YMNetworkEnvironmentTypeStrong;
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
