//
//  CCDiagnosticManager.h
//  CCExtensionKit
//
//  Created by ElwinFrederick on 2018/7/5.
//  Copyright © 2018 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CCDiagnosticManager ;

@protocol CCDiagnosticManagerDelegate < NSObject >

@optional
- (void) cc_diagnostic_manager : (CCDiagnosticManager *) manager
      collected_code_resources : (NSString *) s_resources
                         error : (NSError *) error ;

@end

@interface CCDiagnosticManager : NSObject

- (instancetype) init_default ;

- (void) cc_clean_logging_file_after : (NSInteger) i_days ;

/*
- (void) cc_add_request_logging : (NSString *) s_logging_name
                        request : (NSString *) s_requst_url
                         params : (id) params
                     begin_time : (NSTimeInterval) interval ;

- (void) cc_add_response_logging : (NSString *) s_logging_name
                         request : (NSString *) s_requst_url
                        response : (id) response
                        end_time : (NSTimeInterval) interval ;

- (void) cc_add_response_logging : (NSString *) s_logging_name
                         request : (NSString *) s_requst_url
                        end_time : (NSTimeInterval) interval
                           error : (NSError *) error ;

- (void) cc_add_user_event_logging : (NSString *) s_logging_name ;
 
  */

@property (nonatomic , assign) id < CCDiagnosticManagerDelegate > delegate_t ;

- (void) cc_begin_diagnosis ;

+ (NSString *) cc_code_resources_path ;
+ (NSString *) cc_code_resources ;
+ (NSString *) cc_diagnostic_logging_file_path ;

@end
