//
//  WKWebView+CCExtension.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/1.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "WKWebView+CCExtension.h"

#import "NSString+CCExtension.h"

#import "CCCommonDefine.h"

@implementation WKWebView (CCExtension)

+ (instancetype) ccInitWithFrame : (CGRect) rectFrame {
    return [self ccInitWithFrame:rectFrame withDelegate:nil];
}

+ (instancetype) ccInitWithFrame : (CGRect)rectFrame
                    withDelegate : (id) delegate {
    return [self ccInitWithFrame:rectFrame withConfiguration:nil withDelegate:delegate];
}

+ (instancetype) ccInitWithFrame : (CGRect)rectFrame
               withConfiguration : (WKWebViewConfiguration *) configuration
                    withDelegate : (id) delegate {
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

- (WKNavigation *) ccLoadRequest : (NSString *) stringRequest {
    return [self loadRequest:[NSURLRequest requestWithURL:ccURL(stringRequest, false)]];
}

- (WKNavigation *) ccLoadHTMLString : (NSString *) stringHTML {
    if ([stringHTML isKindOfClass:[NSString class]])
        if (stringHTML.ccIsStringValued)
            return [self loadHTMLString:stringHTML
                                baseURL:nil];
    return nil;
}

@end
