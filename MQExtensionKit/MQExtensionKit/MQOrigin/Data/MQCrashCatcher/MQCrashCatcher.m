//
//  MQCrashCatcher.m
//  MQExtensionKit
//
//  Created by ElwinFrederick on 2018/6/26.
//  Copyright © 2018 冯明庆. All rights reserved.
//

#import "MQCrashCatcher.h"

@interface MQCrashCatcher ()

void mq_uncaught_exception_handler(NSException *exception);

@end

@implementation MQCrashCatcher

+ (void)initialize {
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    NSString *s_catch_path = [self mq_crash_folder_path];
    
    BOOL isDir = false;
    if ([manager fileExistsAtPath:s_catch_path
                      isDirectory:&isDir]) {
        if (!isDir) {
            [manager removeItemAtPath:s_catch_path error:nil];
        }
    }
    
    if (!isDir) {
        [manager createDirectoryAtPath:s_catch_path
           withIntermediateDirectories:YES
                            attributes:nil
                                 error:nil];
    }
    
}

+ (void) mq_begin {
    NSSetUncaughtExceptionHandler(&mq_uncaught_exception_handler);
#if DEBUG
    NSLog(@"MQCrashCatcher Start");
#endif
}

+ (NSArray <NSString *> *) mq_all_crash_log_path {
    NSFileManager *manager = [NSFileManager defaultManager];
    NSError *e = nil;
    NSArray <NSString *> *array = [manager contentsOfDirectoryAtPath:manager.currentDirectoryPath
                                                               error:&e];
    
    NSMutableArray <NSString *> *array_t = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *s = [[self mq_crash_folder_path] stringByAppendingPathComponent:obj];
        if (s) [array_t addObject:s];
    }];
    
    if (e) {
#if DEBUG
        NSLog(@"MQException read crash log error :\n %@",e);
#endif
        return nil;
    }
    return array_t;
}

+ (NSString *) mq_crash_folder_path {
    NSString *s_catch_path = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory ,
                                                                   NSUserDomainMask,
                                                                   YES).firstObject
                               stringByAppendingPathComponent:@"MQExtensionKit"]
                              stringByAppendingPathComponent:@"MQCrashLog"];
    return s_catch_path;
}

void mq_uncaught_exception_handler(NSException *exception) {
    NSString *s_exception = [NSString stringWithFormat:@"MQException name:%@\n \
                             MQException reason:%@\n \
                             MQException stack :%@\n \
                             MQException time  :%lf",
                             exception.name,
                             exception.reason,
                             exception.callStackSymbols,
                             NSDate.date.timeIntervalSince1970 * 1000];
#if DEBUG
    NSLog(@"%@",s_exception);
#endif
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy_MM_dd_HH_mm_ss"];
    NSString *s_file_name = [[format stringFromDate:NSDate.date] stringByAppendingString:@"_error.log"];
    
    NSError *e ;
    if ([s_exception writeToFile:s_file_name
                      atomically:YES
                        encoding:NSUTF8StringEncoding
                           error:&e]) {
#if DEBUG
        NSLog(@"MQException write error :\n %@",e);
#endif
    }
}

@end
