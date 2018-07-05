//
//  CCCrashCatcher.m
//  CCLocalLibrary
//
//  Created by ElwinFrederick on 2018/6/26.
//  Copyright © 2018 冯明庆. All rights reserved.
//

#import "CCCrashCatcher.h"

@interface CCCrashCatcher ()

void cc_uncaught_exception_handler(NSException *exception);

@end

@implementation CCCrashCatcher

+ (void)initialize {
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    NSString *s_catch_path = [self cc_crash_folder_path];
    
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

+ (void) cc_begin {
    NSSetUncaughtExceptionHandler(&cc_uncaught_exception_handler);
#if DEBUG
    NSLog(@"CCCrashCatcher Start");
#endif
}

+ (NSArray <NSString *> *) cc_all_crash_log_path {
    NSFileManager *manager = [NSFileManager defaultManager];
    NSError *e = nil;
    NSArray <NSString *> *array = [manager contentsOfDirectoryAtPath:manager.currentDirectoryPath
                                                               error:&e];
    
    NSMutableArray <NSString *> *array_t = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *s = [[self cc_crash_folder_path] stringByAppendingPathComponent:obj];
        if (s) [array_t addObject:s];
    }];
    
    if (e) {
#if DEBUG
        NSLog(@"CCException read crash log error :\n %@",e);
#endif
        return nil;
    }
    return array_t;
}

+ (NSString *) cc_crash_folder_path {
    NSString *s_catch_path = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory ,
                                                                   NSUserDomainMask,
                                                                   YES).firstObject
                               stringByAppendingPathComponent:@"CCExtensionKit"]
                              stringByAppendingPathComponent:@"CCCrashLog"];
    return s_catch_path;
}

void cc_uncaught_exception_handler(NSException *exception) {
    NSString *s_exception = [NSString stringWithFormat:@"CCException name:%@\n \
                             CCException reason:%@\n \
                             CCException stack :%@\n \
                             CCException time  :%lf",
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
        NSLog(@"CCException write error :\n %@",e);
#endif
    }
}

@end
