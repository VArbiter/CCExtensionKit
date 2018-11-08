//
//  MQNetworkMoniter.m
//  MQExtensionKit
//
//  Created by 冯明庆 on 2017/4/27.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "MQNetworkMoniter.h"

#if __has_include(<AFNetworking/AFNetworkReachabilityManager.h>) \
    && __has_include(<AFNetworking/AFNetworkActivityIndicatorManager.h>)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wstrict-prototypes"
    #import <AFNetworking/AFNetworkActivityIndicatorManager.h>
    #import <AFNetworking/AFNetworkReachabilityManager.h>
#pragma clang diagnostic pop

#import <CoreTelephony/CTTelephonyNetworkInfo.h>

static MQNetworkMoniter *_moniter = nil;

NSString * const mq_network_status_change_notification = @"MQ_NETWORK_STATUS_CHANGE_NOTIFICATION";
NSString * const mq_network_status_key_new = @"MQ_NETWORK_STATUS_KEY_NEW";
NSString * const mq_network_status_key_old = @"MQ_NETWORK_STATUS_KEY_OLD";

@interface MQNetworkMoniter ()

@property (nonatomic , strong) AFNetworkActivityIndicatorManager *activityManager ;
@property (nonatomic , strong) AFNetworkReachabilityManager *reachabilityManager ;
@property (nonatomic , strong) CTTelephonyNetworkInfo *netwotkInfo ;

@property (nonatomic , strong , readonly) NSArray *arrayString_2G ;
@property (nonatomic , strong , readonly) NSArray *arrayString_3G ;
@property (nonatomic , strong , readonly) NSArray *arrayString_4G ;

- (void) mq_reachability_moniter ;

- (MQNetworkType) mq_capture_current_environment : (AFNetworkReachabilityStatus) status ;

@end

@implementation MQNetworkMoniter

+ (instancetype) mq_shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _moniter = [[MQNetworkMoniter alloc] init];
        [_moniter mq_reachability_moniter];
    });
    return _moniter;
}

- (void) mq_reachability_moniter {
    self.activityManager = [AFNetworkActivityIndicatorManager sharedManager];
    self.activityManager.enabled = YES;
    [[NSUserDefaults standardUserDefaults] setInteger:-1 forKey:mq_network_status_key_new];
    [[NSUserDefaults standardUserDefaults] synchronize];
    _moniter.reachabilityManager = [AFNetworkReachabilityManager sharedManager];
    __weak typeof(self) pSelf = self;
    [_moniter.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        [pSelf mq_capture_current_environment:status];
    }];
    [_moniter.reachabilityManager startMonitoring];
}

- (MQNetworkType) mq_capture_current_environment : (AFNetworkReachabilityStatus) status {
    NSString *stringAccess = self.netwotkInfo.currentRadioAccessTechnology ;
    MQNetworkType environment = MQNetworkTypeUnknow ;
    if ([[UIDevice currentDevice] systemVersion].floatValue > 7.f) {
        if ([self.arrayString_4G containsObject:stringAccess])
            environment = MQNetworkType4G;
        else if ([self.arrayString_3G containsObject:stringAccess])
            environment = MQNetworkType3G;
        else if ([self.arrayString_2G containsObject:stringAccess])
            environment = MQNetworkType2G;
        
    }
    else environment = (MQNetworkType) status;
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:mq_network_status_change_notification
     object:nil
     userInfo:@{mq_network_status_key_new : @(environment),
                mq_network_status_key_old : @([[NSUserDefaults standardUserDefaults]
                                               integerForKey:mq_network_status_key_new])}];
    [[NSUserDefaults standardUserDefaults] setInteger:status
                                               forKey:mq_network_status_key_new];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return environment;
}

- (MQNetworkEnvironment) mq_environment_type {
    NSInteger integerStatus = [[NSUserDefaults standardUserDefaults] integerForKey:mq_network_status_key_new];
    if (integerStatus <= 0)
        return MQNetworkEnvironmentNotConnected;
    if (integerStatus == 1 || integerStatus == 3 || integerStatus == 4)
        return MQNetworkEnvironmentWeak;
    if (integerStatus == 2 || integerStatus == 5)
        return MQNetworkEnvironmentStrong;
    return MQNetworkEnvironmentStrong;
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
