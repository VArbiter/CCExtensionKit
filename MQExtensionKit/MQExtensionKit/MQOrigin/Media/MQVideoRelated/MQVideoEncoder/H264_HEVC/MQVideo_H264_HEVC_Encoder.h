//
//  MQVideo_H264_HEVC_Encoder.h
//  MQExtension_Example
//
//  Created by 冯明庆 on 2019/2/21.
//  Copyright © 2019 ElwinFrederick. All rights reserved.
//

#import <Foundation/Foundation.h>

@import VideoToolbox;
@import CoreMedia;

NS_ASSUME_NONNULL_BEGIN

// note :
//      VLC player ( https://www.videolan.org ) might got speed of the vids ( encoded by this file) faster than normal .
//      VLC 播放器 ( https://www.videolan.org ) 可能会将视频 (这个文件编码的) 的速度变快 .

@interface MQVideo_H264_HEVC_Encoder : NSObject

// have to make sure that filepath exists . (not file .) // 保证路径存在 (不是文件存在)
- (void) mq_prepare_file_path : (NSString *) s_file_path
                  encode_type : (CMVideoCodecType) type
                     for_live : (BOOL) is_for_live
                 encode_width : (int32_t) i_width
                encode_height : (int32_t) i_height
                   frame_rate : (int32_t) fps
                     bit_rate : (int32_t) bit_rate ;

- (void) mq_encoding_frame : (CMSampleBufferRef) sample_buffer ;
- (void) mq_end_encoding ;

@end

NS_ASSUME_NONNULL_END
