//
//  MQUpdateManager.m
//  MQExtensionKit
//
//  Created by ElwinFrederick on 09/05/2018.
//  Copyright © 2018 冯明庆. All rights reserved.
//

#import "MQUpdateManager.h"

static NSString * MQ_UPDATE_MANAGER_DOMAIN = @"Elwinfrederick.MQUpdateManager";

@interface MQUpdateManager ()

- (void) mq_error_with_code : (NSInteger) i_code
                description : (NSString *) s_description ;

- (NSURLSessionDataTask *) mq_start_request : (NSURLRequest *) request
                               update_block : (void (^)(BOOL is_need ,
                                                        NSString * s_version_current ,
                                                        NSString * s_version_store ,
                                                        NSString * s_open_link)) mq_update_block ;

@end

@implementation MQUpdateManager

MQUpdateResponseSerilzationKey MQ_UPDATE_RESPONSE_SERILZATION_KEY_RESULT_COUNT = @"resultCount" ;
MQUpdateResponseSerilzationKey MQ_UPDATE_RESPONSE_SERILZATION_KEY_RESULT_RESULTS = @"results" ;
MQUpdateResponseSerilzationKey MQ_UPDATE_RESPONSE_SERILZATION_KEY_ARTIST_ID = @"artistId" ;
MQUpdateResponseSerilzationKey MQ_UPDATE_RESPONSE_SERILZATION_KEY_BUNDLE_ID = @"bundleId" ;
MQUpdateResponseSerilzationKey MQ_UPDATE_RESPONSE_SERILZATION_KEY_ARTIST_NAME = @"artistName" ;
MQUpdateResponseSerilzationKey MQ_UPDATE_RESPONSE_SERILZATION_KEY_VERSION = @"version" ;
MQUpdateResponseSerilzationKey MQ_UPDATE_RESPONSE_SERILZATION_KEY_TRACK_NAME = @"trackName" ;
MQUpdateResponseSerilzationKey MQ_UPDATE_RESPONSE_SERILZATION_KEY_TRACK_VIEW_URL = @"trackViewUrl" ;

- (void) mq_check_update_with_link : (NSString *) s_link
                    need_to_update : (void (^)(BOOL is_need ,
                                               NSString * s_version_current ,
                                               NSString * s_version_store ,
                                               NSString * s_open_link)) mq_update_block {
    
    if (!s_link || s_link.length <= 0) {
        [self mq_error_with_code:-10000
                     description:@"app store link can't be nil or invalid."];
        return ;
    }
    
    dispatch_queue_t queue ;
    if (@available(iOS 10.0, *)) {
        queue = dispatch_queue_create("ElwinFrederick.MQUpdateManager.request.queue",
                                      DISPATCH_QUEUE_SERIAL_WITH_AUTORELEASE_POOL);
    }
    else {
        queue = dispatch_queue_create("ElwinFrederick.MQUpdateManager.request.queue",
                                      DISPATCH_QUEUE_SERIAL);
    }
    __weak typeof(self) weak_self = self ;
    dispatch_async(queue, ^{
        __strong typeof(weak_self) strong_self = weak_self;
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:s_link]];
        NSURLSessionDataTask *task = [strong_self mq_start_request:request
                                                      update_block:mq_update_block];
        [task resume];
    });
    
}

#pragma mark - -----

