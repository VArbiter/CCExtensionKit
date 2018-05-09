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

@implementation UIApplication (CCExtension_Schemes)

CCThirdPartiesScheme CC_THIRD_PARTY_SCHEME_QQ = @"mqq://";
CCThirdPartiesScheme CC_THIRD_PARTY_SCHEME_WECHAT = @"weixin://";
CCThirdPartiesScheme CC_THIRD_PARTY_SCHEME_SINA_WEIBO = @"sinaweibo://";
CCThirdPartiesScheme CC_THIRD_PARTY_SCHEME_ALIPAY = @"alipay://";
CCThirdPartiesScheme CC_THIRD_PARTY_SCHEME_FIND_MY_IPHONE = @"fmip1://";
CCThirdPartiesScheme CC_THIRD_PARTY_SCHEME_JINGDONG = @"openapp.jdmoble://";
CCThirdPartiesScheme CC_THIRD_PARTY_SCHEME_DAZHONGDIANPING = @"dianping://";
CCThirdPartiesScheme CC_THIRD_PARTY_SCHEME_DAZHONGDIANPING_SEARCH = @"dianping://search";
CCThirdPartiesScheme CC_THIRD_PARTY_SCHEME_MEITUAN = @"imeituan://";
CCThirdPartiesScheme CC_THIRD_PARTY_SCHEME_WOCHACHA = @"wcc://";
CCThirdPartiesScheme CC_THIRD_PARTY_SCHEME_1_HAODIAN = @"wccbyihaodian://";
CCThirdPartiesScheme CC_THIRD_PARTY_SCHEME_ZHIHU = @"zhihu://";
CCThirdPartiesScheme CC_THIRD_PARTY_SCHEME_YOUKU = @"youku://";
CCThirdPartiesScheme CC_THIRD_PARTY_SCHEME_YOUDAO_DICT = @"yddictproapp://";
CCThirdPartiesScheme CC_THIRD_PARTY_SCHEME_NET_EASE_OPEN = @"ntesopen://";
CCThirdPartiesScheme CC_THIRD_PARTY_SCHEME_TAOBAO = @"taobao://";
CCThirdPartiesScheme CC_THIRD_PARTY_SCHEME_RENREN = @"renren://";

+ (BOOL) cc_can_open_QQ {
    return [self cc_can_open:CC_THIRD_PARTY_SCHEME_QQ];
}
+ (BOOL) cc_can_open_WeChat {
    return [self cc_can_open:CC_THIRD_PARTY_SCHEME_WECHAT];
}
+ (BOOL) cc_can_open_Sina_WeiBo {
    return [self cc_can_open:CC_THIRD_PARTY_SCHEME_SINA_WEIBO];
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
