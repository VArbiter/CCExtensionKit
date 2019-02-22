//
//  MQVideo_H264_HEVC_Decoder.m
//  MQExtensionKit
//
//  Created by 冯明庆 on 2019/2/21.
//  Copyright © 2019 ElwinFrederick. All rights reserved.
//

#import "MQVideo_H264_HEVC_Decoder.h"

@interface MQVideo_H264_HEVC_Decoder ()

@property (nonatomic , strong) NSInputStream *input_stream ;
@property (nonatomic , weak) CADisplayLink *display_link ;
@property (nonatomic , assign) dispatch_queue_t queue;

@property (nonatomic, assign) VTDecompressionSessionRef session_ref;
@property (nonatomic, assign) CMFormatDescriptionRef desc_ref;

- (void) mq_prepare ;
- (void) mq_display_link_update_frame_action : (CADisplayLink *) sender ;
- (void) mq_read_package ;
- (void) mq_init_decode_session ;
- (CVImageBufferRef) mq_decode_frame ;

void mq_decompression_callback(void * CM_NULLABLE decompressionOutputRefCon,
                               void * CM_NULLABLE sourceFrameRefCon,
                               OSStatus status,
                               VTDecodeInfoFlags infoFlags,
                               CM_NULLABLE CVImageBufferRef imageBuffer,
                               CMTime presentationTimeStamp,
                               CMTime presentationDuration );

@end

@implementation MQVideo_H264_HEVC_Decoder

{
    size_t _packet_size ;
    uint8_t *_packet_buffer_pointer ;
    
    size_t _max_read_size ;
    size_t _remain_size ;
    uint8_t *_data_pointer ;
    
    uint8_t *_pointer_SPS;
    size_t _size_SPS;
    
    uint8_t *_pointer_PPS;
    size_t _size_PPS;
 
    NSInteger _i_preferred_frames_per_second;
}

const char __mq_start_flag[] = "\x00\x00\x00\x01";
static NSString * __s_error_domain = @"MQExtensionKit.MQVideo_H264_HEVC_Decoder.Error";

void mq_close_decode(MQVideo_H264_HEVC_Decoder *decoder) {
    if (decoder.display_link) {
        [decoder.display_link setPaused:YES];
        [decoder.display_link invalidate];
        decoder.display_link = nil;
    }
    if (decoder.input_stream) {
        [decoder.input_stream close];
        decoder.input_stream = nil;
    }
    free(decoder->_data_pointer);
    decoder = nil;
}

- (void) mq_start_decode_by_stream : (NSInputStream *) stream
                     max_read_size : (size_t) max_read_size
      preferred_frames_per_seconds : (NSInteger) i_preferred_frames_per_second {
    
    if (!stream) {
        if (self.delegate_t &&
            [self.delegate_t respondsToSelector:@selector(mq_decoder:decode_failed:)]) {
            [self.delegate_t mq_decoder:self
                          decode_failed:[NSError errorWithDomain:__s_error_domain
                                                            code:-1000
                                                        userInfo:@{NSLocalizedDescriptionKey : @"input stream can't be nil"}]];
        }
        return ;
    }
    
    [self mq_stop_decode];
    
    self.input_stream = stream;
    _i_preferred_frames_per_second = i_preferred_frames_per_second;
    
    [self mq_prepare];
    
    _max_read_size = max_read_size;
    _remain_size = 0;
    _data_pointer = malloc(_max_read_size);
    
    [_input_stream open];
    [_display_link setPaused:false];
}

- (void) mq_stop_decode {
    if (_display_link) {
        [self.display_link setPaused:YES];
        [self.display_link invalidate];
    }
    if (_input_stream) {
        [self.input_stream close];
    }
}

#pragma mark - -----

- (void) mq_prepare {
    CADisplayLink *t = [CADisplayLink displayLinkWithTarget:self selector:@selector(mq_display_link_update_frame_action:)];
    
    if (60 % _i_preferred_frames_per_second != 0) {
        _i_preferred_frames_per_second = 30;
    }
    
    if (@available(iOS 10.0 , *)) {
        [t setPreferredFramesPerSecond:_i_preferred_frames_per_second];
    }
    else {
        [t setFrameInterval:(60 / _i_preferred_frames_per_second)];
    }
    
    [t addToRunLoop:[NSRunLoop mainRunLoop]
            forMode:NSRunLoopCommonModes];
    [t setPaused:YES];
    _display_link = t;
    
    _queue = dispatch_get_global_queue(0, 0);
}

