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
    if (![s_link isKindOfClass:NSString.class] || !s_link.length) return self;
    if ([s_link hasPrefix:@"http://"] || [s_link hasPrefix:@"https://"]) {
        return [self mq_request:s_link navigation:nil];
    } else return [self mq_content:s_link navigation:nil];
}

- (instancetype) mq_request : (NSString *) s_link
                navigation : (void (^)(WKNavigation *navigation)) navigation {
    WKNavigation *n = [self loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:s_link && s_link.length? s_link : @""]]];
    if (navigation) navigation(n);
    return self;
}

- (instancetype) mq_content : (NSString *) content
                navigation : (void (^)(WKNavigation *navigation)) navigation {
    WKNavigation *n = [self loadHTMLString:(content && content.length) ? content : @"" baseURL:nil];
    if (navigation) navigation(n);
    return self;
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
