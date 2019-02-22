//
//  MQVideo_H264_HEVC_Encoder.m
//  MQExtension_Example
//
//  Created by 冯明庆 on 2019/2/21.
//  Copyright © 2019 ElwinFrederick. All rights reserved.
//

#import "MQVideo_H264_HEVC_Encoder.h"

@interface MQVideo_H264_HEVC_Encoder ()

@property (nonatomic , assign) VTCompressionSessionRef ref;
@property (nonatomic , strong) NSFileHandle *file_handle ;

void mq_compression_recall_function(void * CM_NULLABLE outputCallbackRefCon,
                                    void * CM_NULLABLE sourceFrameRefCon,
                                    OSStatus status,
                                    VTEncodeInfoFlags infoFlags,
                                    CM_NULLABLE CMSampleBufferRef sampleBuffer) ;

- (void) mq_write_data : (NSData *) data ;

@end

@implementation MQVideo_H264_HEVC_Encoder

{
    NSUInteger _i_frame_index;
    int32_t _i_fps ;
}

- (void) mq_prepare_file_path : (NSString *) s_file_path
                  encode_type : (CMVideoCodecType) type
                 encode_width : (int32_t) i_width
                encode_height : (int32_t) i_height
                   frame_rate : (int32_t) fps
                     bit_rate : (int32_t) bit_rate {
    
    self.file_handle = [NSFileHandle fileHandleForWritingAtPath:s_file_path];
    
    _i_frame_index = 0;
    _i_fps = fps;
    
    VTCompressionSessionCreate(kCFAllocatorDefault,
                               i_width,
                               i_height,
                               type,
                               NULL,
                               NULL,
                               NULL,
                               mq_compression_recall_function,
                               (__bridge void * _Nullable)(self),
                               &_ref);
    
    VTSessionSetProperty(_ref, kVTCompressionPropertyKey_RealTime, (__bridge CFTypeRef _Nullable)(@(false)));
    VTSessionSetProperty(_ref, kVTCompressionPropertyKey_ExpectedFrameRate, (__bridge CFTypeRef _Nullable)(@(fps)));
    VTSessionSetProperty(_ref, kVTCompressionPropertyKey_AverageBitRate, (__bridge CFTypeRef _Nullable)(@(bit_rate)));
    CFArrayRef array = (__bridge CFArrayRef _Nullable)(@[@(bit_rate / 8) , @(1)]);
    VTSessionSetProperty(_ref, kVTCompressionPropertyKey_DataRateLimits, array);
    VTSessionSetProperty(_ref, kVTCompressionPropertyKey_MaxKeyFrameInterval, (__bridge CFTypeRef _Nullable)(@(fps)));
    
    VTCompressionSessionPrepareToEncodeFrames(_ref);
    
}

void mq_compression_recall_function(void * CM_NULLABLE outputCallbackRefCon,
                                    void * CM_NULLABLE sourceFrameRefCon,
                                    OSStatus status,
                                    VTEncodeInfoFlags infoFlags,
                                    CM_NULLABLE CMSampleBufferRef sampleBuffer ) {
    MQVideo_H264_HEVC_Encoder *encoder = (__bridge MQVideo_H264_HEVC_Encoder *)(outputCallbackRefCon);
    
    CFArrayRef attachments = CMSampleBufferGetSampleAttachmentsArray(sampleBuffer, true);
    CFDictionaryRef dict_ref = CFArrayGetValueAtIndex(attachments, 0);
    Boolean is_key_frame = !CFDictionaryContainsKey(dict_ref, kCMSampleAttachmentKey_NotSync);
    
    if (is_key_frame) {
        
        // key frame , write sps / pps data
        
        CMFormatDescriptionRef desc_ref = CMSampleBufferGetFormatDescription(sampleBuffer);
        
        const uint8_t *sps_pointer ;
        size_t sps_size , sps_count;
        CMVideoFormatDescriptionGetH264ParameterSetAtIndex(desc_ref,
                                                           0,
                                                           &sps_pointer,
                                                           &sps_size,
                                                           &sps_count,
                                                           NULL);
        
        const uint8_t *pps_pointer ;
        size_t pps_size , pps_count;
        CMVideoFormatDescriptionGetH264ParameterSetAtIndex(desc_ref,
                                                           1,
                                                           &pps_pointer,
                                                           &pps_size,
                                                           &pps_count,
                                                           NULL);
        
        NSData * sps_data = [NSData dataWithBytes:sps_pointer length:sps_size];
        NSData * pps_data = [NSData dataWithBytes:pps_pointer length:pps_size];
        
        [encoder mq_write_data:sps_data];
        [encoder mq_write_data:pps_data];
    }
    
    // write encoded frame
    CMBlockBufferRef block_ref = CMSampleBufferGetDataBuffer(sampleBuffer);
    
    size_t total_length ;
    char * data_pointer ;
    CMBlockBufferGetDataPointer(block_ref,
                                0,
                                NULL,
                                &total_length,
                                &data_pointer);
    
    // slice
    static const int h264_header_length = 4;
    size_t offset_length = 0 ;
    
    while (h264_header_length < (total_length - offset_length)) {
        
        uint32_t nalu_length ;
        memcpy(&nalu_length, data_pointer + offset_length, h264_header_length);
        
        nalu_length = CFSwapInt32BigToHost(nalu_length);
        
        NSData *data_t = [NSData dataWithBytes:(data_pointer + offset_length + h264_header_length)
                                        length:nalu_length];
        
        [encoder mq_write_data:data_t];
        
        offset_length += (nalu_length + h264_header_length);
    }
}

- (void) mq_encoding_frame : (CMSampleBufferRef) sample_buffer {
    CVImageBufferRef image_ref = CMSampleBufferGetImageBuffer(sample_buffer);
    
    _i_frame_index ++;
    CMTime pts = CMTimeMake(_i_frame_index, _i_fps);
    
    VTCompressionSessionEncodeFrame(_ref,
                                    image_ref,
                                    pts,
                                    kCMTimeInvalid,
                                    NULL,
                                    NULL,
                                    NULL);
}
- (void) mq_end_encoding {
    VTCompressionSessionCompleteFrames(_ref, kCMTimeInvalid);
    VTCompressionSessionInvalidate(_ref);
    CFRelease(_ref);
    _ref = NULL;
}

#pragma mark - -----
- (void) mq_write_data : (NSData *) data {
    
    // NALU header
    const char bytes[] = "\x00\x00\x00\x01"; // \x00\x00\x00\x01\0
    int header_length = sizeof(bytes) - 1; // remove the length of '\0' , 移除 \0 的长度
    NSData *header_data = [NSData dataWithBytes:bytes length:header_length];
    [self.file_handle writeData:header_data];
    
    // NALU body
    [self.file_handle writeData:data];
}


@end
