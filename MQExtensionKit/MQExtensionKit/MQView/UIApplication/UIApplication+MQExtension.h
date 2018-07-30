//
//  UIApplication+MQExtension.h
//  MQExtensionKit
//
//  Created by ElwinFrederick on 09/05/2018.
//  Copyright © 2018 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CC_SHARED_APPLICATION [UIApplication sharedApplication]

@interface UIApplication (MQExtension)

/// supported NSURL && NSString . // 支持 NSURL 和 NSString .
+ (BOOL) mq_can_open : (id) s_url ;
+ (void) mq_open_url : (id) s_url ;
+ (void) mq_open_url : (id) s_url
          completion : (void (^)(BOOL success)) mq_completion_block;
+ (void) mq_open_url : (id) s_url
             options : (NSDictionary *) options // default @{UIApplicationOpenURLOptionUniversalLinksOnly : @(false)} .
          completion : (void (^)(BOOL success)) mq_completion_block;

@end

#pragma mark - -----

typedef NSString * CCThirdPartiesScheme NS_EXTENSIBLE_STRING_ENUM;

@interface UIApplication (MQExtension_Schemes)

FOUNDATION_EXPORT CCThirdPartiesScheme CC_THIRD_PARTY_SCHEME_QQ ; // QQ
FOUNDATION_EXPORT CCThirdPartiesScheme CC_THIRD_PARTY_SCHEME_WECHAT ; // 微信
FOUNDATION_EXPORT CCThirdPartiesScheme CC_THIRD_PARTY_SCHEME_SINA_WEIBO ; // 新浪微博
FOUNDATION_EXPORT CCThirdPartiesScheme CC_THIRD_PARTY_SCHEME_ALIPAY ; // 支付宝
FOUNDATION_EXPORT CCThirdPartiesScheme CC_THIRD_PARTY_SCHEME_FIND_MY_IPHONE ; // 查找我的 iPhone
FOUNDATION_EXPORT CCThirdPartiesScheme CC_THIRD_PARTY_SCHEME_JINGDONG ; // 京东
FOUNDATION_EXPORT CCThirdPartiesScheme CC_THIRD_PARTY_SCHEME_DAZHONGDIANPING ; // 大众点评
FOUNDATION_EXPORT CCThirdPartiesScheme CC_THIRD_PARTY_SCHEME_DAZHONGDIANPING_SEARCH ; // 大众点评 , 搜索
FOUNDATION_EXPORT CCThirdPartiesScheme CC_THIRD_PARTY_SCHEME_MEITUAN ; // 美团
FOUNDATION_EXPORT CCThirdPartiesScheme CC_THIRD_PARTY_SCHEME_WOCHACHA ; // 我查查
FOUNDATION_EXPORT CCThirdPartiesScheme CC_THIRD_PARTY_SCHEME_1_HAODIAN ; // 1号店
FOUNDATION_EXPORT CCThirdPartiesScheme CC_THIRD_PARTY_SCHEME_ZHIHU ; // 知乎
FOUNDATION_EXPORT CCThirdPartiesScheme CC_THIRD_PARTY_SCHEME_YOUKU ; // 优酷
FOUNDATION_EXPORT CCThirdPartiesScheme CC_THIRD_PARTY_SCHEME_YOUDAO_DICT ; // 有道词典
FOUNDATION_EXPORT CCThirdPartiesScheme CC_THIRD_PARTY_SCHEME_NET_EASE_OPEN ; // 网易公开课
FOUNDATION_EXPORT CCThirdPartiesScheme CC_THIRD_PARTY_SCHEME_TAOBAO ; // 淘宝
FOUNDATION_EXPORT CCThirdPartiesScheme CC_THIRD_PARTY_SCHEME_RENREN ; // 人人

+ (BOOL) mq_can_open_QQ ;
+ (BOOL) mq_can_open_WeChat ;
+ (BOOL) mq_can_open_Sina_WeiBo ;

+ (void) mq_make_call : (NSString *) s_call_num ;

@end

#pragma mark - -----

@interface NSURL (MQExtension_Open_Scheme)

- (BOOL) mq_can_open ;
- (void) mq_open_url_options : (NSDictionary *) options
                  completion : (void (^)(BOOL success)) mq_completion_block;

@end

#pragma mark - -----

@interface NSString (MQExtension_Open_Scheme)

- (BOOL) mq_can_open ;
- (void) mq_open_url_options : (NSDictionary *) options
                  completion : (void (^)(BOOL success)) mq_completion_block;

@end
