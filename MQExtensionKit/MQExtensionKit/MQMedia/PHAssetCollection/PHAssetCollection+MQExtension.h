//
//  PHAssetCollection+MQExtension.h
//  MQExtensionKit
//
//  Created by 冯明庆 on 2018/5/20.
//  Copyright © 2018 冯明庆. All rights reserved.
//

#import <Photos/Photos.h>

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0

@interface PHAssetCollection (CCExtension)

- (void) mq_thumbnail_with_size : (CGSize) size
                       complete : (void (^)(NSString * s_title ,
                                            NSUInteger i_count ,
                                            UIImage * image)) block_complete ;
- (void) mq_thumbnail_with_size : (CGSize) size
                           mode : (PHImageRequestOptionsDeliveryMode) mode
                       complete : (void (^)(NSString * s_title ,
                                            NSUInteger i_count ,
                                            UIImage * image)) block_complete ;

@end

#endif
