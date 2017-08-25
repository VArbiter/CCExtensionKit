//
//  WKWebView+CCExtension.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/1.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "WKWebView+CCExtension.h"

#import "NSString+CCExtension.h"

#import "NSObject+CCExtension.h"
#import "CCCommonTools.h"

@implementation WKWebView (CCExtension)

+ (instancetype) ccCommon : (CGRect) rectFrame {
    return [self ccCommon:rectFrame delegate:nil];
}

+ (instancetype) ccCommon : (CGRect)rectFrame
                 delegate : (id) delegate {
    return [self ccCommon:rectFrame configuration:nil delegate:delegate];
}

+ (instancetype) ccCommon : (CGRect)rectFrame
            configuration : (WKWebViewConfiguration *) configuration
                 delegate : (id) delegate {
    WKWebView *webView = nil;
    if (configuration) {
        webView = [[WKWebView alloc] initWithFrame:rectFrame
                                     configuration:configuration];
    } else webView = [[WKWebView alloc] initWithFrame:rectFrame];
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    webView.autoresizesSubviews = YES;
    webView.allowsBackForwardNavigationGestures = YES;
    webView.scrollView.alwaysBounceVertical = YES;
    webView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
    if (delegate) {
        webView.navigationDelegate = delegate;
    }
    return webView;
}

- (WKNavigation *) ccLoad : (NSString *) string {
    if (string.isStringValued) {
        if ([string hasPrefix:@"http://"] || [string hasPrefix:@"https://"]) {
            return [self ccLoadRequest:string];
        } else return [self ccLoadHTMLString:string];
    }
    return nil;
}

- (WKNavigation *) ccLoadRequest : (NSString *) stringRequest {
    return [self loadRequest:[NSURLRequest requestWithURL:ccURL(stringRequest, false)]];
}

- (WKNavigation *) ccLoadHTMLString : (NSString *) stringHTML {
    if ([stringHTML isKindOfClass:[NSString class]])
        if (stringHTML.isStringValued)
            return [self loadHTMLString:stringHTML
                                baseURL:nil];
    return nil;
}

@end

#pragma mark - -----

@implementation CCScriptMessageDelegate

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
