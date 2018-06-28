//
//  CCDevice.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 14/11/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

@import UIKit;

#ifndef CC_DEVICE_TYPE_S
    #define CC_DEVICE_TYPE_S [CCDevice cc_device_type]
#endif

#ifndef CC_SYSTEM_VERSION_S
    #define CC_SYSTEM_VERSION_S [CCDevice cc_system_version]
#endif

#ifndef CC_DEVICE_UUID_S
    #define CC_DEVICE_UUID_S [CCDevice cc_device_UUID]
#endif

#ifndef CC_DEVICE_RESOLUTION_S
    #define CC_DEVICE_RESOLUTION_S [CCDevice cc_device_resolution]
#endif

#ifndef CC_DEVICE_RECT_S
    #define CC_DEVICE_RECT_S [CCDevice cc_device_rect]
#endif

struct CCDeviceResolution {
    CGFloat width;
    CGFloat height;
    CGFloat scale;
};
typedef struct CG_BOXABLE CCDeviceResolution CCDeviceResolution;

@interface CCDevice : NSObject

+ (NSString *) cc_device_info ;
+ (NSString *) cc_device_type ;
+ (NSString *) cc_device_model ;
+ (NSString *) cc_device_ip ;

+ (NSString *) cc_device_UUID ;
+ (NSString *) cc_device_IDFA ;

+ (CCDeviceResolution) cc_device_resolution ;
+ (NSString *) cc_device_rect ;

+ (NSString *) cc_system_version ;

+ (float) cc_battery_level ;
+ (UIDeviceBatteryState) cc_battery_state ;

+ (unsigned long long) cc_disk_total_size ;
+ (unsigned long long) cc_available_disk_size ;
+ (unsigned long long) cc_available_memory ;
+ (unsigned long long) cc_current_memory_in_use ;
+ (unsigned long long) cc_total_memory ;

+ (NSString *) cc_current_linked_ssid ;

@end
