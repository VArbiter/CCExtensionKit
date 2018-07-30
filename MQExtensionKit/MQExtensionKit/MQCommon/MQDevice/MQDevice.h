//
//  CCDevice.h
//  MQExtensionKit
//
//  Created by 冯明庆 on 14/11/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

@import UIKit;

#ifndef CC_DEVICE_TYPE_S
    #define CC_DEVICE_TYPE_S [CCDevice mq_device_type]
#endif

#ifndef CC_SYSTEM_VERSION_S
    #define CC_SYSTEM_VERSION_S [CCDevice mq_system_version]
#endif

#ifndef CC_DEVICE_UUID_S
    #define CC_DEVICE_UUID_S [CCDevice mq_device_UUID]
#endif

#ifndef CC_DEVICE_RESOLUTION_S
    #define CC_DEVICE_RESOLUTION_S [CCDevice mq_device_resolution]
#endif

#ifndef CC_DEVICE_RECT_S
    #define CC_DEVICE_RECT_S [CCDevice mq_device_rect]
#endif

struct CCDeviceResolution {
    CGFloat width;
    CGFloat height;
    CGFloat scale;
};
typedef struct CG_BOXABLE CCDeviceResolution CCDeviceResolution;

@interface CCDevice : NSObject

+ (NSString *) mq_device_info ;
+ (NSString *) mq_device_type ;
+ (NSString *) mq_device_model ;
+ (NSString *) mq_device_ip ;

+ (NSString *) mq_device_UUID ;
+ (NSString *) mq_device_IDFA ;

+ (CCDeviceResolution) mq_device_resolution ;
+ (NSString *) mq_device_rect ;

+ (NSString *) mq_system_version ;

+ (float) mq_battery_level ;
+ (UIDeviceBatteryState) mq_battery_state ;

+ (unsigned long long) mq_disk_total_size ;
+ (unsigned long long) mq_available_disk_size ;
+ (unsigned long long) mq_available_memory ;
+ (unsigned long long) mq_current_memory_in_use ;
+ (unsigned long long) mq_total_memory ;

+ (NSString *) mq_current_linked_ssid ;

@end
