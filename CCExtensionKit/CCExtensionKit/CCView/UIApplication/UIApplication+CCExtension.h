//
//  UIApplication+CCExtension.h
//  CCLocalLibrary
//
//  Created by ElwinFrederick on 09/05/2018.
//  Copyright © 2018 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CC_SHARED_APPLICATION [UIApplication sharedApplication]

@interface UIApplication (CCExtension)

/// supported NSURL && NSString . // 支持 NSURL 和 NSString .
+ (BOOL) cc_can_open : (id) s_url ;
+ (void) cc_open_url : (id) s_url ;
+ (void) cc_open_url : (id) s_url
          completion : (void (^)(BOOL success)) cc_completion_block;
+ (void) cc_open_url : (id) s_url
             options : (NSDictionary *) options // default @{UIApplicationOpenURLOptionUniversalLinksOnly : @(false)} .
          completion : (void (^)(BOOL success)) cc_completion_block;

@end

#pragma mark - -----

@interface NSURL (CCExtension_Open_Scheme)

- (BOOL) cc_can_open ;
- (void) cc_open_url_options : (NSDictionary *) options
                  completion : (void (^)(BOOL success)) cc_completion_block;

@end

#pragma mark - -----

@interface NSString (CCExtension_Open_Scheme)

- (BOOL) cc_can_open ;
- (void) cc_open_url_options : (NSDictionary *) options
                  completion : (void (^)(BOOL success)) cc_completion_block;

@end
