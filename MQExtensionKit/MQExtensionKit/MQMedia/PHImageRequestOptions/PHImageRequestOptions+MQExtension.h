//
//  PHImageRequestOptions+MQExtension.h
//  MQExtensionKit
//
//  Created by 冯明庆 on 2018/5/20.
//  Copyright © 2018 冯明庆. All rights reserved.
//

#import <Photos/Photos.h>

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0

@interface PHImageRequestOptions (MQExtension)

+ (instancetype) mq_common : (PHImageRequestOptionsDeliveryMode) mode_delivery ;

@end

#endif
