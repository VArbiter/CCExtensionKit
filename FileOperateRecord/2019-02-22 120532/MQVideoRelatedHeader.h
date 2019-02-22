//
//  MQVideoRelatedHeader.h
//  MQExtension_Example
//
//  Created by 冯明庆 on 2019/2/21.
//  Copyright © 2019 ElwinFrederick. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger , MQVideoCodingType) {
    MQVideoCodingType_Default = 0,
    MQVideoCodingType_H264 ,
    MQVideoCodingType_HEVC // H265
};

NS_ASSUME_NONNULL_BEGIN

@interface MQVideoRelatedHeader : NSObject

@end

NS_ASSUME_NONNULL_END
