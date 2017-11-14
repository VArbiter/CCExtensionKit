//
//  CCDevice.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 14/11/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef CC_DEVICE_TYPE
    #define CC_DEVICE_TYPE [CCDeviceHelper ccDeviceType]
#endif

#ifndef CC_SYSTEM_VERSION
    #define CC_SYSTEM_VERSION [CCDeviceHelper ccSystemVersion]
#endif

#ifndef CC_DEVICE_UUID
    #define CC_DEVICE_UUID [CCDeviceHelper ccDeviceUUID]
#endif

#ifndef CC_DEVICE_RESOLUTION
    #define CC_DEVICE_RESOLUTION [CCDeviceHelper ccDeviceResolution]
#endif

#ifndef CC_DEVICE_RECT
    #define CC_DEVICE_RECT [CCDeviceHelper ccDeviceRect]
#endif

@interface CCDevice : NSObject

+ (NSString *) ccDeviceType ;

+ (NSString *) ccSystemVersion ;

+ (NSString *) ccDeviceUUID ;

+ (NSString *) ccDeviceResolution ;

+ (NSString *) ccDeviceRect ;

@end
