//
//  UIApplication+MQExtension.m
//  MQExtensionKit
//
//  Created by ElwinFrederick on 09/05/2018.
//  Copyright © 2018 冯明庆. All rights reserved.
//

#import "UIApplication+MQExtension.h"

@implementation UIApplication (MQExtension)

UIApplication *MQ_SHARED_APPLICATION(void) {
    return [UIApplication sharedApplication];
}

+ (BOOL) mq_can_open : (id) s_url {
    UIApplication *t = [UIApplication sharedApplication];
    if ([s_url isKindOfClass:[NSURL class]]) {
         return [t canOpenURL:((NSURL *)s_url)];
    }
    if ([s_url isKindOfClass:[NSString class]]) {
        return [t canOpenURL:[NSURL URLWithString:((NSString *)s_url)]];
    }
    return false;
}

+ (void) mq_open_url : (id) s_url {
    [UIApplication mq_open_url:s_url completion:nil];
}
+ (void) mq_open_url : (id) s_url
          completion : (void (^)(BOOL success)) mq_completion_block {
    [UIApplication mq_open_url:s_url options:nil completion:mq_completion_block];
}

+ (void) mq_open_url : (id) s_url
             options : (NSDictionary *) options
          completion : (void (^)(BOOL success)) mq_completion_block {
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
        if (@available(iOS 10.0, *)) {
            [t openURL:can_open_block() options:options ? options : @{} completionHandler:^(BOOL success) {
                if (mq_completion_block) mq_completion_block(success);
            }];
        } else {
            BOOL is_success = [t openURL:can_open_block()] ;
            if (mq_completion_block) mq_completion_block(is_success);
        }
    }
    else if (mq_completion_block) mq_completion_block(false) ;
    
}

@end

@implementation UIApplication (MQExtension_Schemes)

MQThirdPartiesScheme MQ_THIRD_PARTY_SCHEME_QQ = @"mqq://";
MQThirdPartiesScheme MQ_THIRD_PARTY_SCHEME_WECHAT = @"weixin://";
MQThirdPartiesScheme MQ_THIRD_PARTY_SCHEME_SINA_WEIBO = @"sinaweibo://";
MQThirdPartiesScheme MQ_THIRD_PARTY_SCHEME_ALIPAY = @"alipay://";
MQThirdPartiesScheme MQ_THIRD_PARTY_SCHEME_FIND_MY_IPHONE = @"fmip1://";
MQThirdPartiesScheme MQ_THIRD_PARTY_SCHEME_JINGDONG = @"openapp.jdmoble://";
MQThirdPartiesScheme MQ_THIRD_PARTY_SCHEME_DAZHONGDIANPING = @"dianping://";
MQThirdPartiesScheme MQ_THIRD_PARTY_SCHEME_DAZHONGDIANPING_SEARCH = @"dianping://search";
MQThirdPartiesScheme MQ_THIRD_PARTY_SCHEME_MEITUAN = @"imeituan://";
MQThirdPartiesScheme MQ_THIRD_PARTY_SCHEME_WOCHACHA = @"wcc://";
MQThirdPartiesScheme MQ_THIRD_PARTY_SCHEME_1_HAODIAN = @"wccbyihaodian://";
MQThirdPartiesScheme MQ_THIRD_PARTY_SCHEME_ZHIHU = @"zhihu://";
MQThirdPartiesScheme MQ_THIRD_PARTY_SCHEME_YOUKU = @"youku://";
MQThirdPartiesScheme MQ_THIRD_PARTY_SCHEME_YOUDAO_DICT = @"yddictproapp://";
MQThirdPartiesScheme MQ_THIRD_PARTY_SCHEME_NET_EASE_OPEN = @"ntesopen://";
MQThirdPartiesScheme MQ_THIRD_PARTY_SCHEME_TAOBAO = @"taobao://";
MQThirdPartiesScheme MQ_THIRD_PARTY_SCHEME_RENREN = @"renren://";

+ (BOOL) mq_can_open_QQ {
    return [self mq_can_open:MQ_THIRD_PARTY_SCHEME_QQ];
}
+ (BOOL) mq_can_open_WeChat {
    return [self mq_can_open:MQ_THIRD_PARTY_SCHEME_WECHAT];
}
+ (BOOL) mq_can_open_Sina_WeiBo {
    return [self mq_can_open:MQ_THIRD_PARTY_SCHEME_SINA_WEIBO];
}

+ (void) mq_make_call : (NSString *) s_call_num {
    NSString *s_tel = [NSString stringWithFormat:@"tel:%@",s_call_num];
    if (@available(iOS 10.0, *)) {
        [UIApplication mq_open_url:s_tel
                           options:@{UIApplicationOpenURLOptionUniversalLinksOnly : @(false)}
                        completion:nil];
    } else {
        [UIApplication mq_open_url:s_tel
                           options:@{}
                        completion:nil];
    }
}

@end

#pragma mark - -----

@implementation NSURL (MQExtension_Open_Scheme)

- (BOOL) mq_can_open {
    return [UIApplication mq_can_open:self];
}

- (void) mq_open_url_options : (NSDictionary *) options
                  completion : (void (^)(BOOL success)) mq_completion_block {
    [UIApplication mq_open_url:self options:options completion:mq_completion_block];
}

@end

#pragma mark - -----

@implementation NSString (MQExtension_Open_Scheme)

- (BOOL) mq_can_open {
    return [UIApplication mq_can_open:self];
}
- (void) mq_open_url_options : (NSDictionary *) options
                  completion : (void (^)(BOOL success)) mq_completion_block {
    [UIApplication mq_open_url:self options:options completion:mq_completion_block];
}

@end
