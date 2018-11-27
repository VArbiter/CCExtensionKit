//
//  WKWebView+MQExtension.h
//  MQExtensionKit
//
//  Created by 冯明庆 on 2017/4/1.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <WebKit/WebKit.h>

@class  MQScriptMessageDelegate;

@interface WKWebView (MQExtension)

+ (instancetype) mq_common : (CGRect) frame;
+ (instancetype) mq_common : (CGRect) frame
             configuration : (WKWebViewConfiguration *) configuration ;
- (instancetype) mq_navigation_delegate : (id <WKNavigationDelegate>) delegate ;
- (instancetype) mq_script : (MQScriptMessageDelegate *) delegate
                       key : (NSString *) s_key;

/// Only "http://" && "https://" will be loaded online . // 只有 "http://" && "https://" 会被当做网址
/// others will be loading as HTML content . // 其它的会被当做 HTML 文本
- (instancetype) mq_loading : (NSString *) s_link
                 navigation : (void (^)(WKNavigation *navigation)) navigation ;
/// loading as links // 使用 网页加载
- (instancetype) mq_request : (NSString *) s_link
                 navigation : (void (^)(WKNavigation *navigation)) navigation ;
/// loading as HTML content // 使用 HTML 文本加载
- (instancetype) mq_content : (NSString *) content
                 navigation : (void (^)(WKNavigation *navigation)) navigation ;

- (WKNavigation *) mq_go_back ;
- (WKNavigation *) mq_go_foward ;
- (WKNavigation *) mq_reload : (BOOL) is_origin ;

@end

#pragma mark - -----

@interface MQScriptMessageDelegate : NSObject < WKScriptMessageHandler >

@property (nonatomic , assign) id < WKScriptMessageHandler > script_delegate;

- (instancetype) init:(id < WKScriptMessageHandler > ) script_delegate;

@end
