//
//  CCUpdateManager.h
//  CCExtensionKit
//
//  Created by ElwinFrederick on 09/05/2018.
//  Copyright © 2018 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSString * CCUpdateResponseSerilzationKey NS_EXTENSIBLE_STRING_ENUM;

@interface CCUpdateManager : NSObject

FOUNDATION_EXPORT CCUpdateResponseSerilzationKey CC_UPDATE_RESPONSE_SERILZATION_KEY_RESULT_COUNT ; // @"resultCount"
FOUNDATION_EXPORT CCUpdateResponseSerilzationKey CC_UPDATE_RESPONSE_SERILZATION_KEY_RESULT_RESULTS ; // @"results"
FOUNDATION_EXPORT CCUpdateResponseSerilzationKey CC_UPDATE_RESPONSE_SERILZATION_KEY_ARTIST_ID ; // @"artistId"
FOUNDATION_EXPORT CCUpdateResponseSerilzationKey CC_UPDATE_RESPONSE_SERILZATION_KEY_BUNDLE_ID ; // @"bundleId"
FOUNDATION_EXPORT CCUpdateResponseSerilzationKey CC_UPDATE_RESPONSE_SERILZATION_KEY_ARTIST_NAME ; // @"artistName"
FOUNDATION_EXPORT CCUpdateResponseSerilzationKey CC_UPDATE_RESPONSE_SERILZATION_KEY_VERSION ; // @"version"
FOUNDATION_EXPORT CCUpdateResponseSerilzationKey CC_UPDATE_RESPONSE_SERILZATION_KEY_TRACK_NAME ; // @"trackName"
FOUNDATION_EXPORT CCUpdateResponseSerilzationKey CC_UPDATE_RESPONSE_SERILZATION_KEY_TRACK_VIEW_URL ; // @"trackViewUrl"

/// execute in async thread . // 在异步线程内执行
- (void) cc_check_update_with_link : (NSString *) s_link
                    need_to_update : (void (^)(BOOL is_need ,
                                               NSString * s_version_current ,
                                               NSString * s_version_store ,
                                               NSString * s_open_link)) cc_update_block ;

/// has to invoke them before "cc_check_update_with_link:need_to_update" was executed. // 必须在 "cc_check_update_with_link:need_to_update" 执行前调用这些 .
@property (nonatomic , copy) void (^cc_original_response_block)(id original_response) ;
@property (nonatomic , copy) void (^cc_error_block)(NSError *error) ;

@end
