//
//  MQDevice.h
//  MQExtensionKit
//
//  Created by 冯明庆 on 14/11/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

@import UIKit;

#ifndef MQ_DEVICE_TYPE_S
    #define MQ_DEVICE_TYPE_S [MQDevice mq_device_type]
#endif

#ifndef MQ_SYSTEM_VERSION_S
    #define MQ_SYSTEM_VERSION_S [MQDevice mq_system_version]
#endif

#ifndef MQ_DEVICE_UUID_S
    #define MQ_DEVICE_UUID_S [MQDevice mq_device_UUID]
#endif

#ifndef MQ_DEVICE_RESOLUTION_S
    #define MQ_DEVICE_RESOLUTION_S [MQDevice mq_device_resolution]
#endif

#ifndef MQ_DEVICE_RECT_S
    #define MQ_DEVICE_RECT_S [MQDevice mq_device_rect]
#endif

struct MQDeviceResolution {
    CGFloat width;
    CGFloat height;
    CGFloat scale;
};
typedef struct CG_BOXABLE MQDeviceResolution MQDeviceResolution;

@interface MQDevice : NSObject

+ (NSString *) mq_device_info ;
+ (NSString *) mq_device_type ;
+ (NSString *) mq_device_model ;
+ (NSString *) mq_device_ip ;

+ (NSString *) mq_device_UUID ;
+ (NSString *) mq_device_IDFA ;

+ (MQDeviceResolution) mq_device_resolution : (BOOL) is_landscape ;
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
