//
//  CCVideoManager.h
//  CCLocalLibrary
//
//  Created by ElwinFrederick on 21/05/2018.
//  Copyright © 2018 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

@import AVFoundation;

@class CCVideoInfoEntity , CCVideoManager ;


@protocol CCVideoManagerDelegate < NSObject >

@required
- (void) cc_video_manager : (CCVideoManager *)manager
did_finish_with_output_url : (NSURL *) url_file ;

/*
@optional
- (void) cc_video_manager : (CCVideoManager *)manager
      finished_with_error : (NSError *) error ;
 */

@end

@interface CCVideoManager : NSObject

@property (nonatomic , assign) id <CCVideoManagerDelegate> delegate ;

/// @s_path requires full path with file name . // 要求使用完整的路径 和 文件名
/// manager won't detect if the file path exists or not . // 助手不会检测这个路径是否存在 .
/// make sure the "url_file_path" in each entity with params "array_file_urls" exists . // 保证 每个数组中元素 的 url_file_path 是存在的.
- (void)cc_merge_export_videos : (NSString *) s_path
                   data_stream : (NSArray <CCVideoInfoEntity *> *) array_file_urls ;

@end

#pragma mark - -----

@interface CCVideoInfoEntity : NSObject

@property (nonatomic , assign) CGFloat f_duration;
@property (nonatomic , strong) NSURL *url_file_path;

@end
