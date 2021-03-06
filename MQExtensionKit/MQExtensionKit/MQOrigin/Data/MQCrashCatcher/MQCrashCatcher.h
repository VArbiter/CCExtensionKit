//
//  MQCrashCatcher.h
//  MQExtensionKit
//
//  Created by ElwinFrederick on 2018/6/26.
//  Copyright © 2018 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MQCrashCatcher : NSObject

/// initialize , invoke it in the very beginning (eg: AppDelegate / + (load) ).// 初始化. 在最开始调用
+ (void) mq_begin ;

/// get all crash logs . // 获得所有的崩溃日志路径
+ (NSArray <NSString *> *) mq_all_crash_log_path ;

/// get crash log folder path . // 获得奔溃日志文件夹路径 .
+ (NSString *) mq_crash_folder_path ;

@end
