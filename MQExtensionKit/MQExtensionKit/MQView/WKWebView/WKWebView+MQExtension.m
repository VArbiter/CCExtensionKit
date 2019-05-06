//
//  WKWebView+MQExtension.m
//  MQExtensionKit
//
//  Created by 冯明庆 on 2017/4/1.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "WKWebView+MQExtension.h"

@implementation WKWebView (MQExtension)

+ (instancetype) mq_common : (CGRect) frame {
    return [self mq_common:frame configuration:nil];
}
+ (instancetype) mq_common : (CGRect) frame
             configuration : (WKWebViewConfiguration *) configuration {
    WKWebView *v = nil;
    if (configuration) {
        v = [[WKWebView alloc] initWithFrame:frame
                                     configuration:configuration];
    } else v = [[WKWebView alloc] initWithFrame:frame];
    v.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    v.autoresizesSubviews = YES;
    v.allowsBackForwardNavigationGestures = YES;
    v.scrollView.alwaysBounceVertical = YES;
    v.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
    return v;
}
- (instancetype) mq_navigation_delegate:(id<WKNavigationDelegate>)delegate {
    self.navigationDelegate = delegate;
    return self;
}
- (instancetype) mq_script : (MQScriptMessageDelegate *) delegate
                       key : (NSString *) s_key  {
    if (delegate && s_key) {
        [self.configuration.userContentController addScriptMessageHandler:delegate
                                                                     name:s_key];
    }
    else if (s_key && s_key.length) {
         [self.configuration.userContentController removeScriptMessageHandlerForName:s_key];
    }
    return self;
}

- (instancetype) mq_loading : (NSString *) s_link
                 navigation : (void (^)(WKNavigation *navigation)) navigation {
    return [self mq_loading:s_link
               cache_policy:NSURLRequestUseProtocolCachePolicy
                    timeout:20
                   base_url:nil
                 navigation:navigation];
}

- (instancetype) mq_loading : (NSString *) s_link
               cache_policy : (NSURLRequestCachePolicy) policy
                    timeout : (NSTimeInterval) interval
                   base_url : (NSURL *) url
                 navigation : (void (^)(WKNavigation *navigation)) navigation {
    if (![s_link isKindOfClass:NSString.class] || !s_link.length) return self;
    if ([s_link hasPrefix:@"http://"] || [s_link hasPrefix:@"https://"]) {
        return [self mq_request:s_link cache_policy:policy timeout:interval navigation:navigation];
    } else return [self mq_content:s_link base_url:url navigation:navigation];
}

- (instancetype) mq_request : (NSString *) s_link
                navigation : (void (^)(WKNavigation *navigation)) navigation {
    return [self mq_request:s_link
               cache_policy:NSURLRequestUseProtocolCachePolicy
                    timeout:20
                 navigation:navigation];
}

- (instancetype) mq_request : (NSString *) s_link
               cache_policy : (NSURLRequestCachePolicy) policy
                    timeout : (NSTimeInterval) interval
                 navigation : (void (^)(WKNavigation *navigation)) navigation {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:s_link && s_link.length? s_link : @""]
                                             cachePolicy:policy
                                         timeoutInterval:interval];
    WKNavigation *n = [self loadRequest:request];
    if (navigation) navigation(n);
    return self;
}

- (instancetype) mq_content : (NSString *) content
                navigation : (void (^)(WKNavigation *navigation)) navigation {
    return [self mq_content:content
                   base_url:nil
                 navigation:navigation];
}

- (instancetype) mq_content : (NSString *) content
                   base_url : (NSURL *) url
                 navigation : (void (^)(WKNavigation *navigation)) navigation {
    WKNavigation *n = [self loadHTMLString:(content && content.length) ? content : @"" baseURL:url];
    if (navigation) navigation(n);
    return self;
}

- (WKNavigation *) mq_go_back {
    if ([self canGoBack]) {
        return [self goBack];
    }
    return nil ;
}
- (WKNavigation *) mq_go_foward {
    if ([self canGoForward]) {
        return [self goForward];
    }
    return nil;
}
- (WKNavigation *) mq_reload : (BOOL) is_origin {
    if (is_origin) {
        return [self reloadFromOrigin];
    }
    else return [self reload];
}

@end

#pragma mark - -----

@implementation MQScriptMessageDelegate

- (instancetype)init:(id<WKScriptMessageHandler>)script_delegate{
    if ((self = [super init])) {
        self.script_delegate = script_delegate;
    }
    return self;
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    [self.script_delegate userContentController:userContentController didReceiveScriptMessage:message];
}

@end
