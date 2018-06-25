//
//  CCAudioRecorder.h
//  CCLocalLibrary
//
//  Created by ElwinFrederick on 2018/6/25.
//  Copyright © 2018 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

@import AVFoundation;

@interface CCAudioRecorder : NSObject

- (instancetype) init_default_path ;

@property (nonatomic , copy , readonly) NSString *s_file_path ;
@property (nonatomic , copy) NSString *s_file_name ;
@property (nonatomic , copy , readonly) NSString *s_full_file_name ;
@property (nonatomic , readonly) NSString *s_audio_length ;

- (NSString *) cc_generate_file_name : (BOOL) is_need_date;
- (void) cc_reset_file_name ;

- (void) cc_begin_recorde ;
- (void) cc_end_recorde ;
- (void) cc_end_recorde : (void (^)(NSString *s_audio_path)) cc_complete_block ;

- (void) cc_play_recorde_audio ;
- (void) cc_pause_recorde_audio ;

@end
