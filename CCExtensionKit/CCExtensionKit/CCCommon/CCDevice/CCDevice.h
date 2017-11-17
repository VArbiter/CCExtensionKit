//
//  CCDevice.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 14/11/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef CC_DEVICE_TYPE_S
    #define CC_DEVICE_TYPE_S [CCDeviceHelper ccDeviceType]
#endif

#ifndef CC_SYSTEM_VERSION_S
    #define CC_SYSTEM_VERSION_S [CCDeviceHelper ccSystemVersion]
#endif

#ifndef CC_DEVICE_UUID_S
    #define CC_DEVICE_UUID_S [CCDeviceHelper ccDeviceUUID]
#endif

#ifndef CC_DEVICE_RESOLUTION_S
    #define CC_DEVICE_RESOLUTION_S [CCDeviceHelper ccDeviceResolution]
#endif

#ifndef CC_DEVICE_RECT_S
    #define CC_DEVICE_RECT_S [CCDeviceHelper ccDeviceRect]
#endif

@interface CCDevice : NSObject

+ (NSString *) ccDeviceType ;

+ (NSString *) ccSystemVersion ;

+ (NSString *) ccDeviceUUID ;

+ (NSString *) ccDeviceResolution ;

+ (NSString *) ccDeviceRect ;

@end
