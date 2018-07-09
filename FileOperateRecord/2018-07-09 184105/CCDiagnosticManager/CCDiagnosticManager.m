//
//  CCDiagnosticManager.m
//  CCExtensionKit
//
//  Created by ElwinFrederick on 2018/7/5.
//  Copyright © 2018 冯明庆. All rights reserved.
//

#import "CCDiagnosticManager.h"

static NSString *CC_DIAGNOSTIC_MANAGER_DOMAIN = @"ElwinFrederick.CCDiagnosticManager";
static NSString *CC_DIAGNOSTIC_CLEAN_DAYS_KEY = @"CC_DIAGNOSTIC_CLEAN_DAYS_KEY";

@interface CCDiagnosticManager ()

- (void) cc_begin_require_code_resources ;

@property (nonatomic , assign) NSInteger i_days_clean ;

@end

@implementation CCDiagnosticManager

+ (void)initialize {
    NSFileManager *manager = [NSFileManager defaultManager];
    
    NSString *s_logging_path = [self cc_diagnostic_logging_file_path];
    
    BOOL isDir = false;
    if ([manager fileExistsAtPath:s_logging_path
                      isDirectory:&isDir]) {
        if (!isDir) {
            [manager removeItemAtPath:s_logging_path error:nil];
        }
    }
    
    if (!isDir) {
        [manager createDirectoryAtPath:s_logging_path
           withIntermediateDirectories:YES
                            attributes:nil
                                 error:nil];
    }
}

- (instancetype) init_default {
    if ((self = [super init])) {
        self.i_days_clean = [NSUserDefaults.standardUserDefaults integerForKey:CC_DIAGNOSTIC_CLEAN_DAYS_KEY];
    }
    return self;
}

- (void) cc_begin_diagnosis {
    
    [self cc_begin_require_code_resources];
    
}

- (void) cc_clean_logging_file_after : (NSInteger) i_days {
    [NSUserDefaults.standardUserDefaults setInteger:i_days
                                             forKey:CC_DIAGNOSTIC_CLEAN_DAYS_KEY];
}

- (void)cc_begin_require_code_resources {
    NSString *s_resources = [CCDiagnosticManager cc_code_resources];
    if (!s_resources || !s_resources.length) {
        NSString *s = @"CCDiagnosticManager can't get the code resources of this app";
        NSError * error = [NSError errorWithDomain:CC_DIAGNOSTIC_MANAGER_DOMAIN
                                              code:-10001
                                          userInfo:@{NSLocalizedDescriptionKey : s}];
        if (self.delegate_t
            && [self.delegate_t respondsToSelector:@selector(cc_diagnostic_manager:collected_code_resources:error:)]) {
            [self.delegate_t cc_diagnostic_manager:self
                          collected_code_resources:nil
                                             error:error];
        }
    }
    else {
        if (self.delegate_t
            && [self.delegate_t respondsToSelector:@selector(cc_diagnostic_manager:collected_code_resources:error:)]) {
            [self.delegate_t cc_diagnostic_manager:self
                          collected_code_resources:s_resources
                                             error:nil];
        }
    }
}

+ (NSString *) cc_code_resources_path {
    NSString *s_bundle_resources_path = [NSBundle.mainBundle resourcePath];
    NSString *s_path = [[s_bundle_resources_path stringByAppendingPathComponent:@"_CodeSignature"]
                        stringByAppendingPathComponent:@"CodeResources"];
    return s_path;
}

+ (NSString *) cc_code_resources {
    NSFileManager *manager = [NSFileManager defaultManager];
    NSData *data = [manager contentsAtPath:[self cc_code_resources_path]];
    NSString *s_file = [[NSString alloc] initWithData:data
                                             encoding:NSUTF8StringEncoding];
    return s_file;
}

+ (NSString *) cc_diagnostic_logging_file_path {
    NSString *s_log_path = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory ,
                                                                   NSUserDomainMask,
                                                                   YES).firstObject
                               stringByAppendingPathComponent:@"CCExtensionKit"]
                              stringByAppendingPathComponent:@"CCDiagnosisLog"];
    return s_log_path;
}

@end
