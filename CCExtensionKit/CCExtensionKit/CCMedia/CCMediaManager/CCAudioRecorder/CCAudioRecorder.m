//
//  CCAudioRecorder.m
//  CCLocalLibrary
//
//  Created by ElwinFrederick on 2018/6/25.
//  Copyright © 2018 冯明庆. All rights reserved.
//

#import "CCAudioRecorder.h"

@interface CCAudioRecorder ()

@property (nonatomic, strong) AVAudioSession *session ;
@property (nonatomic, strong) AVAudioRecorder *recorder ;
@property (nonatomic, strong) AVAudioPlayer *player ;

@property (nonatomic , copy , readwrite) NSString *s_file_path ;
@property (nonatomic , strong) NSURL *url_file_path ;
@property (nonatomic , copy , readwrite) NSString *s_full_file_name ;

@end

@implementation CCAudioRecorder

static NSString * __s_audio_path = nil;

+ (void)initialize {
    NSString *path = NSTemporaryDirectory();
    __s_audio_path = [NSString stringWithFormat:@"%@/record_audio",path];
    NSFileManager *t_manager = [NSFileManager defaultManager];
    BOOL is_directory = false;
    if ([t_manager fileExistsAtPath:__s_audio_path isDirectory:&is_directory]) {
        
    }
    if (is_directory) return;
    else [t_manager createDirectoryAtPath:__s_audio_path
              withIntermediateDirectories:YES
                               attributes:nil
                                    error:nil];
}

- (instancetype) init_default_path {
    if ((self = [super init])) {
        
    }
    return self;
}

- (void) cc_begin_recorde {
    
    [self cc_end_recorde];
    [self cc_reset_file_name];
    
    NSError *e;
    [self.session setCategory:AVAudioSessionCategoryPlayAndRecord error:&e];
    if (e) NSLog(@"%@",e);
    
    NSFileManager *t_manager = [NSFileManager defaultManager];
    if ([t_manager fileExistsAtPath:self.s_file_path isDirectory:NULL]) {
        NSError *error = nil;
        [t_manager removeItemAtPath:self.s_file_path error:&error];
        if (error) NSLog(@"%@",error);
    }
    
    [self.recorder prepareToRecord];
    [self.recorder record];
    
}
- (void) cc_end_recorde {
    [self cc_end_recorde:nil];
}
- (void) cc_end_recorde : (void (^)(NSString *s_audio_path)) cc_complete_block {
    if ([self.recorder isRecording]) {
        [self.recorder stop];
    }
    if (cc_complete_block) cc_complete_block(self.s_file_path);
}

- (void) cc_play_recorde_audio {
    [self cc_end_recorde];
    
    NSError *e = nil;
    AVAudioPlayer *t = [[AVAudioPlayer alloc] initWithContentsOfURL:self.url_file_path
                                                              error:&e];
    if (e) NSLog(@"%@",e);
    self.player = t;
    
    [self.session setCategory:AVAudioSessionCategoryPlayback error:&e];
    if (e) NSLog(@"%@",e);
    [self.player play];
}
- (void) cc_pause_recorde_audio {
    if (self.player.isPlaying) {
        [self.player stop];
    }
}

- (AVAudioRecorder *)recorder {
    if (_recorder) return _recorder;
    NSDictionary *setting = @{AVSampleRateKey : @8000.f,
                              AVFormatIDKey : @(kAudioFormatLinearPCM),
                              AVLinearPCMBitDepthKey : @16,
                              AVNumberOfChannelsKey : @1,
                              AVEncoderAudioQualityKey : @(AVAudioQualityHigh)};
    
    NSError *e ;
    AVAudioRecorder *t = [[AVAudioRecorder alloc] initWithURL:self.url_file_path
                                                     settings:setting
                                                        error:&e];
    t.meteringEnabled = YES;
    if (e) NSLog(@"%@",e);
    _recorder = t;
    return _recorder;
}

- (NSString *)s_audio_length {
    if (self.player) return @((NSUInteger)self.player.duration).stringValue;
    return @"0";
}

- (AVAudioSession *)session {
    if (_session) return _session;
    AVAudioSession *t = [AVAudioSession sharedInstance];
    NSError *e;
    if (t) [t setActive:YES error:&e];
    if (e) NSLog(@"%@",e);
    _session = t;
    return _session;
}

- (NSURL *)url_file_path {
    if (_url_file_path) return _url_file_path;
    NSURL *t = [NSURL fileURLWithPath:self.s_file_path];
    _url_file_path = t;
    return _url_file_path;
}

- (NSString *)s_file_path {
    if (_s_file_path) return _s_file_path;
    _s_file_path = [__s_audio_path stringByAppendingPathComponent:self.s_file_name];
    return _s_file_path;
}

- (NSString *)s_file_name {
    if (_s_file_name) return _s_file_name;
    self.s_full_file_name = [self cc_generate_file_name:YES];
    _s_file_name = [self.s_full_file_name componentsSeparatedByString:@"/"].lastObject;
    return _s_file_name;
}

- (NSString *) cc_generate_file_name : (BOOL) is_need_date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    
    NSString *s_name = @"";
    NSDate *date = [NSDate date];
    if (is_need_date) {
        [formatter setDateFormat:@"YYYYMMdd"];
        NSString *s_prefix = [formatter stringFromDate:date];
        s_name = [[s_name stringByAppendingString:s_prefix] stringByAppendingString:@"/"];
    }
    NSString *s_time_stap = @((long)[date timeIntervalSince1970]).stringValue;
    s_name = [[s_name stringByAppendingString:s_time_stap] stringByAppendingString:@"_audio.wav"];
    return s_name;
}

- (void)cc_reset_file_name {
    _s_file_name = nil;
}

@end
