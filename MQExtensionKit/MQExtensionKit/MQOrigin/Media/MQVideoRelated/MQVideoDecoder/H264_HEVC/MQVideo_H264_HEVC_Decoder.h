//
//  MQVideo_H264_HEVC_Decoder.h
//  MQExtensionKit
//
//  Created by 冯明庆 on 2019/2/21.
//  Copyright © 2019 ElwinFrederick. All rights reserved.
//

#import <Foundation/Foundation.h>

@import UIKit;
@import VideoToolbox;
@import CoreMedia;

NS_ASSUME_NONNULL_BEGIN

@class MQVideo_H264_HEVC_Decoder;

@protocol MQVideo_H264_HEVC_DecoderDelegate <NSObject>

@required
- (void) mq_decoder : (MQVideo_H264_HEVC_Decoder *) decoder
             buffer : (CVImageBufferRef) image_buffer ;

@optional
- (void) mq_decoder : (MQVideo_H264_HEVC_Decoder *) decoder
      decode_failed : (NSError *) error ;

@end

/// Video ONLY , no audio .
@interface MQVideo_H264_HEVC_Decoder : NSObject

@property (nonatomic , assign) id <MQVideo_H264_HEVC_DecoderDelegate> delegate_t ;

#pragma mark -----

void mq_destory_decoder(MQVideo_H264_HEVC_Decoder *decoder);

// before start decode , you have yo close the previous decode session before .

/// stream : input stream .
/// max_read_size : eg : 1280 * 720 , 1920 * 1080 , etc .
/// i_preferred_frames_per_second : 15 / 20 / 30 / 60
- (void) mq_start_decode_by_stream : (NSInputStream *) stream
                     max_read_size : (size_t) max_read_size
      preferred_frames_per_seconds : (NSInteger) i_preferred_frames_per_second ;

- (void) mq_stop_decode ;

@end

NS_ASSUME_NONNULL_END
