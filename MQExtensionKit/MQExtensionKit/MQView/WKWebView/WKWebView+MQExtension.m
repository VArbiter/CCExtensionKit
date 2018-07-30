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
                       key : (NSString *) sKey  {
    if (delegate && sKey) {
        [self.configuration.userContentController addScriptMessageHandler:delegate
                                                                     name:sKey];
    }
    else if (sKey && sKey.length) {
         [self.configuration.userContentController removeScriptMessageHandlerForName:sKey];
    }
    return self;
}

- (instancetype) mq_loading : (NSString *) sLink
                 navigation : (void (^)(WKNavigation *navigation)) navigation {
    if (![sLink isKindOfClass:NSString.class] || !sLink.length) return self;
    if ([sLink hasPrefix:@"http://"] || [sLink hasPrefix:@"https://"]) {
        return [self mq_request:sLink navigation:nil];
    } else return [self mq_content:sLink navigation:nil];
}

- (instancetype) mq_request : (NSString *) sLink
                navigation : (void (^)(WKNavigation *navigation)) navigation {
    WKNavigation *n = [self loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:sLink && sLink.length? sLink : @""]]];
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

- (instancetype)init:(id<WKScriptMessageHandler>)scriptDelegate{
    if ((self = [super init])) {
        self.scriptDelegate = scriptDelegate;
    }
    return self;
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    [self.scriptDelegate userContentController:userContentController didReceiveScriptMessage:message];
}

@end