- (NSURLSessionDataTask *) mq_start_request : (NSURLRequest *) request
                               update_block : (void (^)(BOOL is_need ,
                                                        NSString * s_version_current ,
                                                        NSString * s_version_store ,
                                                        NSString * s_open_link)) mq_update_block {
    __weak typeof(self) weak_self = self ;
    NSURLSession *session = [NSURLSession sharedSession];
    return [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        __strong typeof(weak_self) strong_self = weak_self;
        
        if (error) {
            strong_self.mq_error_block(error) ;
            return ;
        }
        
        if (strong_self.mq_original_response_block) strong_self.mq_original_response_block(data);
        
        NSError *error_serialization = nil;
        NSDictionary *response_info_dic = [NSJSONSerialization JSONObjectWithData:data
                                                                          options:NSJSONReadingMutableLeaves
                                                                            error:&error_serialization];
        if (error_serialization) {
            strong_self.mq_error_block(error_serialization);
            return ;
        }
        
        if ([[response_info_dic valueForKey:MQ_UPDATE_RESPONSE_SERILZATION_KEY_RESULT_COUNT] integerValue] == 0) {
            [strong_self mq_error_with_code:-10001
                                description:@"app didn't in store or can't reach in this links."];
            return;
        }
        
        NSArray *array_infos = [response_info_dic valueForKey:MQ_UPDATE_RESPONSE_SERILZATION_KEY_RESULT_RESULTS];
        if (![array_infos isKindOfClass:[NSArray class]] && array_infos.count <= 0) {
            [strong_self mq_error_with_code:-10002
                                description:@"returned value doesn't have any results"];
            return;
        }
        
        NSDictionary *d_infos_detail = array_infos.firstObject ;
        if (![d_infos_detail isKindOfClass:[NSDictionary class]]) {
            [strong_self mq_error_with_code:-10002
                                description:@"returned value doesn't have any results"];
            return ;
        }
        
#if DEBUG
        NSLog(@" \
              apple server returned value : \n \
              appId = %@ \n \
              bundleId = %@ \n \
              developer account = %@ \n \
              store version = %@ \n \
              app name = %@ \n \
              open link = %@",
              [d_infos_detail valueForKey:MQ_UPDATE_RESPONSE_SERILZATION_KEY_ARTIST_ID],
              [d_infos_detail valueForKey:MQ_UPDATE_RESPONSE_SERILZATION_KEY_BUNDLE_ID],
              [d_infos_detail valueForKey:MQ_UPDATE_RESPONSE_SERILZATION_KEY_ARTIST_NAME],
              [d_infos_detail valueForKey:MQ_UPDATE_RESPONSE_SERILZATION_KEY_VERSION],
              [d_infos_detail valueForKey:MQ_UPDATE_RESPONSE_SERILZATION_KEY_TRACK_NAME],
              [d_infos_detail valueForKey:MQ_UPDATE_RESPONSE_SERILZATION_KEY_TRACK_VIEW_URL]);
#endif
        
        NSDictionary *d_info = [NSBundle.mainBundle infoDictionary];
        NSString *s_version_current = [d_info valueForKey:@"CFBundleShortVersionString"];
        
        NSString *s_app_store_version = [d_infos_detail valueForKey:MQ_UPDATE_RESPONSE_SERILZATION_KEY_VERSION] ;
        
        NSString *s_version_current_t = s_version_current.copy ;
        NSString *s_app_store_version_t = s_app_store_version.copy ;
        
        s_version_current_t = [s_version_current_t stringByReplacingOccurrencesOfString:@"." withString:@""];
        if (s_version_current_t.length == 2) {
            s_version_current_t = [s_version_current_t stringByAppendingString:@"0"];
        }
        else if (s_version_current_t.length == 1) {
            s_version_current_t = [s_version_current_t stringByAppendingString:@"00"];
        }
        
        s_app_store_version_t = [s_version_current_t stringByReplacingOccurrencesOfString:@"." withString:@""];
        if (s_app_store_version_t.length == 2) {
            s_app_store_version_t = [s_app_store_version_t stringByAppendingString:@"0"];
        }
        else if (s_version_current_t.length == 1) {
            s_app_store_version_t = [s_app_store_version_t stringByAppendingString:@"00"];
        }
        
        BOOL is_need_update = s_version_current_t.floatValue < s_app_store_version_t.floatValue;
        NSString *s_open_link = [d_infos_detail valueForKey:MQ_UPDATE_RESPONSE_SERILZATION_KEY_TRACK_VIEW_URL];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (mq_update_block) mq_update_block(is_need_update ,
                                                 s_version_current ,
                                                 s_app_store_version ,
                                                 s_open_link);
        });
    }];
}

- (void) mq_error_with_code : (NSInteger) i_code
                description : (NSString *) s_description {
    NSError *error_t = [NSError errorWithDomain:MQ_UPDATE_MANAGER_DOMAIN
                                           code:i_code
                                       userInfo:@{NSLocalizedDescriptionKey : s_description ? s_description : @""}];
    if (self.mq_error_block) self.mq_error_block(error_t);
}

- (void)dealloc {
#if DEBUG
    NSLog(@"%@ dealloc" , NSStringFromClass([self class]));
#endif
}

@end