- (void) mq_display_link_update_frame_action : (CADisplayLink *) sender {
    dispatch_sync(_queue, ^{
        
        [self mq_read_package];
        
        if (self->_packet_size == 0
            || self->_packet_buffer_pointer == NULL) {
            
            [self mq_stop_decode];
            
            if (self.delegate_t &&
                [self.delegate_t respondsToSelector:@selector(mq_decoder:decode_failed:)]) {
                [self.delegate_t mq_decoder:self
                              decode_failed:[NSError errorWithDomain:__s_error_domain
                                                                code:-1000
                                                            userInfo:@{NSLocalizedDescriptionKey : @"read nothing from stream or file is empty ."}]];
            }
            
            return ;
        }
        
        uint32_t nal_body_size = (uint32_t)(self->_packet_size - 4);
        
        uint32_t *pointer_nal_size = (uint32_t *)self->_packet_buffer_pointer;
        *pointer_nal_size = CFSwapInt32HostToBig(nal_body_size);

        int nal_type = self->_packet_buffer_pointer[4] & 0x1F;
        CVImageBufferRef image_buffer = NULL;
        switch (nal_type) {
            case 0x07: { // SPS
                self->_size_SPS = self->_packet_size - 4;
                self->_pointer_SPS = malloc(self->_size_SPS);
                memcpy(self->_pointer_SPS, self->_packet_buffer_pointer + 4, self->_size_SPS);
            }break;
            case 0x08: { // PPS
                self->_size_PPS = self->_packet_size - 4;
                self->_pointer_PPS = malloc(self->_size_PPS);
                memcpy(self->_pointer_PPS, self->_packet_buffer_pointer + 4, self->_size_PPS);
            }break;
            case 0x05: { // I
                [self mq_init_decode_session];
                image_buffer = [self mq_decode_frame];
            }break;
            default: { // P , B
                image_buffer = [self mq_decode_frame];
            }break;
        }
        
        if (image_buffer != NULL) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.delegate_t
                    && [self.delegate_t respondsToSelector:@selector(mq_decoder:buffer:)]) {
                    [self.delegate_t mq_decoder:self buffer:image_buffer];
                }
                CFRelease(image_buffer);
            });
        }
        
    });
}

- (void) mq_read_package {
    
    if (_packet_size != 0 || _packet_buffer_pointer != NULL) {
        _packet_size = 0;
        free(_packet_buffer_pointer);
        _packet_buffer_pointer = NULL;
    }
    
    if (_remain_size < _max_read_size
        && _input_stream.hasBytesAvailable) {
        _remain_size += [_input_stream read:(_data_pointer + _remain_size)
                                  maxLength:(_max_read_size - _remain_size)];
    }
    
    if (memcmp(_data_pointer, __mq_start_flag, 4) == 0) {
        if (_remain_size > 4) {
            uint8_t *start_pointer = _data_pointer + 4;
            uint8_t *end_pointer = _data_pointer + _remain_size;
            while (start_pointer != end_pointer) {
                if(memcmp(start_pointer - 3, __mq_start_flag, 4) == 0) { // if it is the beginning
                    _packet_size = start_pointer - 3 - _data_pointer;
                    _packet_buffer_pointer = malloc(_packet_size);
                    memcpy(_packet_buffer_pointer, _data_pointer, _packet_size);
                    memmove(_data_pointer, _data_pointer + _packet_size, _remain_size - _packet_size);
                    _remain_size -= _packet_size;
                    break;
                } else {
                    ++ start_pointer;
                }
            }
        }
    }
}

- (void) mq_init_decode_session {
    
    const uint8_t *parameter_set_pointers[2] = {_pointer_SPS, _pointer_PPS};
    const size_t parameter_set_sizes[2] = {_size_SPS, _size_PPS};
    
    CMVideoFormatDescriptionCreateFromH264ParameterSets(kCFAllocatorDefault,
                                                        2,
                                                        parameter_set_pointers,
                                                        parameter_set_sizes,
                                                        4, // header length
                                                        &_desc_ref);
    
    VTDecompressionOutputCallbackRecord callback_record;
    callback_record.decompressionOutputCallback = mq_decompression_callback;
    
    NSDictionary *attr = @{(__bridge NSString *) kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)};
    
    VTDecompressionSessionCreate(kCFAllocatorDefault,
                                 _desc_ref,
                                 NULL,
                                 (__bridge CFDictionaryRef _Nullable)(attr),
                                 &callback_record,
                                 &_session_ref);
}

void mq_decompression_callback(void * CM_NULLABLE decompressionOutputRefCon,
                               void * CM_NULLABLE sourceFrameRefCon,
                               OSStatus status,
                               VTDecodeInfoFlags infoFlags,
                               CM_NULLABLE CVImageBufferRef imageBuffer,
                               CMTime presentationTimeStamp,
                               CMTime presentationDuration ){
    CVPixelBufferRef *pointer = (CVPixelBufferRef *)sourceFrameRefCon;
    *pointer = CVBufferRetain(imageBuffer); // otherwise system will release it . and cause crash .
}

- (CVImageBufferRef) mq_decode_frame {
    
    CMBlockBufferRef block_buffer = NULL;
    CMBlockBufferCreateWithMemoryBlock(kCFAllocatorDefault,
                                       (void *)_packet_buffer_pointer,
                                       _packet_size,
                                       kCFAllocatorNull,
                                       NULL,
                                       0,
                                       _packet_size,
                                       0,
                                       &block_buffer);
    
    CMSampleBufferRef sample_buffer = NULL;
    const size_t sample_size_array[] = {_packet_size};
    CMSampleBufferCreateReady(kCFAllocatorDefault,
                              block_buffer,
                              _desc_ref,
                              0,
                              0,
                              NULL,
                              0,
                              sample_size_array,
                              &sample_buffer);
    
    CVPixelBufferRef output_pixel_buffer = NULL;
    VTDecompressionSessionDecodeFrame(_session_ref,
                                      sample_buffer,
                                      0,
                                      &output_pixel_buffer,
                                      NULL);
    
    CFRelease(sample_buffer);
    CFRelease(block_buffer);
    
    return output_pixel_buffer;
}

@end
