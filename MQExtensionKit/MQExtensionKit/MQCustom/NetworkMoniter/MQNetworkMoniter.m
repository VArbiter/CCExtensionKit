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
@property (nonatomic , strong) CTTelephonyNetworkInfo *netwotk_info ;

@property (nonatomic , strong , readonly) NSArray *array_string_2G ;
@property (nonatomic , strong , readonly) NSArray *array_string_3G ;
@property (nonatomic , strong , readonly) NSArray *array_string_4G ;

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
    __weak typeof(self) weak_self = self;
    [_moniter.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        __strong typeof(weak_self) strong_self = weak_self;
        [strong_self mq_capture_current_environment:status];
    }];
    [_moniter.reachabilityManager startMonitoring];
}

- (MQNetworkType) mq_capture_current_environment : (AFNetworkReachabilityStatus) status {
    NSString *s_access = self.netwotk_info.currentRadioAccessTechnology ;
    MQNetworkType environment = MQNetworkTypeUnknow ;
    if ([[UIDevice currentDevice] systemVersion].floatValue > 7.f) {
        if ([self.array_string_4G containsObject:s_access])
            environment = MQNetworkType4G;
        else if ([self.array_string_3G containsObject:s_access])
            environment = MQNetworkType3G;
        else if ([self.array_string_2G containsObject:s_access])
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
    NSInteger i_status = [[NSUserDefaults standardUserDefaults] integerForKey:mq_network_status_key_new];
    if (i_status <= 0)
        return MQNetworkEnvironmentNotConnected;
    if (i_status == 1 || i_status == 3 || i_status == 4)
        return MQNetworkEnvironmentWeak;
    if (i_status == 2 || i_status == 5)
        return MQNetworkEnvironmentStrong;
    return MQNetworkEnvironmentStrong;
}

#pragma mark - Getter
- (CTTelephonyNetworkInfo *)netwotk_info {
    if (_netwotk_info) return _netwotk_info;
    _netwotk_info = [[CTTelephonyNetworkInfo alloc] init];
    return _netwotk_info;
}

- (NSArray *)array_string_2G {
    return @[CTRadioAccessTechnologyEdge,
             CTRadioAccessTechnologyGPRS,
             CTRadioAccessTechnologyCDMA1x];
}
- (NSArray *)array_string_3G {
    return @[CTRadioAccessTechnologyHSDPA,
             CTRadioAccessTechnologyWCDMA,
             CTRadioAccessTechnologyHSUPA,
             CTRadioAccessTechnologyCDMAEVDORev0,
             CTRadioAccessTechnologyCDMAEVDORevA,
             CTRadioAccessTechnologyCDMAEVDORevB,
             CTRadioAccessTechnologyeHRPD];
}
- (NSArray *)array_string_4G {
    return @[CTRadioAccessTechnologyLTE];
}

@end

#endif
