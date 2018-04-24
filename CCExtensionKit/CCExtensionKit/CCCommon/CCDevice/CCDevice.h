//
//  CCDevice.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 14/11/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

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

@interface CCDevice : NSObject

+ (NSString *) cc_device_info ;

+ (NSString *) cc_device_type ;

+ (NSString *) cc_system_version ;

+ (NSString *) cc_device_UUID ;

+ (NSString *) cc_device_resolution ;

+ (NSString *) cc_device_rect ;

@end
