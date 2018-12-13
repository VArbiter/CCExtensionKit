//
//  MQDevice.m
//  MQExtensionKit
//
//  Created by 冯明庆 on 14/11/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "MQDevice.h"

#import <sys/utsname.h>
@import Darwin;
#import <SystemConfiguration/CaptiveNetwork.h>
@import AdSupport;

@implementation MQDevice

+ (NSString *) mq_device_info {
    struct utsname system_info;
    uname(&system_info);
    return [NSString stringWithCString:system_info.machine
                              encoding:NSASCIIStringEncoding];
}

+ (NSString *) mq_device_type {
#if TARGET_IPHONE_SIMULATOR
    CGFloat f_scale = UIScreen.mainScreen.scale;
    CGFloat f_width = UIScreen.mainScreen.bounds.size.width * f_scale;
    CGFloat f_height = UIScreen.mainScreen.bounds.size.height * f_scale;
    
    if (f_width == 320.f && f_height == 480.f) return @"iPhone 3GS"; // == iPhone 3
    if (f_width == 640.f && f_height == 960.f) return @"iPhone 4s"; // == iPhone 4
    if (f_width == 640.f && f_height == 1136.f) return @"iPhone SE"; // == iPhone 5 / 5c / 5s
    if (f_width == 750.f && f_height == 1134.f) return @"iPhone 8"; // == iPhone 6 / 6s
    if (f_width == 1080.f && f_height == 1920.f) return @"iPhone 8 Plus"; // == iPhone 6 Plus / 6s Plus / 7 Plus
    if (f_width == 1125.f && f_height == 2436.f) return @"iPhone X"; // == iPhone Xs
    if (f_width == 828.f && f_height == 1792.f) return @"iPhone Xr";
    if (f_width == 1242.f && f_height == 2688.f) return @"iPhone Xs Max";
    
    if (f_width == 768.f && f_height == 1024.f) return @"iPad Mini"; // == iPad 2
    if (f_width == 1536.f && f_height == 2048.f) return @"iPad 4"; // == iPad 3
    if (f_width == 2048.f && f_height == 1536.f) return @"iPad Pro"; // == iPad Air (9.7 inch)
    if (f_width == 2732.f && f_height == 2048.f) return @"iPad Pro"; // == iPad Air (12.9 inch)
    
    return @"Unknow" ;
#else
    struct utsname system_info;
    uname(&system_info);
    NSString *platform = [NSString stringWithCString:system_info.machine
                                            encoding:NSASCIIStringEncoding];
    if([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    if([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    if([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    if([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    if([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    if([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    if([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4s";
    if([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    if([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    if([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    if([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    if([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    if([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    if([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    if([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    if([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    if([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    if([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    if([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    if([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    if([platform isEqualToString:@"iPhone10,1"]) return @"iPhone 8";
    if([platform isEqualToString:@"iPhone10,4"]) return @"iPhone 8";
    if([platform isEqualToString:@"iPhone10,2"]) return @"iPhone 8 Plus";
    if([platform isEqualToString:@"iPhone10,5"]) return @"iPhone 8 Plus";
    if([platform isEqualToString:@"iPhone10,3"]) return @"iPhone X";
    if([platform isEqualToString:@"iPhone10,6"]) return @"iPhone X";
    if([platform isEqualToString:@"iPhone11,2"]) return @"iPhone Xs";
    if([platform isEqualToString:@"iPhone11,4"]) return @"iPhone Xs Max";
    if([platform isEqualToString:@"iPhone11,6"]) return @"iPhone Xs Max";
    if([platform isEqualToString:@"iPhone11,8"]) return @"iPhone Xr";
    if([platform isEqualToString:@"iPod1,1"]) return @"iPod Touch 1G";
    if([platform isEqualToString:@"iPod2,1"]) return @"iPod Touch 2G";
    if([platform isEqualToString:@"iPod3,1"]) return @"iPod Touch 3G";
    if([platform isEqualToString:@"iPod4,1"]) return @"iPod Touch 4G";
    if([platform isEqualToString:@"iPod5,1"]) return @"iPod Touch 5G";
    if([platform isEqualToString:@"iPad1,1"]) return @"iPad 1G";
    if([platform isEqualToString:@"iPad2,1"]) return @"iPad 2";
    if([platform isEqualToString:@"iPad2,2"]) return @"iPad 2";
    if([platform isEqualToString:@"iPad2,3"]) return @"iPad 2";
    if([platform isEqualToString:@"iPad2,4"]) return @"iPad 2";
    if([platform isEqualToString:@"iPad2,5"]) return @"iPad Mini 1G";
    if([platform isEqualToString:@"iPad2,6"]) return @"iPad Mini 1G";
    if([platform isEqualToString:@"iPad2,7"]) return @"iPad Mini 1G";
    if([platform isEqualToString:@"iPad3,1"]) return @"iPad 3";
    if([platform isEqualToString:@"iPad3,2"]) return @"iPad 3";
    if([platform isEqualToString:@"iPad3,3"]) return @"iPad 3";
    if([platform isEqualToString:@"iPad3,4"]) return @"iPad 4";
    if([platform isEqualToString:@"iPad3,5"]) return @"iPad 4";
    if([platform isEqualToString:@"iPad3,6"]) return @"iPad 4";
    if([platform isEqualToString:@"iPad4,1"]) return @"iPad Air";
    if([platform isEqualToString:@"iPad4,2"]) return @"iPad Air";
    if([platform isEqualToString:@"iPad4,3"]) return @"iPad Air";
    if([platform isEqualToString:@"iPad4,4"]) return @"iPad Mini 2G";
    if([platform isEqualToString:@"iPad4,5"]) return @"iPad Mini 2G";
    if([platform isEqualToString:@"iPad4,6"]) return @"iPad Mini 2G";
    if([platform isEqualToString:@"iPad4,7"]) return @"iPad Mini 3";
    if([platform isEqualToString:@"iPad4,8"]) return @"iPad Mini 3";
    if([platform isEqualToString:@"iPad4,9"]) return @"iPad Mini 3";
    if([platform isEqualToString:@"iPad5,1"]) return @"iPad Mini 4";
    if([platform isEqualToString:@"iPad5,2"]) return @"iPad Mini 4";
    if([platform isEqualToString:@"iPad5,3"]) return @"iPad Air 2";
    if([platform isEqualToString:@"iPad5,4"]) return @"iPad Air 2";
    if([platform isEqualToString:@"iPad6,3"]) return @"iPad Pro 9.7";
    if([platform isEqualToString:@"iPad6,4"]) return @"iPad Pro 9.7";
    if([platform isEqualToString:@"iPad6,7"]) return @"iPad Pro 12.9";
    if([platform isEqualToString:@"iPad6,8"]) return @"iPad Pro 12.9";
    if([platform isEqualToString:@"i386"]) return @"iPhone Simulator";
    if([platform isEqualToString:@"x86_64"]) return @"iPhone Simulator";
    return platform;
#endif
}

+ (NSString *) mq_device_model {
    return UIDevice.currentDevice.model;
}

+ (NSString *) mq_device_ip {
    NSString *s_address = @"an error occurred when obtaining ip address";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    success = getifaddrs(&interfaces);
    
    if (success == 0) { // 0 = success
        
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    s_address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    freeifaddrs(interfaces);
    return s_address;
}

+ (NSString *) mq_device_UUID {
    return UIDevice.currentDevice.identifierForVendor.UUIDString;
}

+ (NSString *) mq_device_IDFA {
    return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
}

+ (MQDeviceResolution) mq_device_resolution : (BOOL) is_landscape {
    CGFloat w = UIScreen.mainScreen.bounds.size.width;
    CGFloat h = UIScreen.mainScreen.bounds.size.height;
    CGFloat scale = UIScreen.mainScreen.scale;
    
    MQDeviceResolution resolution ;
    if (is_landscape) {
        resolution.width = h * scale ;
        resolution.height = w * scale ;
    }
    else {
        resolution.width = w * scale ;
        resolution.height = h * scale ;
    }
    resolution.scale = scale ;
    
    return resolution;
}

+ (NSString *) mq_device_rect {
    return NSStringFromCGRect(UIScreen.mainScreen.bounds);
}

+ (NSString *) mq_system_version {
    return UIDevice.currentDevice.systemVersion ;
}

+ (float) mq_battery_level {
    return UIDevice.currentDevice.batteryLevel;
}

+ (UIDeviceBatteryState) mq_battery_state {
    return UIDevice.currentDevice.batteryState;
}

+ (unsigned long long) mq_disk_total_size {
    struct statfs buf;
    unsigned long long s_total_space = -1;
    if (statfs("/var", &buf) >= 0)
    {
        s_total_space = (unsigned long long)(buf.f_bsize * buf.f_blocks);
    }
    return s_total_space;
}
+ (unsigned long long) mq_available_disk_size {
    struct statfs buf;
    unsigned long long ull_free_space = -1;
    if (statfs("/var", &buf) >= 0)
    {
        ull_free_space = (unsigned long long)(buf.f_bsize * buf.f_bavail);
    }
    return ull_free_space;
}
+ (unsigned long long) mq_available_memory {
    vm_statistics_data_t vm_stats;
    mach_msg_type_number_t info_count = HOST_VM_INFO_COUNT;
    kern_return_t kern_return = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vm_stats, &info_count);
    if (kern_return != KERN_SUCCESS) {
        return NSNotFound;
    }
    return ((vm_page_size * vm_stats.free_count + vm_page_size * vm_stats.inactive_count));
}
+ (unsigned long long) mq_current_memory_in_use {
    task_basic_info_data_t task_basic_info;
    mach_msg_type_number_t info_count = TASK_BASIC_INFO_COUNT;
    kern_return_t kern_return = task_info(mach_task_self(),
                                          TASK_BASIC_INFO,
                                          (task_info_t)&task_basic_info,
                                          &info_count);
    
    if (kern_return != KERN_SUCCESS) {
        return NSNotFound;
    }
    
    return task_basic_info.resident_size;
}
+ (unsigned long long) mq_total_memory {
    return [NSProcessInfo processInfo].physicalMemory;
}

+ (NSString *) mq_current_linked_ssid {
    NSString *s_wifi_name = nil;
    
    CFArrayRef wifi_inter_faces = CNCopySupportedInterfaces();
    if (!wifi_inter_faces) {
        return nil;
    }
    
    NSArray *interfaces = (__bridge NSArray *)wifi_inter_faces;
    
    for (NSString *interface_name in interfaces) {
        CFDictionaryRef dict_ref = CNCopyCurrentNetworkInfo((__bridge CFStringRef)(interface_name));
        
        if (dict_ref) {
            NSDictionary *networkInfo = (__bridge NSDictionary *)dict_ref;
            
            s_wifi_name = [networkInfo objectForKey:(__bridge NSString *)kCNNetworkInfoKeySSID];
            
            CFRelease(dict_ref);
        }
    }
    
    CFRelease(wifi_inter_faces);
    return s_wifi_name;
}

@end
