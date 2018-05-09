//
//  UIApplication+CCExtension.m
//  CCLocalLibrary
//
//  Created by ElwinFrederick on 09/05/2018.
//  Copyright © 2018 冯明庆. All rights reserved.
//

#import "UIApplication+CCExtension.h"

@implementation UIApplication (CCExtension)

+ (BOOL) cc_can_open : (id) s_url {
    UIApplication *t = [UIApplication sharedApplication];
    if ([s_url isKindOfClass:[NSURL class]]) {
         return [t canOpenURL:((NSURL *)s_url)];
    }
    if ([s_url isKindOfClass:[NSString class]]) {
        return [t canOpenURL:[NSURL URLWithString:((NSString *)s_url)]];
    }
    return false;
}

+ (void) cc_open_url : (id) s_url {
    [UIApplication cc_open_url:s_url completion:nil];
}
+ (void) cc_open_url : (id) s_url
          completion : (void (^)(BOOL success)) cc_completion_block {
    [UIApplication cc_open_url:s_url options:nil completion:cc_completion_block];
}

+ (void) cc_open_url : (id) s_url
             options : (NSDictionary *) options
          completion : (void (^)(BOOL success)) cc_completion_block {
    UIApplication *t = [UIApplication sharedApplication];
    
    id (^can_open_block)(void) = ^id {
        if ([s_url isKindOfClass:[NSURL class]]) {
            if ([t canOpenURL:((NSURL *)s_url)]) {
                return s_url;
            }
        }
        if ([s_url isKindOfClass:[NSString class]]) {
            if ([t canOpenURL:[NSURL URLWithString:((NSString *)s_url)]]) {
                return s_url;
            }
        }
        return nil;
    };
    if (can_open_block) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
        [t openURL:can_open_block() options:options ? options : @{} completionHandler:^(BOOL success) {
            if (cc_completion_block) cc_completion_block(success);
        }];
#else
        BOOL is_success = [t openURL:can_open_block()] ;
        if (cc_completion_block) cc_completion_block(is_success);
#endif
    }
    else if (cc_completion_block) cc_completion_block(false) ;
    
}

@end

#pragma mark - -----

@implementation NSURL (CCExtension_Open_Scheme)

- (BOOL) cc_can_open {
    return [UIApplication cc_can_open:self];
}

- (void) cc_open_url_options : (NSDictionary *) options
                  completion : (void (^)(BOOL success)) cc_completion_block {
    [UIApplication cc_open_url:self options:options completion:cc_completion_block];
}

@end

#pragma mark - -----

@implementation NSString (CCExtension_Open_Scheme)

- (BOOL) cc_can_open {
    return [UIApplication cc_can_open:self];
}
- (void) cc_open_url_options : (NSDictionary *) options
                  completion : (void (^)(BOOL success)) cc_completion_block {
    [UIApplication cc_open_url:self options:options completion:cc_completion_block];
}

@end
